#!/bin/bash
#
# 功能：提取 Swift 符号并清理重复项
#
# 提取 Swift 符号
# 清理重复项
# 输出到文件

set -e

DEFAULT_DIR="localDrawMJ"
OUTPUT_FILE="swift_symbols_clean.txt"

# 要忽略的文件夹数组
IGNORE_DIRS=("Pods" "thirdLibs" "diffusion" )

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 系统保留关键字 / 类名 / 方法名 / 属性名黑名单  # 改动
# ===== 系统符号黑名单 =====
SYSTEM_SYMBOLS=(
    # --- App 生命周期 ---
    AppDelegate
    SceneDelegate
    UIApplication
    UIApplicationDelegate
    UIResponder
    UIWindow
    UIWindowScene
    UIWindowSceneDelegate

    # --- UIKit 基础类 ---
    UIView
    UIViewController
    UITableView
    UITableViewCell
    UITableViewController
    UICollectionView
    UICollectionViewCell
    UICollectionReusableView
    UICollectionViewController
    UINavigationController
    UITabBarController
    UITabBar
    UITabBarItem
    UIBarButtonItem
    UIButton
    UILabel
    UIImage
    UIImageView
    UIScrollView
    UIStackView
    UIControl
    UITextField
    UITextView
    UISwitch
    UISlider
    UIProgressView
    UIPageControl
    UIAlertController
    UIAlertAction
    UIDatePicker
    UIPickerView
    UIActivityIndicatorView
    UIColor
    UIFont
    UIScreen
    UIWindowScene

    # --- Foundation 基础类 ---
    NSObject
    NSCoder
    NSError
    URL
    URLRequest
    URLSession
    URLSessionDataTask
    Date
    Data
    Timer
    IndexPath
    IndexSet
    Notification
    NotificationCenter
    Bundle
    UserDefaults
    FileManager
    OperationQueue
    DispatchQueue
    DispatchGroup
    JSONDecoder
    JSONEncoder

    # --- 协议 ---
    Codable
    Encodable
    Decodable
    Equatable
    Hashable
    Identifiable
    Sequence
    Collection
    Comparable
    CustomStringConvertible
    CustomDebugStringConvertible
    NSCoding
    NSCopying

    # --- 常用方法名 ---
    init
    deinit
    viewDidLoad
    viewWillAppear
    viewDidAppear
    viewWillDisappear
    viewDidDisappear
    didReceiveMemoryWarning
    layoutSubviews
    draw
    updateConstraints
    prepareForReuse
    awakeFromNib
    encode
    decode
    description
    debugDescription
    #自定义添加
    didMoveToWindow
    setBackgroundImage
    pageViewController
    AssociatedKeys
    

    # --- 常用属性名 ---
    frame
    bounds
    center
    transform
    alpha
    backgroundColor
    tintColor
    text
    font
    image
    delegate
    dataSource
    tag
    title
    isHidden
    isEnabled
    contentOffset
    contentSize
    contentInset
    reuseIdentifier
    indexPath
    placeholder
    layer
    subviews
    superview
    window
    navigationItem
    navigationController
    tabBarController
    presentedViewController
    presentingViewController
    safeAreaInsets
    traitCollection
    autoresizingMask

    #自定义符号
    cancel
    email
    data
    Delay
    application
    actionSheet
    applicationSupportURL
    applyMask
    applyConstraints
    collectionView
    configure
    configureAppearance
    debug
    disable
    enable
    error
    expandMaskEdges
hide
imageNamed
images
imagePickerController
imagePickerControllerDidCancel
info
prepare
removeAll
removeFromSuperview
reset
setImage
show
stopAnimation
unzip
urlSession
webView
warning
willMove


#属性名
await
address
alert
async
alertView
alertController
animation
animationDuration
animateViewFrame
animateNextImage
animationDidStop
animationView
appearance
archive
attrs
asset
attributedString
array
attributes
actionSheet
backgroundView
backgroundImageName
block
background
bytesPerRow
bitsPerComponent
bitmapInfo
blue
button
boundingBox
byteDecoder
byteEncoder
bundleIdentifier
bytes
cache
centerX
children
childItems
canvasSize
category
centerY
cgRect
color
content
cancelAction
cacheFileURL
calculateFolderSize
calculateGenerationTime
cacheKey
cell
className
ciImage
cgContext
connect
code
colorSpace
config
cgImage
configuration
Configuration
context
contentView
createCGImage
cornerRadius
count
currentIndex
customView
confirmAction
complete
components
cgContext
channel
data
DirectoryDocument
dateFormatter
decoder
dense
descript
drawColor
drawRect
displayPrice
delay
didReceive
disconnect
downloaded
downloader
dismiss
dense_embedding
download
duration
documentDirectory
encoder
else
endBackgroundTask
example
encoderLayer
fileName
fileNames
for
foreground
fileManager
filter
finish
filePath
fileSize
fileURL
fileURLs
fileWrapper
filename
first
flags
folderPath
fontSize
format
func
folder
formatter
gifData
genMask
gestureRecognizer
gestureRecognizerShouldBegin
gifImage
gradientLayer
graph
green
generate
high
height
handler
handlers
httpHeaders
hexString
hash
hint
id
imageSize
imageView
imageName
imageProcessingQueue
index
identifier
indicator
interface
instance
item
items
ItemCell
isWWAN
json
jsonData
jsonString
key
keyWindow
localizedString
Logger
login
label
load
lastIndex
lastPoint
layout
location
languageCode
localizedDescription
longPressGesture
length
low
let
loadURL
log
max
md5
margin
md5String
min
model
message
mean
maskLayer
main
numberOfSections
notifyAll
normal
name
node
offset
offsetX
offsetY
options
outputImage
originalImage
padding
picker
post
point
pixel
path
progress
points
pending
position
positions
params
Product
paymentQueue
products
productID
purchase
parameters
range
radius
random
randomKey
query
queue
ready
rect
red
root
render
rowCount
replace
request
responseData
requestData
readableContentTypes
RequestInterceptor
result
rgba
scale
scaleX
scaleY
scaled
second
scroll
section
save
session
setup
spacing
startAnimation
setupConstraints
scheduleNextAnimation
scrollViewDidEndDecelerating
scrollViewDidEndDragging
scrollViewDidEndScrollingAnimation
scrollViewDidZoom
scrollViewWillBeginDragging
sectionCollectionView
shared
Section
size
splitIndex
start
state
style
scores
status
subView
shapeLayer
success
safeAreaBottom
scrollView
sparse_embedding
strength
Style
std
tapGesture
textView
time
timeInterval
token
task
Task
toPath
total
toUInt8
tintedImage
timestamp
type
toSize
timer
titleColor
titleLabel
throws
url
userCancelled
unverified
urls
urlRequest
userInfo
value
values
View
Video
version
viewController
viewControllers
viewDidLayoutSubviews
view
verified
width
webViewController
zPositions
xOffset
yOffset
yolo
yoloBtnIsSelected
yoloBtnTag
yoloMaskImage

yoloRecognizedObjects
yoloRecognizedViewHieght
yoloTipL
yoloToolsView
)

# 新增过滤规则函数
filter_additional_rules() {
    local name="$1"
    
    # 规则2: 首字母是_的不提取
    if [[ "$name" =~ ^_ ]]; then
        return 1
    fi
    
    # 规则3: 长度小于4的不提取
    if [[ ${#name} -lt 4 ]]; then
        return 1
    fi
    
    return 0 # 保留
}

filter_single_letters() {
    grep -v '^.$'
}

filter_blacklist() {  # 改动
    local name="$1"
    for keyword in "${SYSTEM_SYMBOLS[@]}"; do
        if [[ "$name" == "$keyword" ]]; then
            return 1 # 在黑名单里
        fi
    done
    return 0 # 保留
}

extract_class_names() {
    local file="$1"
    grep -E '^[[:space:]]*(public|private|internal|open|fileprivate)?[[:space:]]*(final)?[[:space:]]*(class|struct|enum|protocol)[[:space:]]+[A-Za-z_][A-Za-z0-9_]*' "$file" | \
    sed -E 's/.*(class|struct|enum|protocol)[[:space:]]+([A-Za-z_][A-Za-z0-9_]*).*/\2/' | \
    grep -v '^$' | filter_single_letters
}

extract_method_names() {
    local file="$1"
    grep -E '^[[:space:]]*(public|private|internal|open|fileprivate|static|class)?[[:space:]]*(override)?[[:space:]]*(func|init|deinit)[[:space:]]+[A-Za-z_][A-Za-z0-9_]*' "$file" | \
    sed -E 's/.*(func|init|deinit)[[:space:]]+([A-Za-z_][A-Za-z0-9_]*).*/\2/' | \
    grep -v '^$' | filter_single_letters
}

extract_property_names() {
    local file="$1"
    grep -E '^[[:space:]]*(public|private|internal|open|fileprivate|static|class)?[[:space:]]*(lazy)?[[:space:]]*(var|let)[[:space:]]+[A-Za-z_][A-Za-z0-9_]*' "$file" | \
    sed -E 's/.*(var|let)[[:space:]]+([A-Za-z_][A-Za-z0-9_]*).*/\2/' | \
    grep -v '^$' | filter_single_letters
}

output_shell_array() {
    local array_name="$1"
    shift
    local items=("$@")
    
    echo "$array_name=("
    for item in "${items[@]}"; do
        echo "    \"$item\""
    done
    echo ")"
}

# 生成忽略路径参数的函数
ignore_path_args() {
    local args=""
    for dir in "${IGNORE_DIRS[@]}"; do
        args+=" -path \"*/$dir/*\" -prune -o"
    done
    echo "$args"
}

main() {
    local target_dir="${1:-$DEFAULT_DIR}"
    local output_file="${2:-$OUTPUT_FILE}"
    
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        show_usage
        exit 0
    fi
    
    if [ ! -d "$target_dir" ]; then
        echo -e "${RED}错误: 目录 '$target_dir' 不存在${NC}"
        exit 1
    fi
    
    # 使用忽略路径参数查找 Swift 文件
    local swift_files=()
    while IFS= read -r -d '' file; do
        swift_files+=("$file")
    done < <(eval "find \"$target_dir\" $(ignore_path_args) -name '*.swift' -type f -print0")
    
    if [ ${#swift_files[@]} -eq 0 ]; then
        echo -e "${YELLOW}警告: 在目录 '$target_dir' 中未找到Swift文件${NC}"
        exit 0
    fi
    
    echo -e "${GREEN}开始扫描目录: $target_dir${NC}"
    echo -e "${GREEN}忽略文件夹: ${IGNORE_DIRS[*]}${NC}"
    echo -e "${GREEN}找到 ${#swift_files[@]} 个Swift文件${NC}"
    echo -e "${GREEN}输出文件: $output_file${NC}"
    echo ""
    
    local temp_classes="/tmp/swift_classes_$$"
    local temp_methods="/tmp/swift_methods_$$"
    local temp_properties="/tmp/swift_properties_$$"
    
    > "$temp_classes"
    > "$temp_methods"
    > "$temp_properties"
    
    for file in "${swift_files[@]}"; do
        echo -e "${BLUE}处理文件: $file${NC}"
        extract_class_names "$file" >> "$temp_classes" 2>/dev/null || true
        extract_method_names "$file" >> "$temp_methods" 2>/dev/null || true
        extract_property_names "$file" >> "$temp_properties" 2>/dev/null || true
    done
    
    # 去重、合并、再去重（类/方法/属性互相去重）  # 改动
    local all_symbols=($(cat "$temp_classes" "$temp_methods" "$temp_properties" | sort | uniq | grep -v '^$'))
    
    # 过滤掉黑名单和新增规则  # 改动
    local filtered_symbols=()
    for sym in "${all_symbols[@]}"; do
        if filter_blacklist "$sym" && filter_additional_rules "$sym"; then
            filtered_symbols+=("$sym")
        fi
    done

    # 分回三类（原有类别里存在的才保留）  # 改动
    local unique_classes=()
    local unique_methods=()
    local unique_properties=()
    for sym in "${filtered_symbols[@]}"; do
        if grep -qx "$sym" "$temp_classes"; then
            unique_classes+=("$sym")
        elif grep -qx "$sym" "$temp_methods"; then
            unique_methods+=("$sym")
        elif grep -qx "$sym" "$temp_properties"; then
            unique_properties+=("$sym")
        fi
    done
    
    cat > "$output_file" << EOF
# Swift符号提取报告 - Shell数组格式
# 生成时间: $(date)
# 扫描目录: $target_dir
# 文件总数: ${#swift_files[@]}
# 已过滤单字母内容、黑名单，并做三类数组互相去重
EOF
    
    echo "# 类/结构体/枚举/协议数组 (${#unique_classes[@]}个)" >> "$output_file"
    output_shell_array "SWIFT_CLASSES" "${unique_classes[@]}" >> "$output_file"
    echo "" >> "$output_file"
    
    echo "# 方法名数组 (${#unique_methods[@]}个)" >> "$output_file"
    output_shell_array "SWIFT_METHODS" "${unique_methods[@]}" >> "$output_file"
    echo "" >> "$output_file"
    
    echo "# 属性名数组 (${#unique_properties[@]}个)" >> "$output_file"
    output_shell_array "SWIFT_PROPERTIES" "${unique_properties[@]}" >> "$output_file"
    echo "" >> "$output_file"
    
    cat >> "$output_file" << EOF
# 统计信息
# Swift文件总数: ${#swift_files[@]}
# 类/结构体/枚举/协议总数: ${#unique_classes[@]}
# 方法总数: ${#unique_methods[@]}
# 属性总数: ${#unique_properties[@]}
EOF
    
    rm -f "$temp_classes" "$temp_methods" "$temp_properties"
    
    echo -e "${GREEN}提取完成!${NC}"
    echo -e "  Swift文件: ${YELLOW}${#swift_files[@]}${NC}"
    echo -e "  类: ${YELLOW}${#unique_classes[@]}${NC}"
    echo -e "  方法: ${YELLOW}${#unique_methods[@]}${NC}"
    echo -e "  属性: ${YELLOW}${#unique_properties[@]}${NC}"
    echo -e "${GREEN}结果已保存到: $output_file${NC}"
}

main "$@"
