# 本人自测app已上线，之前没混淆之前是4.3，混淆之后1.0顺利上线
## 支持swift的代码混淆脚本，只需填入需要混淆的类名，方法名，属性名等即可一键混淆

## 说明 
### 需要混淆的符号数组 - 在这里添加你要混淆的类名、方法名、属性等
swift_symbols_arrays

### 要忽略的文件夹
IGNORE_DIRS=("Pods" "thirdLibs")

## 把.sh拖进项目根目录，执行chmod +x simple_confuse.sh后
### 执行混淆
`./simple_confuse.sh -c` 混淆代码
`./simple_confuse.sh -cf` 混淆代码及修改文件名

### 恢复混淆前代码
`./simple_confuse.sh -u`

### 生成随机代码
`./generate_random_dummy_code.sh`  //如果生成失败，检查脚本路径和待插入文件的路径
