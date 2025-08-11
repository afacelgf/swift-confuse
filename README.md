# swift-
支持swift的代码混淆脚本，只需填入需要混淆的类名，方法名，属性名等即可一键混淆

# 说明 - 
# 需要混淆的符号数组 - 在这里添加你要混淆的类名、方法名等
TARGET_SYMBOLS - 

# 需要混淆的属性数组 - 从TARGET_SYMBOLS的类中提取的自定义属性
TARGET_PROPERTIES

# 要忽略的文件夹
IGNORE_DIRS=("Pods" "thirdLibs")

# 把.sh拖进项目根目录，执行chmod +x simple_confuse.sh后
# 执行混淆
./simple_confuse.sh -c

# 恢复混淆前代码
./simple_confuse.sh -u
