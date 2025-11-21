#!/bin/bash

# 要忽略的文件夹
IGNORE_DIRS=("Pods" "thirdLibs" )

# 需要混淆的数组文件
ARRAYS_FILE="swift_symbols_arrays.sh"

# 文件配置
BACKUP_FILE=".backup.log"
SYMBOL_FILE=".symbol.log"
MAP_FILE="obfuscation_map.txt"
CONFUSE_FLAG=".confuseFlag"
BACKUP_EXTENSION=".bak"
NOT_REPLACED_FILE=".not_replaced.log"
FILE_RENAME_MAP=".file_rename_map.log"
CONTENT_MINI_LENGTH=8 #内容的最小长度

# 输出颜色
info() { echo -e "[\033[1;32minfo\033[0m] $1"; }
error() { echo -e "[\033[1;31merror\033[0m] $1"; }

# 加载数组数据
load_arrays() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local arrays_path="$script_dir/$ARRAYS_FILE"
    
    if [ ! -f "$arrays_path" ]; then
        error "Arrays file not found: $arrays_path"
        error "Please ensure $ARRAYS_FILE exists in the same directory as this script"
        exit 1
    fi
    
    if [ ! -r "$arrays_path" ]; then
        error "Cannot read arrays file: $arrays_path"
        error "Please check file permissions"
        exit 1
    fi
    
    info "Loading arrays from: $arrays_path"
    
    # 使用 source 命令加载数组定义
    source "$arrays_path" || {
        error "Failed to load arrays from $arrays_path"
        error "Please check the file format and syntax"
        exit 1
    }
    
    # 验证数组是否成功加载 - 允许部分数组为空，但不能全部为空
    if [ ${#SWIFT_CLASSES[@]} -eq 0 ] && [ ${#SWIFT_METHODS[@]} -eq 0 ] && [ ${#SWIFT_PROPERTIES[@]} -eq 0 ]; then
        error "All arrays are empty after loading from $arrays_path"
        error "SWIFT_CLASSES: ${#SWIFT_CLASSES[@]} items"
        error "SWIFT_METHODS: ${#SWIFT_METHODS[@]} items"
        error "SWIFT_PROPERTIES: ${#SWIFT_PROPERTIES[@]} items"
        error "At least one array must contain symbols to proceed"
        exit 1
    fi
    
    info "Successfully loaded arrays:"
    info "  SWIFT_CLASSES: ${#SWIFT_CLASSES[@]} items"
    info "  SWIFT_METHODS: ${#SWIFT_METHODS[@]} items"
    info "  SWIFT_PROPERTIES: ${#SWIFT_PROPERTIES[@]} items"
}

# 在脚本开始时加载数组
load_arrays

# 生成随机字符串（仅字母）
randomString() {
    openssl rand -base64 64 | tr -cd 'a-zA-Z' | head -c 16
}

removeIfExist() {
    if [ -f "$1" ]; then rm "$1"; fi
}

ignore_path_args() {
    local args=""
    for dir in "${IGNORE_DIRS[@]}"; do
    args+=" -path \"*/$dir/*\" -prune -o"
    done
    echo "$args"
}

backupFile() {
    local file=$1
    local fileName=${file##*/}
    local backupPath=${file/$fileName/.$fileName$BACKUP_EXTENSION}
    cp "$file" "$backupPath"
    echo "$backupPath" >> $BACKUP_FILE
}

backupAllSource() {
    info "backup all swift files (ignoring: ${IGNORE_DIRS[*]})"
    removeIfExist $BACKUP_FILE
    touch $BACKUP_FILE
    eval "find .. $(ignore_path_args) -name \"*.swift\" -print" | while read file; do
    backupFile "$file"
    done
}

# 更新 Xcode 项目文件中的文件引用
updateXcodeProject() {
    local xcodeproj_path="../Xawa.xcodeproj/project.pbxproj"
    
    if [ ! -f "$xcodeproj_path" ]; then
        info "Xcode project file not found: $xcodeproj_path"
        return
    fi
    
    info "更新 Xcode 项目文件中的文件引用..."
    
    # 备份项目文件
    cp "$xcodeproj_path" "${xcodeproj_path}.bak"
    
    # 读取重命名映射并更新项目文件
    while IFS=$'\t' read -r old_path new_path; do
        [[ -z "$old_path" || -z "$new_path" ]] && continue
        
        local old_filename=$(basename "$old_path")
        local new_filename=$(basename "$new_path")
        
        # 更新项目文件中的文件名引用
        sed -i '' "s|${old_filename}|${new_filename}|g" "$xcodeproj_path"
        
    done < "$FILE_RENAME_MAP"
    
    info "Xcode 项目文件更新完成"
}

# 重命名 Swift 文件（记录映射，便于恢复）
renameSwiftFiles() {
    info "开始重命名 Swift 文件..."
    removeIfExist $FILE_RENAME_MAP
    touch $FILE_RENAME_MAP
    local renamed_count=0
    # 构建安全的 find 参数数组，避免使用 eval
    local find_args=(..)
    for dir in "${IGNORE_DIRS[@]}"; do
        find_args+=( -path "*/$dir/*" -prune -o )
    done
    find_args+=( -type f -name '*.swift' -print0 )

    # 使用 -print0 和按 NUL 分隔读取，避免路径中的空格或特殊字符问题
    while IFS= read -r -d '' file; do
        local dir="$(dirname "$file")"
        local base="$(basename "$file")"
        local rnd="$(randomString)"
        local new_path="${dir}/${rnd}.swift"
        # 避免与现有文件名冲突
        while [ -e "$new_path" ]; do
            rnd="$(randomString)"
            new_path="${dir}/${rnd}.swift"
        done
        if mv "$file" "$new_path"; then
            printf '%s\t%s\n' "$file" "$new_path" >> "$FILE_RENAME_MAP"
            info "Renamed: ${base} -> $(basename "$new_path")"
            ((renamed_count++))
        else
            error "重命名失败: $file"
        fi
    done < <(find "${find_args[@]}")
    info "已重命名 $renamed_count 个文件，映射保存在 $FILE_RENAME_MAP"
    
    # 更新 Xcode 项目文件
    updateXcodeProject
}

confuseOnly() {
    info "Starting confuse process..."
    
    # 记录开始时间
    local start_time=$(date +%s)
    
    # 清理旧映射文件
    removeIfExist $SYMBOL_FILE
    removeIfExist $MAP_FILE
    removeIfExist $NOT_REPLACED_FILE
    
    # 合并所有目标符号，跳过空数组
    ALL_TARGETS=()
    
    # 添加非空数组的元素
    if [ ${#SWIFT_CLASSES[@]} -gt 0 ]; then
        ALL_TARGETS+=("${SWIFT_CLASSES[@]}")
        info "Added ${#SWIFT_CLASSES[@]} class symbols"
    else
        info "Skipping empty SWIFT_CLASSES array"
    fi
    
    if [ ${#SWIFT_METHODS[@]} -gt 0 ]; then
        ALL_TARGETS+=("${SWIFT_METHODS[@]}")
        info "Added ${#SWIFT_METHODS[@]} method symbols"
    else
        info "Skipping empty SWIFT_METHODS array"
    fi
    
    if [ ${#SWIFT_PROPERTIES[@]} -gt 0 ]; then
        ALL_TARGETS+=("${SWIFT_PROPERTIES[@]}")
        info "Added ${#SWIFT_PROPERTIES[@]} property symbols"
    else
        info "Skipping empty SWIFT_PROPERTIES array"
    fi
    
    # 检查合并后的数组是否为空
    if [ ${#ALL_TARGETS[@]} -eq 0 ]; then
        error "No symbols to process! All arrays are empty."
        error "Please check your symbol arrays configuration."
        exit 1
    fi
    
    info "Total symbols to confuse: ${#ALL_TARGETS[@]}"
    
    # 为每个符号生成随机替换字符串
    for symbol in "${ALL_TARGETS[@]}"; do
        # 跳过空字符串和注释行
        [[ -z "$symbol" || "$symbol" =~ ^[[:space:]]*# ]] && continue
        
        # 跳过长度小于$CONTENT_MINI_LENGTH的符号
        if [ ${#symbol} -lt $CONTENT_MINI_LENGTH ]; then
            info "Skipping symbol '$symbol' (length ${#symbol} < $CONTENT_MINI_LENGTH)"
            continue
        fi
        
        rnd=$(randomString)
        echo "$symbol $rnd" >> $SYMBOL_FILE
        echo "$symbol -> $rnd" >> $MAP_FILE
        info "Will replace '$symbol' with '$rnd'"
    done
    
    # 获取所有 Swift 文件 - 修复 macOS 兼容性问题
    swift_files=()
    # 构建安全的 find 参数数组，避免使用 eval
    local find_args=(..)
    for dir in "${IGNORE_DIRS[@]}"; do
        find_args+=( -path "*/$dir/*" -prune -o )
    done
    find_args+=( -type f -name '*.swift' -print0 )
    
    while IFS= read -r -d '' file; do
        swift_files+=("$file")
    done < <(find "${find_args[@]}")
    
    info "Found ${#swift_files[@]} Swift files to process"
    
    # 统计总符号数量
    local total_symbols=0
    while IFS=' ' read -r old new || [[ -n "$old" ]]; do
        [[ -z "$old" || -z "$new" ]] && continue
        [[ -z "$old" || "$old" =~ ^[[:space:]]*# ]] && continue
        ((total_symbols++))
    done < "$SYMBOL_FILE"
    
    info "Total symbols to process: $total_symbols"
    
    # 生成动态 Perl 脚本进行批量替换
    local perl_script_file=$(mktemp)
    cat > "$perl_script_file" << 'PERL_SCRIPT_END'
use strict;
use warnings;

# 读取替换映射
my %replacements;
my $reading_files = 0;
my @files_to_process;
my $current_file_index = 0;

while (my $line = <STDIN>) {
    chomp $line;
    
    # 检查是否到了文件列表部分
    if ($line eq '---FILES---') {
        $reading_files = 1;
        next;
    }
    
    if (!$reading_files) {
        # 读取符号映射
        next if $line =~ /^\s*$/ || $line =~ /^\s*#/;
        my ($old, $new) = split /\s+/, $line, 2;
        next unless defined $old && defined $new && $old ne '' && $new ne '';
        $replacements{$old} = $new;
    } else {
        # 收集文件列表
        my $file = $line;
        push @files_to_process, $file if -f $file;
    }
}

# 处理收集到的文件
my $total_files = scalar @files_to_process;
for my $file (@files_to_process) {
    $current_file_index++;
    my $remaining_files = $total_files - $current_file_index;
    
    # 读取文件内容
    open my $fh, '<', $file or next;
    my $content = do { local $/; <$fh> };
    close $fh;
    
    my $modified = 0;
    
    # 按行处理，避免内存问题
    my @lines = split /\n/, $content, -1;
    for my $line (@lines) {
        my @parts = split /(")/, $line;  # 按双引号分割
        my $in_quotes = 0;
        my $line_modified = 0;
        
        for my $part (@parts) {
            if ($part eq '"') {
                $in_quotes = !$in_quotes;
            } elsif (!$in_quotes) {
                # 引号外 → 批量替换所有符号
                for my $old (keys %replacements) {
                    my $new = $replacements{$old};
                    if ($part =~ s/\b\Q$old\E\b/$new/g) {
                        $line_modified = 1;
                    }
                }
            } else {
                # 引号内 → 处理插值表达式 \(...\)
                if ($part =~ s{
                    (\\\()        # 捕获 "\("
                    (.*?)         # 捕获里面的内容（非贪婪）
                    (\))
                }{
                    my $prefix = $1;
                    my $inside = $2;
                    my $suffix = $3;
                    # 替换插值表达式内的变量
                    for my $old (keys %replacements) {
                        my $new = $replacements{$old};
                        $inside =~ s/\b\Q$old\E\b/$new/g;
                    }
                    "$prefix$inside$suffix";
                }egx) {
                    $line_modified = 1;
                }
            }
        }
        
        if ($line_modified) {
            $line = join('', @parts);
            $modified = 1;
        }
    }
    
    # 如果文件被修改，写回文件
    if ($modified) {
        open my $out_fh, '>', $file or next;
        print $out_fh join("\n", @lines);
        close $out_fh;
        print STDERR "Modified: $file (remaining: $remaining_files files)\n";
    }
}
PERL_SCRIPT_END
    
    # 使用管道将符号映射和文件列表传递给 Perl 脚本
    info "Starting batch replacement with optimized Perl script..."
    {
        cat "$SYMBOL_FILE"
        echo "---FILES---"
        printf '%s\n' "${swift_files[@]}"
    } | perl "$perl_script_file" 2>&1 | while IFS= read -r line; do
        # 显示所有输出，不只是Modified行
        info "$line"
    done
    
    # 清理临时文件
    rm -f "$perl_script_file"
    
    # 计算总耗时
    local end_time=$(date +%s)
    local total_time=$((end_time - start_time))
    local minutes=$((total_time / 60))
    local seconds=$((total_time % 60))

    info "confuse done, mapping saved in $MAP_FILE"
    info "Total time elapsed: ${minutes}m ${seconds}s (${total_time} seconds)"
    if [ -f "$NOT_REPLACED_FILE" ]; then
        info "Some symbols were not replaced. See $NOT_REPLACED_FILE"
    fi
}

unconfuse() {
    info "restore start..."
    # 先恢复文件名（如果存在重命名映射）
    if [ -f "$FILE_RENAME_MAP" ]; then
        info "restoring original file names..."
        while IFS=$'\t' read -r old_path new_path; do
            [[ -z "$old_path" || -z "$new_path" ]] && continue
            if [ -f "$new_path" ]; then
                mv -f "$new_path" "$old_path"
                info "Restored: $(basename \"$new_path\") -> $(basename \"$old_path\")"
            else
                info "Skip: new file not found: $new_path"
            fi
        done < "$FILE_RENAME_MAP"
        removeIfExist $FILE_RENAME_MAP
        
        # 恢复 Xcode 项目文件
        local xcodeproj_path="../Xawa.xcodeproj/project.pbxproj"
        local xcodeproj_backup="${xcodeproj_path}.bak"
        if [ -f "$xcodeproj_backup" ]; then
            mv "$xcodeproj_backup" "$xcodeproj_path"
            info "Xcode 项目文件已恢复"
        fi
    fi
    if [ -f $BACKUP_FILE ]; then
    cat $BACKUP_FILE | while read backup; do
    backupName=${backup##*/}
    fileName=$(echo $backupName | sed "s/^\.//" | sed "s/$BACKUP_EXTENSION$//")
    filePath=${backup/$backupName/$fileName}
    cp "$backup" "$filePath"
    rm "$backup"
    done
    removeIfExist $SYMBOL_FILE
    removeIfExist $BACKUP_FILE
    removeIfExist $MAP_FILE
    removeIfExist $CONFUSE_FLAG
    removeIfExist $NOT_REPLACED_FILE
    info "restore done"
    else
    error "No backup found!"
    fi
}

safeConfuse() {
    unconfuse
    touch $CONFUSE_FLAG
    backupAllSource
    confuseOnly
}

# 新增：带文件重命名的安全混淆
safeConfuseWithRename() {
    unconfuse
    touch $CONFUSE_FLAG
    backupAllSource
    renameSwiftFiles
    confuseOnly
}

cleanBackups() {
    info "cleaning all backup files..."
    
    # 查找并删除所有.bak备份文件
    eval "find . $(ignore_path_args) -name \"*$BACKUP_EXTENSION\" -print" | while read backup; do
    info "Removing backup file: $backup"
    rm "$backup"
    done
    
    # 清理相关的日志和配置文件
    removeIfExist $BACKUP_FILE
    removeIfExist $SYMBOL_FILE
    removeIfExist $MAP_FILE
    removeIfExist $CONFUSE_FLAG
    removeIfExist $NOT_REPLACED_FILE
    removeIfExist $FILE_RENAME_MAP
    
    info "all backup files cleaned"
}

usage() {
    echo -e "\033[1;31musage: ./simple_confuse.sh [-u|c|cf|clean]"
    echo -e "  -u     恢复源码"
    echo -e "  -c     备份并混淆（仅内容混淆，不重命名文件）"
    echo -e "  -cf    备份并混淆（内容混淆 + 文件重命名）"
    echo -e "  -clean 移除所有备份文件，移除后不能恢复"
    echo -e "EXAMPLE:"
    echo -e "  ./simple_confuse.sh -c"
    echo -e "  ./simple_confuse.sh -cf"
    echo -e "  ./simple_confuse.sh -u"
    echo -e "  ./simple_confuse.sh -clean\033[0m"
}

main() {
    case $1 in
    "-u") unconfuse ;;
    "-c") safeConfuse ;;
    "-cf") safeConfuseWithRename ;;
    "-clean") cleanBackups ;;
    *) usage ;;
    esac
}

main $@
