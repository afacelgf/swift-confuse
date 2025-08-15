#!/bin/bash
# 批量修改目录下所有 GIF 的 MD5，不改变显示效果，自动备份原文件
# 用法：
#chmod +x change_gif_md5_batch_backup.sh
#./change_gif_md5_batch_backup.sh /path/to/gif_folder
if [ $# -lt 1 ]; then
    echo "用法: $0 目录路径"
    exit 1
fi

dir="$1"
if [ ! -d "$dir" ]; then
    echo "❌ 目录不存在: $dir"
    exit 1
fi

# 备份目录
backup_dir="$dir/backup"
mkdir -p "$backup_dir"

# 遍历目录下所有 GIF（排除备份目录）
find "$dir" -type f -iname "*.gif" ! -path "$backup_dir/*" | while read -r file; do
    # 计算原 MD5
    old_md5=$(md5 -q "$file" 2>/dev/null || md5sum "$file" | awk '{print $1}')

    # 生成对应的备份路径
    rel_path="${file#$dir/}"
    backup_path="$backup_dir/$rel_path"
    mkdir -p "$(dirname "$backup_path")"

    # 备份文件
    cp -p "$file" "$backup_path"

    # 在末尾追加一个随机字节
    dd if=/dev/urandom bs=1 count=1 >> "$file" 2>/dev/null

    # 计算新 MD5
    new_md5=$(md5 -q "$file" 2>/dev/null || md5sum "$file" | awk '{print $1}')

    echo "✅ 已修改: $file"
    echo "   原 MD5: $old_md5"
    echo "   新 MD5: $new_md5"
    echo "   备份文件: $backup_path"
done
