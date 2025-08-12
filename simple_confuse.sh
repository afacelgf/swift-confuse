#!/bin/bash

#  Swift 简单混淆脚本（Perl 替换版 - 更可靠）
#  使用: ./simple_confuse.sh -c  (混淆)  |  ./simple_confuse.sh -u (恢复)

# 需要混淆的符号数组 - 在这里添加你要混淆的类名、方法名等
TARGET_SYMBOLS=(
    #仅为示例
    "DYLogger"
   
)


# 需要混淆的属性数组 - 从TARGET_SYMBOLS的类中提取的自定义属性
TARGET_PROPERTIES=(
    # DYMineVC 自定义属性
    "userInfoV"
)

# 要忽略的文件夹
IGNORE_DIRS=("Pods" "thirdLibs")

# 文件配置
BACKUP_FILE=".backup.log"
SYMBOL_FILE=".symbol.log"
MAP_FILE="obfuscation_map.txt"
CONFUSE_FLAG=".confuseFlag"
BACKUP_EXTENSION=".bak"
NOT_REPLACED_FILE=".not_replaced.log"

# 输出颜色
info() { echo -e "[\033[1;32minfo\033[0m] $1"; }
error() { echo -e "[\033[1;31merror\033[0m] $1"; }

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
    eval "find . $(ignore_path_args) -name \"*.swift\" -print" | while read file; do
        backupFile "$file"
    done
}

confuseOnly() {
    info "Starting confuse process..."
    
    # 清理旧映射文件
    removeIfExist $SYMBOL_FILE
    removeIfExist $MAP_FILE
    removeIfExist $NOT_REPLACED_FILE

    # 合并所有目标符号
    ALL_TARGETS=("${TARGET_SYMBOLS[@]}" "${TARGET_PROPERTIES[@]}")
    
    # 为每个符号生成随机替换字符串
    for symbol in "${ALL_TARGETS[@]}"; do
        # 跳过空字符串和注释行
        [[ -z "$symbol" || "$symbol" =~ ^[[:space:]]*# ]] && continue
        
        rnd=$(randomString)
        echo "$symbol $rnd" >> $SYMBOL_FILE
        echo "$symbol -> $rnd" >> $MAP_FILE
        info "Will replace '$symbol' with '$rnd'"
    done

    # 获取所有 Swift 文件 - 修复 macOS 兼容性问题
    swift_files=()
    while IFS= read -r -d '' file; do
        swift_files+=("$file")
    done < <(find . -name "*.swift" -not -path "*/Pods/*" -not -path "*/thirdLibs/*" -print0)
    
    info "Found ${#swift_files[@]} Swift files to process"

    # 读取映射并执行替换（使用 Perl 做可靠的 \b 边界替换）
    while IFS=' ' read -r old new || [[ -n "$old" ]]; do
        [[ -z "$old" || -z "$new" ]] && continue
        
        info "Processing replacement: $old -> $new"
        replaced_any=0

        for file in "${swift_files[@]}"; do
            [[ ! -f "$file" ]] && continue

            # 先快速检查文件中是否包含旧标识（避免无谓的 perl 调用）
            if grep -q -F "$old" "$file" 2>/dev/null; then
                # 使用 Perl 进行替换：\b + \Q...\E 来保证转义旧符号
                # 这里使用 -i（就地修改，不留额外扩展），-pe 循环处理每行
                perl -i -pe 's/\b\Q'"$old"'\E\b/'"$new"'/g' "$file" 2>/dev/null || {
                    error "perl failed on $file for $old"
                    continue
                }

                # 如果替换后文件出现了新名字，则认为某处成功替换
                if grep -q -F "$new" "$file" 2>/dev/null; then
                    info "✓ Replaced '$old' -> '$new' in $(basename "$file")"
                    replaced_any=1
                fi
            fi
        done

        if [ "$replaced_any" -eq 0 ]; then
            # 记录未被替换（可能是没有出现该符号，或符号只出现在非 .swift 文件中）
            echo "$old $new" >> $NOT_REPLACED_FILE
            info "⚠ '$old' not found in any processed Swift file (recorded to $NOT_REPLACED_FILE)"
        fi
    done < "$SYMBOL_FILE"
    
    info "confuse done, mapping saved in $MAP_FILE"
    if [ -f "$NOT_REPLACED_FILE" ]; then
        info "Some symbols were not replaced. See $NOT_REPLACED_FILE"
    fi
}

unconfuse() {
    info "restore start..."
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
    
    info "all backup files cleaned"
}

usage() {
    echo -e "\033[1;31musage: ./simple_confuse.sh [-u|c|clean]"
    echo -e "  -u     恢复源码"
    echo -e "  -c     备份并混淆"
    echo -e "  -clean 移除所有备份文件，移除后不能恢复"
    echo -e "EXAMPLE:"
    echo -e "  ./simple_confuse.sh -c"
    echo -e "  ./simple_confuse.sh -u"
    echo -e "  ./simple_confuse.sh -clean\033[0m"
}

main() {
    case $1 in
        "-u") unconfuse ;;
        "-c") safeConfuse ;;
        "-clean") cleanBackups ;;
        *) usage ;;
    esac
}

main $@
