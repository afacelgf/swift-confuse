#!/bin/bash

# 修改图片MD5值脚本
# 功能：修改指定目录下所有图片的MD5值，但保持图片大小和分辨率不变
# 原理：在图片文件末尾添加少量随机数据，不影响图片显示
# - 自动备份 ：处理前自动创建.backup备份文件
# - 支持多格式 ：PNG、JPG、JPEG、GIF等常见图片格式

# 基本使用 （使用默认路径）
# ./modify_image_md5.sh

# 自定义路径使用
# ./modify_image_md5.sh /path/to/Assets.xcassets
# 恢复备份 ：
# ./modify_image_md5.sh --restore

# 清理备份文件 ：
# ./modify_image_md5.sh --clean


# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 默认目标目录 - 使用相对路径，自动查找项目中的Assets.xcassets
find_assets_directory() {
    local search_paths=(
        "./Assets.xcassets"                    # 当前目录
        "./*/Assets.xcassets"                  # 一级子目录
        "./*/*/Assets.xcassets"                # 二级子目录
        "./localDrawMJ/Assets.xcassets"        # 特定项目结构
    )
    
    for path in "${search_paths[@]}"; do
        if [[ -d $path ]]; then
            echo "$(cd "$(dirname "$path")" && pwd)/$(basename "$path")"
            return 0
        fi
    done
    
    return 1
}

# 设置默认目录
DEFAULT_DIR=$(find_assets_directory)
if [[ -z "$DEFAULT_DIR" ]]; then
    DEFAULT_DIR="./Assets.xcassets"  # 如果找不到，使用当前目录下的默认路径
fi
# 使用说明
show_usage() {
    echo -e "${BLUE}图片MD5修改脚本${NC}"
    echo -e "${YELLOW}用法:${NC}"
    echo "  $0 [目录路径]"
    echo ""
    echo -e "${YELLOW}参数:${NC}"
    echo "  目录路径    要处理的Assets.xcassets目录路径 (可选，默认: $DEFAULT_DIR)"
    echo ""
    echo -e "${YELLOW}示例:${NC}"
    echo "  $0"
    echo "  $0 /path/to/Assets.xcassets"
    echo ""
    echo -e "${YELLOW}说明:${NC}"
    echo "  - 脚本会修改指定目录下所有图片文件的MD5值"
    echo "  - 通过在文件末尾添加随机数据实现，不影响图片显示"
    echo "  - 支持的格式: PNG, JPG, JPEG, GIF"
    echo "  - 会自动备份原始文件"
}

# 生成随机字节数据
generate_random_data() {
    local size=$1
    # 生成指定大小的随机数据
    openssl rand $size 2>/dev/null || dd if=/dev/urandom bs=1 count=$size 2>/dev/null
}

# 修改单个图片文件的MD5
modify_image_md5() {
    local file_path="$1"
    local file_name=$(basename "$file_path")
    local dir_name=$(dirname "$file_path")
    
    echo -e "${BLUE}处理文件:${NC} $file_name"
    
    # 检查文件是否存在
    if [[ ! -f "$file_path" ]]; then
        echo -e "${RED}错误: 文件不存在 $file_path${NC}"
        return 1
    fi
    
    # 获取原始MD5
    local original_md5=$(md5 -q "$file_path" 2>/dev/null || md5sum "$file_path" 2>/dev/null | cut -d' ' -f1)
    echo -e "  原始MD5: ${YELLOW}$original_md5${NC}"
    
    # 创建备份
    local backup_path="${file_path}.backup"
    cp "$file_path" "$backup_path"
    echo -e "  ${GREEN}已创建备份:${NC} ${backup_path}"
    
    # 生成1-16字节的随机数据
    local random_size=$((RANDOM % 16 + 1))
    local random_data=$(generate_random_data $random_size)
    
    # 将随机数据追加到文件末尾
    echo -n "$random_data" >> "$file_path"
    
    # 获取新的MD5
    local new_md5=$(md5 -q "$file_path" 2>/dev/null || md5sum "$file_path" 2>/dev/null | cut -d' ' -f1)
    echo -e "  新的MD5: ${GREEN}$new_md5${NC}"
    
    # 验证MD5是否改变
    if [[ "$original_md5" != "$new_md5" ]]; then
        echo -e "  ${GREEN}✓ MD5修改成功${NC}"
        return 0
    else
        echo -e "  ${RED}✗ MD5修改失败，恢复原文件${NC}"
        mv "$backup_path" "$file_path"
        return 1
    fi
}

# 处理目录中的所有图片文件
process_directory() {
    local target_dir="$1"
    
    echo -e "${BLUE}开始处理目录:${NC} $target_dir"
    echo ""
    
    # 检查目录是否存在
    if [[ ! -d "$target_dir" ]]; then
        echo -e "${RED}错误: 目录不存在 $target_dir${NC}"
        return 1
    fi
    
    local processed_count=0
    local success_count=0
    local failed_count=0
    
    # 查找所有图片文件
    while IFS= read -r -d '' file; do
        # 检查文件扩展名
        case "${file##*.}" in
            png|PNG|jpg|JPG|jpeg|JPEG|gif|GIF)
                ((processed_count++))
                if modify_image_md5 "$file"; then
                    ((success_count++))
                else
                    ((failed_count++))
                fi
                echo ""
                ;;
        esac
    done < <(find "$target_dir" -type f -print0)
    
    # 显示处理结果
    echo -e "${BLUE}处理完成!${NC}"
    echo -e "总共处理: ${YELLOW}$processed_count${NC} 个图片文件"
    echo -e "成功修改: ${GREEN}$success_count${NC} 个"
    echo -e "修改失败: ${RED}$failed_count${NC} 个"
    
    if [[ $failed_count -eq 0 ]]; then
        echo -e "${GREEN}所有图片MD5修改成功!${NC}"
    else
        echo -e "${YELLOW}部分图片修改失败，请检查错误信息${NC}"
    fi
}

# 恢复备份文件
restore_backups() {
    local target_dir="$1"
    
    echo -e "${YELLOW}正在恢复备份文件...${NC}"
    
    local restore_count=0
    while IFS= read -r -d '' backup_file; do
        local original_file="${backup_file%.backup}"
        if [[ -f "$backup_file" ]]; then
            mv "$backup_file" "$original_file"
            echo -e "${GREEN}已恢复:${NC} $(basename "$original_file")"
            ((restore_count++))
        fi
    done < <(find "$target_dir" -name "*.backup" -type f -print0)
    
    echo -e "${GREEN}恢复完成! 共恢复 $restore_count 个文件${NC}"
}

# 清理备份文件
clean_backups() {
    local target_dir="$1"
    
    echo -e "${YELLOW}正在清理备份文件...${NC}"
    
    local clean_count=0
    while IFS= read -r -d '' backup_file; do
        if [[ -f "$backup_file" ]]; then
            rm "$backup_file"
            echo -e "${GREEN}已删除备份:${NC} $(basename "$backup_file")"
            ((clean_count++))
        fi
    done < <(find "$target_dir" -name "*.backup" -type f -print0)
    
    echo -e "${GREEN}清理完成! 共删除 $clean_count 个备份文件${NC}"
}

# 主函数
main() {
    # 解析命令行参数
    case "$1" in
        -h|--help)
            show_usage
            exit 0
            ;;
        --restore)
            local dir="${2:-$DEFAULT_DIR}"
            restore_backups "$dir"
            exit 0
            ;;
        --clean)
            local dir="${2:-$DEFAULT_DIR}"
            clean_backups "$dir"
            exit 0
            ;;
        "")
            local target_dir="$DEFAULT_DIR"
            ;;
        *)
            local target_dir="$1"
            ;;
    esac
    
    echo -e "${BLUE}=== 图片MD5修改脚本 ===${NC}"
    echo ""
    
    # 确认操作
    echo -e "${YELLOW}即将修改以下目录中所有图片的MD5值:${NC}"
    echo "$target_dir"
    echo ""
    echo -e "${YELLOW}注意: 此操作会修改图片文件，建议先备份整个项目${NC}"
    echo -e "${YELLOW}脚本会自动创建.backup文件作为备份${NC}"
    echo ""
    read -p "确认继续? (y/N): " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}操作已取消${NC}"
        exit 0
    fi
    
    echo ""
    process_directory "$target_dir"
    
    echo ""
    echo -e "${BLUE}可用的后续操作:${NC}"
    echo "  恢复备份: $0 --restore [$target_dir]"
    echo "  清理备份: $0 --clean [$target_dir]"
}

# 检查依赖
check_dependencies() {
    local missing_deps=()
    
    # 检查必要的命令
    command -v find >/dev/null 2>&1 || missing_deps+=("find")
    command -v openssl >/dev/null 2>&1 && command -v dd >/dev/null 2>&1 || missing_deps+=("openssl或dd")
    
    if command -v md5 >/dev/null 2>&1; then
        : # macOS md5 command available
    elif command -v md5sum >/dev/null 2>&1; then
        : # Linux md5sum command available
    else
        missing_deps+=("md5或md5sum")
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        echo -e "${RED}错误: 缺少必要的依赖命令:${NC}"
        printf '%s\n' "${missing_deps[@]}"
        exit 1
    fi
}

# 脚本入口
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    check_dependencies
    main "$@"
fi