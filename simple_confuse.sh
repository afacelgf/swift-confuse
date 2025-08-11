#!/bin/bash

#  Swift 简单混淆脚本（Perl 替换版 - 更可靠）
#  使用: ./simple_confuse.sh -c  (混淆)  |  ./simple_confuse.sh -u (恢复)

# 需要混淆的符号数组 - 在这里添加你要混淆的类名、方法名等
TARGET_SYMBOLS=(
    "DYLogger"
    "DYNetWorkManager" 
    "DYHomeVC"
    "DYMineVC"
    "DYMyWorksVC"
    "DealPicViewController"
    "DYPipelineLoader"
    "DYRequestTool"
    "DYDownloader"
    "DYImageLoader"
    "DYLoadingView"
    "DYLoadProgressView"
    "DYNetworkMonitor"
    "DYUIExtension"
    "DYIMageTools"
    "DYGetFileSizeTool"
    "BaseVC"
    "BaseWebView"
    
    # 新增的 class 名称
    "ThreeImageFadeView"
    "EraseTwoImageView"
    "PipelineLoader"
    "DYNNetworkMonitor"
    "dyImagePreviewViewController"
    "ImageContentViewController"
    "Downloader"
    "CustomAlertView"
    "myWorksItemCollectionViewCell"
    "ImageLoader"
    "ImageGalleryViewController"
    "ImageProcessingService"
    "ImageManager"
    "LLAccessibilityAlertController"
    "DSP"
    "twoPicAnimationView"
    "GradientButton"
    "AutoAdjustingTextView"
    "DownloadProgressBar"
    "Util"
    "ScreenBrightnessManager"
    "ScreenInsetsUtil"
    "testRequestVC"
    "threePicAnimationView"
    "ImagePreviewViewController"
    "DYNetworkManager"
    "userInfoView"
    "CustomView"
    
    # DYHomeVC自定义方法名
    "checkModelSize"
    "checkMemory"
    "showMemoryLimitAlert"
    "checkNetWork"
    "postLogin"
    "setupUI"
    "setupConstraints"
    "choosePicbuttonTapped"
    "selectImage"
    "setImgsAnimation"
    "startEraseAndRestoreEffect"
    
    # DealPicViewController自定义方法
    "showCancelDownLoadAlert"
    "showNoNetWorkConnectAlert"
    "showDownLoadAlert"
    "setSingleModelDownloadButtonHideState"
    "downloadModel"
    "selectSingerModelView"
    "uploadPic"
    "dsprunToGeneratePic"
    "showAlertWithTitleAndButton"
    "postAccountData"
    "setBottomBtnWithState"
    "showBottomSheet"
    "checkFileIsExist"
    "updatePlaceholderVisibility"
    "setGifPicHidden"
    "getImageDisplayRect"
    "convertTouchPointToImagePoint"
    "postMaidian"
    
    # DYMyWorksVC自定义方法
    "setupViews"
    "yUJGSqhxrSVjaCfz"
    "updateSelectionState"
    "setUpUIWithItemCount"
    "setupEmptyView"
    "setupCollectionView"
    "updateSelectionLabel"
    
    # DYMineVC自定义方法
    "showAlertWithTitleAndButton"
    "SubViewData"
    "setupView"
    "createSubView"
    "handleSubViewTap"
    
    # ImageManager自定义方法
    "saveImage"
    "getImage"
    "deleteImage"
    "getAllImageNames"
    "getAllImageNamesWithFullPath"
    "saveImageToAlbum"
    
    # ImageProcessingService自定义方法
    "compressImage"
    "drawImageOnCanvas"
    "cropImageWithRect"
    "compositeImages"
    "applyMask"
    "saveToAlbum"
    
    # DYNetWorkManager自定义方法
    "requestGetData"
    "getUploadPicData"
    "postBurialpointInfo"
    "putImageData"
    
    # DYRequestTool自定义方法
    "dy_getUUID"
    "saveStringToUserDefaults"
    "getStringFromUserDefaults"
    "dy_getDeviceIdFromKeychain"
    "dy_saveToKeychain"
    "dy_readFromKeychain"
    "dyJsonString"
    "dy_getDeviceModelIdentifier"
    "dy_getNomalParamsDic"
    
    
    # DSP自定义方法
    "logp"
    "convert2RGBA"
    "string2int"
    "string2Float"
    "sdrun"
    "dy_karrasSigmas"
    
    # DYPipelineLoader自定义方法
    "prepare"
    "cancelDownload"
    "cleanup"
    "createModelsDirectory"
    "cleanupModelsDirectory"
    
    # PipelineLoader自定义方法
    "setInitialState"
    "unzip"
    
    # DYNetworkMonitor自定义方法
    "startMonitoring"
    "stopMonitoring"
    
    # DYNetTool自定义方法
    "isNetworkAvailable"
    
    # DYDownloader/Downloader自定义方法
    "waitUntilDone"
    
    
    # DYImageLoader自定义方法
    "loadImage"
    
    # DYLoadingView自定义方法
    
    "setMaskVisible"
    "calculateNavigationBarAndTabBarHeights"
    
    # DYLoadProgressView自定义方法
    "reset"
    
    # DYIMageTools自定义方法
    "setupScrollView"
    "setupImageView"
    "centerImageView"
    
    # BaseVC自定义方法
    "setupBackButton"
    
    # BaseWebView自定义方法
   
    "setupProgressView"
    
    # AppDelegate自定义方法
    "configureAppearance"
    
    # 动画视图自定义方法
    "startAnimation"
    "stopAnimation"
    "updateImages"
    "startReverseEraseAnimation"
    "animationDidStop"
    
    # 预览相关自定义方法
    "setupPageViewController"
    "viewControllerForImage"
    "imagePreviewViewController"
    "updatePageNumberLabel"
    
    # 其他工具方法
    "unzipFile"
    "showAlert"
    "hiddenAlert"
    "updateHeight"
    "preventRepeatedPresses"
    "setBackgroundColor"
    "loadGif"
    "DYLog"
    "calculateFolderSize"
    
    # 在这里添加更多需要混淆的符号

    #diffusion方法
    "ResnetBlock"
    "AttnBlock"
    "CLIPSelfAttention"
    "CLIPResidualAttentionBlock"
    "VisionTransformer"
    "CLIPTextEmbedding"
    "CLIPAttention"
    "QuickGELU"
    "CLIPMLP"
    "CLIPEncoderLayer"
    "CLIPTextModel"
    "InputHintBlocks"
    "InputBlocks"
    "ControlNet"
    "ControlNetv2"
    "LoRAConvolution"
    "LoRADense"
    "LoRACLIPAttention"
    "LoRACLIPMLP"
    "LoRACLIPEncoderLayer"
    "LoRACLIPTextModel"
    "LoRATimeEmbed"
    "LoRAResBlock"
    "LoRASelfAttention"
    "LoRACrossAttention"
    "LoRAFeedForward"
    "LoRABasicTransformerBlock"
    "LoRASpatialTransformer"
    "LoRAOutputBlocks"
    "LoRAUNet"
    "OpenCLIPMLP"
    "OpenCLIPEncoderLayer"
    "OpenCLIPTextModel"
    "ResnetBlock"
    "ResnetBlockLight"
    "AdapterLight"
    "CLIPResidualAttentionBlock"
    "StyleAdapter"
    "timeEmbedding"
    "ResBlock"
    "SelfAttention"
    "CrossAttention"
    "FeedForward"
    "BasicTransformerBlock"
    "SpatialTransformer"
)


# 需要混淆的属性数组 - 从TARGET_SYMBOLS的类中提取的自定义属性
TARGET_PROPERTIES=(
    # DYMineVC 自定义属性
    "userInfoV"
    "currentWebUrl"
    
    # BaseWebView 自定义属性
    "urlString"
    "titleStr"
   
    "errorView"
    
    # ImageManager 自定义属性
    "imagesDirectory"
    
    # DealPicViewController 自定义属性
   "topImageView"
   "topLogoImgV"
   "currentImage"
   "originalImageUploadSuccessUrl"
   "currentImageUploadSuccessUrl"
   "imageHistory"
   "eraserRadius"
   "lastPoint"
   "lastTouchPoint"
   "brushSizeLabel"
   "brushSizeSlider"
   "reuploadButton"
   "withdrawButton"
   "clearButton"
   "modelTipLabel"
   "inputTextTipLabel"
   "promptTextView"
   "promptTextViewClearButton"
   "promptTextViewPlaceholderLabel"
   "originalTextViewPosition"
   "modelsScrollView"
   "modelItemViews"
   "currentSelectModelItemView"
   "singleView"
   "topImageWidth"
   "threeBtnwWidth"
   "singleViewWidth"
   "loadModelProgressBar"
   "SingleModelDownloadButton"
   "dps_state"
   "is_inBackGround"
   "chooseModelButton"
   "bottomSheetView"
   "bottomSheetHeight"
   "overlayView"
   "bottomSheetViewOringleImageView"
   "bottomSheetAnimationImageView"
   "bottomSheetViewProgreenLabel"
   "bottomSheetViewProgreenSlider"
   "bottomSheetViewResultImageView"
   "bottomSheetButtonStackView"
   "loadingView"
   "generateTotalTime"
   "lastUpdateTime"
   "minimumUpdateInterval"
   "originalViewFrameY"
   "isHaveNetworkConnect"
    
    # DYIMageTools 自定义属性
    "scrollView"
    
    # picPreView 自定义属性
    "images"
    
    # dyImagePreviewViewController 自定义属性
    "currentIndex"
    
    # ImageContentViewController 自定义属性
    "imageName"
    
    # DYNetworkMonitor 自定义属性
    "onNetworkStatusChange"
    
    # DYLoadingView 自定义属性
    "navigationBarHeight"
    "tabBarHeight"
    
    # DYLoadProgressView 自定义属性
    "isDownloadingOrUpziping"
    
    # LLAccessibilityAlertController 自定义属性
    "closeAlertEnable"
    
    # SFNetworkAccessibility 自定义属性
    "address"
    "ifaddr"
    
    # DYGetFileSizeTool 自定义属性
    "folderSize"
    
    # Util 自定义属性
    "hexString"
      
    # NoceuTJqTapGeQSX (CustomView) 自定义属性
    "iconImage"
    "subViewDataArray"
    "didTapSubView"
    
    # ImageProcessingService 自定义属性
    "compression"
    
        # 手动添加的属性
    # dYHomeVC属性
   "topMaskLayer"
   "semaskLayer2"
   "aniTime"
   "readyAnimation"
   "fadeView"
   "phoneMemory"
   "alertView"
   "toplogoImgV"
   "uploadBtn"
   "tipLabel"
   "buttonOne"
   "buttonTwo"

   "firstNav"
   "secondNav"
   "thirdNav" 
   "baseUrl"
   "modelUrl"
   "modelFileName"
   "email"
   "TermsofUseUrl"
   "PrivacyPolicyUrl"
   "phoneMemoryLimit"
  
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
