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
DEFAULT_INTENSITY="normal"  # 默认强度: normal(默认) 或 medium(中度混淆)

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
    UISceneSession
    UISceneConfiguration
    UIApplicationShortcutItem
    UIUserNotificationSettings
    UNUserNotificationCenter
    UNNotificationRequest
    UNNotificationContent
    UNMutableNotificationContent

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
    UISearchBar
    UISearchController
    UISegmentedControl
    UIStepper
    UIToolbar
    UINavigationBar
    UINavigationItem
    UIPopoverController
    UIPopoverPresentationController
    UISplitViewController
    UIPageViewController
    UIRefreshControl
    UIVisualEffectView
    UIBlurEffect
    UIVibrancyEffect
    UIGestureRecognizer
    UITapGestureRecognizer
    UIPanGestureRecognizer
    UIPinchGestureRecognizer
    UIRotationGestureRecognizer
    UISwipeGestureRecognizer
    UILongPressGestureRecognizer
    UIMenuController
    UIMenuItem
    UIActionSheet
    UIWebView
    WKWebView
    WKWebViewConfiguration
    WKUserContentController
    WKNavigationDelegate
    WKUIDelegate
    UIDevice
    UIApplication
    UIResponderChain
    UIEvent
    UITouch
    UIPress
    UIMotionEffect
    UIInterpolatingMotionEffect
    UIMotionEffectGroup
    UIBezierPath
    UIGraphicsRenderer
    UIGraphicsImageRenderer
    UIGraphicsPDFRenderer
    UIActivityViewController
    UIDocumentPickerViewController
    UIImagePickerController
    UIVideoEditorController
    UICloudSharingController
    UIFontDescriptor
    UIFontMetrics
    UITraitCollection
    UIUserInterfaceIdiom
    UIUserInterfaceSizeClass
    UIContentSizeCategory
    UIAccessibility
    UIAccessibilityElement
    UIAccessibilityContainer
    UIAccessibilityCustomAction
    UIAccessibilityCustomRotor
    UIFeedbackGenerator
    UIImpactFeedbackGenerator
    UINotificationFeedbackGenerator
    UISelectionFeedbackGenerator
    UIContextMenuConfiguration
    UIContextMenuInteraction
    UIMenu
    UIAction
    UICommand
    UIKeyCommand
    UIMenuBuilder
    UISceneActivationConditions
    UIWindowSceneGeometry
    UISceneConnectionOptions
    UIOpenURLContext
    UIUserActivity
    NSUserActivity
    UIShortcutItem
    UIApplicationShortcutIcon
    UILocalNotification
    UIUserNotificationAction
    UIUserNotificationCategory

    # --- Foundation 基础类 ---
    NSObject
    NSCoder
    NSError
    NSException
    NSString
    NSMutableString
    NSAttributedString
    NSMutableAttributedString
    NSArray
    NSMutableArray
    NSDictionary
    NSMutableDictionary
    NSSet
    NSMutableSet
    NSOrderedSet
    NSMutableOrderedSet
    NSNumber
    NSDecimalNumber
    NSValue
    NSData
    NSMutableData
    NSDate
    NSDateComponents
    NSDateFormatter
    NSCalendar
    NSTimeZone
    NSLocale
    NSURL
    NSURLRequest
    NSMutableURLRequest
    NSURLResponse
    NSHTTPURLResponse
    NSURLSession
    NSURLSessionTask
    NSURLSessionDataTask
    NSURLSessionUploadTask
    NSURLSessionDownloadTask
    NSURLSessionConfiguration
    NSURLCache
    NSHTTPCookieStorage
    NSHTTPCookie
    NSURLCredential
    NSURLProtectionSpace
    NSURLAuthenticationChallenge
    NSOperation
    NSOperationQueue
    NSBlockOperation
    NSInvocationOperation
    NSThread
    NSRunLoop
    NSTimer
    NSNotification
    NSNotificationCenter
    NSNotificationQueue
    NSBundle
    NSUserDefaults
    NSFileManager
    NSFileHandle
    NSFileWrapper
    NSDirectoryEnumerator
    NSInputStream
    NSOutputStream
    NSStream
    NSPipe
    NSTask
    NSProcessInfo
    NSProgress
    NSUndoManager
    NSKeyedArchiver
    NSKeyedUnarchiver
    NSPropertyListSerialization
    NSJSONSerialization
    NSXMLParser
    NSRegularExpression
    NSTextCheckingResult
    NSScanner
    NSFormatter
    NSNumberFormatter
    NSByteCountFormatter
    NSDateIntervalFormatter
    NSDateComponentsFormatter
    NSEnergyFormatter
    NSLengthFormatter
    NSMassFormatter
    NSPersonNameComponentsFormatter
    NSUUID
    NSIndexPath
    NSIndexSet
    NSMutableIndexSet
    NSRange
    NSHashTable
    NSMapTable
    NSPointerArray
    NSCache
    NSPurgeableData
    NSNull
    NSProxy
    NSInvocation
    NSMethodSignature
    NSValueTransformer
    NSPredicate
    NSCompoundPredicate
    NSComparisonPredicate
    NSExpression
    NSSortDescriptor
    NSFetchRequest
    NSEntityDescription
    NSManagedObject
    NSManagedObjectContext
    NSPersistentContainer
    NSPersistentStoreCoordinator
    NSManagedObjectModel
    NSFetchedResultsController
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
    DispatchSemaphore
    DispatchSource
    DispatchWorkItem
    JSONDecoder
    JSONEncoder
    PropertyListDecoder
    PropertyListEncoder
    Measurement
    Unit
    Dimension
    UnitConverter
    Calendar
    TimeZone
    Locale
    CharacterSet
    Scanner
    Formatter
    NumberFormatter
    DateFormatter
    ISO8601DateFormatter
    ByteCountFormatter
    DateComponentsFormatter
    DateIntervalFormatter
    EnergyFormatter
    LengthFormatter
    MassFormatter
    PersonNameComponents
    PersonNameComponentsFormatter
    UUID
    ProcessInfo
    Progress
    Stream
    InputStream
    OutputStream
    RunLoop
    Thread
    Lock
    NSLock
    NSRecursiveLock
    NSCondition
    NSConditionLock
    OperationQueue
    Operation
    BlockOperation

    # --- Swift 标准库协议 ---
    Codable
    Encodable
    Decodable
    Equatable
    Hashable
    Identifiable
    Sequence
    Collection
    BidirectionalCollection
    RandomAccessCollection
    MutableCollection
    RangeReplaceableCollection
    LazySequenceProtocol
    LazyCollectionProtocol
    Comparable
    CustomStringConvertible
    CustomDebugStringConvertible
    CustomReflectable
    CustomPlaygroundDisplayConvertible
    TextOutputStream
    TextOutputStreamable
    LosslessStringConvertible
    ExpressibleByArrayLiteral
    ExpressibleByDictionaryLiteral
    ExpressibleByStringLiteral
    ExpressibleByIntegerLiteral
    ExpressibleByFloatLiteral
    ExpressibleByBooleanLiteral
    ExpressibleByNilLiteral
    ExpressibleByUnicodeScalarLiteral
    ExpressibleByExtendedGraphemeClusterLiteral
    RawRepresentable
    CaseIterable
    IteratorProtocol
    Error
    LocalizedError
    CustomNSError
    RecoverableError
    OptionSet
    SetAlgebra
    Strideable
    AdditiveArithmetic
    Numeric
    BinaryInteger
    SignedInteger
    UnsignedInteger
    BinaryFloatingPoint
    FloatingPoint
    SignedNumeric
    AbsoluteValuable
    Magnitude
    
    # --- Foundation 协议 ---
    NSCoding
    NSSecureCoding
    NSCopying
    NSMutableCopying
    NSFastEnumeration
    NSDiscardableContent
    NSLocking
    NSMachPortDelegate
    NSNetServiceDelegate
    NSNetServiceBrowserDelegate
    NSStreamDelegate
    NSURLConnectionDelegate
    NSURLConnectionDataDelegate
    NSURLConnectionDownloadDelegate
    NSURLSessionDelegate
    NSURLSessionTaskDelegate
    NSURLSessionDataDelegate
    NSURLSessionDownloadDelegate
    NSURLSessionStreamDelegate
    NSXMLParserDelegate
    NSFileManagerDelegate
    NSKeyedArchiverDelegate
    NSKeyedUnarchiverDelegate
    NSCacheDelegate
    NSMetadataQueryDelegate
    NSFilePresenter
    NSFileCoordinator
    NSProgressReporting
    NSUserActivityDelegate
    
    # --- UIKit 协议 ---
    UIApplicationDelegate
    UISceneDelegate
    UIWindowSceneDelegate
    UITableViewDataSource
    UITableViewDelegate
    UICollectionViewDataSource
    UICollectionViewDelegate
    UICollectionViewDelegateFlowLayout
    UIScrollViewDelegate
    UITextFieldDelegate
    UITextViewDelegate
    UIPickerViewDataSource
    UIPickerViewDelegate
    UIImagePickerControllerDelegate
    UINavigationControllerDelegate
    UITabBarControllerDelegate
    UISearchBarDelegate
    UISearchResultsUpdating
    UISearchControllerDelegate
    UIGestureRecognizerDelegate
    UIPopoverPresentationControllerDelegate
    UISplitViewControllerDelegate
    UIPageViewControllerDataSource
    UIPageViewControllerDelegate
    UIActivityItemSource
    UICloudSharingControllerDelegate
    UIDocumentPickerDelegate
    UIVideoEditorControllerDelegate
    UIWebViewDelegate
    WKNavigationDelegate
    WKUIDelegate
    WKScriptMessageHandler
    UIAccessibilityReadingContent
    UIAccessibilityContainer
    UIAccessibilityAction
    UIAccessibilityFocus
    UIAccessibilityIdentification
    UIFocusEnvironment
    UIFocusItem
    UIFocusItemContainer
    UITraitEnvironment
    UIContentContainer
    UIStateRestoring
    UIViewControllerTransitioningDelegate
    UIViewControllerAnimatedTransitioning
    UIViewControllerInteractiveTransitioning
    UIViewControllerContextTransitioning
    UIAdaptivePresentationControllerDelegate
    UIPresentationController
    UIPopoverController
    UIActionSheetDelegate
    UIAlertViewDelegate
    UIMenuController
    UIResponderStandardEditActions
    UIKeyInput
    UITextInput
    UITextInputTraits
    UITextInputDelegate
    UITextSelectionRect
    UITextPosition
    UITextRange
    UITextInputTokenizer
    UITextInputStringTokenizer
    UITextChecker
    UIReferenceLibraryViewController
    UIContextMenuInteractionDelegate
    UISpringLoadedInteractionSupporting
    UIDropInteractionDelegate
    UIDragInteractionDelegate
    UICollectionViewDropDelegate
    UICollectionViewDragDelegate
    UITableViewDropDelegate
    UITableViewDragDelegate
    UIPasteConfigurationSupporting
    UIUserActivityRestoring

    # --- 常用方法名 ---
    init
    deinit
    viewDidLoad
    viewWillAppear
    viewDidAppear
    viewWillDisappear
    viewDidDisappear
    viewDidLayoutSubviews
    viewWillLayoutSubviews
    viewDidUnload
    viewWillUnload
    didReceiveMemoryWarning
    loadView
    viewDidMoveToWindow
    viewWillMoveToWindow
    viewDidMoveToSuperview
    viewWillMoveToSuperview
    layoutSubviews
    layoutIfNeeded
    setNeedsLayout
    setNeedsDisplay
    setNeedsUpdateConstraints
    updateConstraints
    updateViewConstraints
    draw
    drawRect
    prepareForReuse
    awakeFromNib
    prepareForInterfaceBuilder
    encode
    decode
    encodeWithCoder
    initWithCoder
    description
    debugDescription
    hash
    isEqual
    copy
    mutableCopy
    performSelector
    respondsToSelector
    conformsToProtocol
    isKindOfClass
    isMemberOfClass
    addObserver
    removeObserver
    willChangeValueForKey
    didChangeValueForKey
    didMoveToSuperview
    observeValueForKeyPath
    setValue
    valueForKey
    valueForKeyPath
    setValuesForKeysWithDictionary
    dictionaryWithValuesForKeys
    validateValue
    mutableArrayValueForKey
    mutableSetValueForKey
    addTarget
    removeTarget
    sendActionsForControlEvents
    beginTrackingWithTouch
    continueTrackingWithTouch
    endTrackingWithTouch
    cancelTrackingWithEvent
    addGestureRecognizer
    removeGestureRecognizer
    gestureRecognizerShouldBegin
    shouldReceiveTouch
    shouldReceivePress
    shouldRequireFailureOfGestureRecognizer
    shouldBeRequiredToFailByGestureRecognizer
    touchesBegan
    touchesMoved
    touchesEnded
    touchesCancelled
    pressesBegan
    pressesChanged
    pressesEnded
    pressesCancelled
    motionBegan
    motionEnded
    motionCancelled
    remoteControlReceivedWithEvent
    canBecomeFirstResponder
    becomeFirstResponder
    canResignFirstResponder
    resignFirstResponder
    isFirstResponder
    nextResponder
    undoManager
    canPerformAction
    targetForAction
    buildMenuWithBuilder
    validate
    cut
    copy
    paste
    select
    selectAll
    delete
    makeTextWritingDirectionLeftToRight
    makeTextWritingDirectionRightToLeft
    toggleBoldface
    toggleItalics
    toggleUnderline
    increaseSize
    decreaseSize
    updateUserActivityState
    restoreUserActivityState
    applicationFinishedRestoringState
    encodeRestorableStateWithCoder
    decodeRestorableStateWithCoder
    applicationWillTerminate
    applicationDidEnterBackground
    applicationWillEnterForeground
    applicationDidBecomeActive
    applicationWillResignActive
    applicationDidFinishLaunching
    applicationDidFinishLaunchingWithOptions
    applicationWillFinishLaunchingWithOptions
    applicationDidReceiveMemoryWarning
    applicationSignificantTimeChange
    applicationDidChangeStatusBarOrientation
    applicationWillChangeStatusBarOrientation
    applicationDidChangeStatusBarFrame
    applicationWillChangeStatusBarFrame
    applicationDidRegisterForRemoteNotificationsWithDeviceToken
    applicationDidFailToRegisterForRemoteNotifications
    applicationDidReceiveRemoteNotification
    applicationDidReceiveLocalNotification
    applicationHandleOpenURL
    applicationOpenURL
    applicationPerformActionForShortcutItem
    applicationHandleWatchKitExtensionRequest
    applicationShouldRequestHealthAuthorization
    applicationDidRegisterUserNotificationSettings
    applicationDidReceiveUserNotification
    applicationWillContinueUserActivityWithType
    applicationContinueUserActivity
    applicationDidFailToContinueUserActivityWithType
    applicationDidUpdateUserActivity
    sceneWillConnect
    sceneDidDisconnect
    sceneDidBecomeActive
    sceneWillResignActive
    sceneWillEnterForeground
    sceneDidEnterBackground
    sceneOpenURLContexts
    sceneContinueUserActivity
    sceneDidFailToContinueUserActivityWithType
    sceneDidUpdateUserActivity
    sceneWillContinueUserActivityWithType
    windowSceneDidUpdateCoordinateSpace
    windowSceneDidUpdateInterfaceOrientation
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
    attributedText
    font
    textColor
    textAlignment
    lineBreakMode
    numberOfLines
    adjustsFontSizeToFitWidth
    minimumScaleFactor
    allowsDefaultTighteningForTruncation
    baselineAdjustment
    minimumFontSize
    shadowColor
    shadowOffset
    highlightedTextColor
    isHighlighted
    isUserInteractionEnabled
    isMultipleTouchEnabled
    isExclusiveTouch
    image
    highlightedImage
    animationImages
    highlightedAnimationImages
    animationDuration
    animationRepeatCount
    delegate
    dataSource
    tag
    title
    titleLabel
    imageView
    backgroundImage
    selectedImage
    disabledImage
    selectedBackgroundImage
    titleColor
    titleShadowColor
    isSelected
    isEnabled
    isHidden
    contentVerticalAlignment
    contentHorizontalAlignment
    contentEdgeInsets
    titleEdgeInsets
    imageEdgeInsets
    reversesTitleShadowWhenHighlighted
    adjustsImageWhenHighlighted
    adjustsImageWhenDisabled
    showsTouchWhenHighlighted
    buttonType
    currentTitle
    currentTitleColor
    currentTitleShadowColor
    currentImage
    currentBackgroundImage
    contentOffset
    contentSize
    contentInset
    contentInsetAdjustmentBehavior
    adjustedContentInset
    scrollIndicatorInsets
    isScrollEnabled
    isDirectionalLockEnabled
    scrollsToTop
    isPagingEnabled
    bounces
    alwaysBounceVertical
    alwaysBounceHorizontal
    canCancelContentTouches
    delaysContentTouches
    decelerationRate
    indicatorStyle
    showsHorizontalScrollIndicator
    showsVerticalScrollIndicator
    refreshControl
    accessibilityScroll
    zoomScale
    minimumZoomScale
    maximumZoomScale
    isZoomBouncing
    isZooming
    bouncesZoom
    scrollViewDelegate
    reuseIdentifier
    indexPath
    placeholder
    clearsOnBeginEditing
    clearsOnInsertion
    allowsEditingTextAttributes
    typingAttributes
    clearButtonMode
    leftView
    leftViewMode
    rightView
    rightViewMode
    inputView
    inputAccessoryView
    clearsContextBeforeDrawing
    layer
    gestureRecognizers
    userInteractionEnabled
    multipleTouchEnabled
    exclusiveTouch
    subviews
    superview
    window
    nextResponder
    canBecomeFirstResponder
    canResignFirstResponder
    isFirstResponder
    undoManager
    navigationItem
    navigationController
    tabBarItem
    tabBarController
    splitViewController
    presentedViewController
    presentingViewController
    definesPresentationContext
    providesPresentationContextTransitionStyle
    restoresFocusAfterTransition
    transitioningDelegate
    modalTransitionStyle
    modalPresentationStyle
    modalPresentationCapturesStatusBarAppearance
    disablesAutomaticKeyboardDismissal
    edgesForExtendedLayout
    extendedLayoutIncludesOpaqueBars
    automaticallyAdjustsScrollViewInsets
    preferredContentSize
    preferredStatusBarStyle
    prefersStatusBarHidden
    preferredStatusBarUpdateAnimation
    shouldAutorotate
    supportedInterfaceOrientations
    preferredInterfaceOrientationForPresentation
    interfaceOrientation
    isBeingPresented
    isBeingDismissed
    isMovingFromParentViewController
    isMovingToParentViewController
    view
    viewIfLoaded
    isViewLoaded
    nibName
    nibBundle
    storyboard
    title
    parent
    childViewControllers
    presentationController
    popoverPresentationController
    searchDisplayController
    safeAreaInsets
    additionalSafeAreaInsets
    systemMinimumLayoutMargins
    viewRespectsSystemMinimumLayoutMargins
    viewSafeAreaInsetsDidChange
    traitCollection
    preferredContentSizeCategory
    autoresizingMask
    translatesAutoresizingMaskIntoConstraints
    constraints
    leadingAnchor
    trailingAnchor
    leftAnchor
    rightAnchor
    topAnchor
    bottomAnchor
    widthAnchor
    heightAnchor
    centerXAnchor
    centerYAnchor
    firstBaselineAnchor
    lastBaselineAnchor
    layoutMargins
    preservesSuperviewLayoutMargins
    layoutMarginsGuide
    readableContentGuide
    safeAreaLayoutGuide
    directionalLayoutMargins
    insetsLayoutMarginsFromSafeArea
    layoutMarginsDidChange
    safeAreaInsetsDidChange
    readableContentGuideDidChange
    effectiveUserInterfaceLayoutDirection
    semanticContentAttribute
    userInterfaceLayoutDirection
    accessibilityIdentifier
    accessibilityLabel
    accessibilityHint
    accessibilityValue
    accessibilityTraits
    accessibilityFrame
    accessibilityPath
    accessibilityActivationPoint
    accessibilityLanguage
    accessibilityElementsHidden
    accessibilityViewIsModal
    shouldGroupAccessibilityChildren
    accessibilityNavigationStyle
    accessibilityHeaderElements
    accessibilityCustomActions
    accessibilityCustomRotors
    isAccessibilityElement
    accessibilityElements
    accessibilityElementCount
    accessibilityContainer
    focusGroupIdentifier
    focusGroupPriority
    canBecomeFocused
    preferredFocusEnvironments
    preferredFocusedView
    focusItemContainer
    coordinateSpace
    focusItemsInRect
    soundIdentifier

    # --- Core Graphics / Core Animation ---
    CGRect
    CGPoint
    CGSize
    CGFloat
    CGAffineTransform
    CGColor
    CGColorSpace
    CGContext
    CGImage
    CGPath
    CGMutablePath
    CGGradient
    CGShading
    CGPattern
    CGFont
    CGGlyph
    CGPDFDocument
    CGPDFPage
    CGDataProvider
    CGDataConsumer
    CALayer
    CAAnimation
    CABasicAnimation
    CAKeyframeAnimation
    CAAnimationGroup
    CATransition
    CAPropertyAnimation
    CAValueFunction
    CAMediaTiming
    CAMediaTimingFunction
    CATransaction
    CADisplayLink
    CAEAGLLayer
    CAGradientLayer
    CAReplicatorLayer
    CAScrollLayer
    CAShapeLayer
    CATextLayer
    CATiledLayer
    CATransformLayer
    CAEmitterLayer
    CAEmitterCell
    
    # --- SwiftUI (iOS 13+) ---
    View
    ViewBuilder
    ViewModifier
    EnvironmentValues
    EnvironmentKey
    PreferenceKey
    GeometryReader
    GeometryProxy
    Color
    Image
    Text
    Button
    Toggle
    Slider
    Stepper
    TextField
    SecureField
    TextEditor
    Picker
    DatePicker
    ColorPicker
    Link
    Menu
    MenuButton
    ContextMenu
    ActionSheet
    Alert
    Sheet
    FullScreenCover
    Popover
    HStack
    VStack
    ZStack
    LazyHStack
    LazyVStack
    LazyHGrid
    LazyVGrid
    ScrollView
    List
    ForEach
    Section
    Group
    Form
    NavigationView
    NavigationLink
    TabView
    PageTabViewStyle
    Spacer
    Divider
    Rectangle
    RoundedRectangle
    Circle
    Ellipse
    Capsule
    Path
    Shape
    InsettableShape
    FillStyle
    StrokeStyle
    LinearGradient
    RadialGradient
    AngularGradient
    ImagePaint
    Animation
    AnyTransition
    AnyView
    EmptyView
    TupleView
    ModifiedContent
    SubscriptionView
    StateObject
    ObservedObject
    EnvironmentObject
    Published
    State
    Binding
    FetchRequest
    DynamicProperty
    ObservableObject
    
    # --- Combine (iOS 13+) ---
    Publisher
    Subscriber
    Subscription
    Cancellable
    AnyCancellable
    AnyPublisher
    AnySubscriber
    PassthroughSubject
    CurrentValueSubject
    Just
    Empty
    Fail
    Deferred
    Future
    Record
    Share
    Multicast
    ConnectablePublisher
    Timer
    URLSession
    NotificationCenter
    
    # --- Core Data ---
    NSManagedObject
    NSManagedObjectContext
    NSManagedObjectModel
    NSEntityDescription
    NSAttributeDescription
    NSRelationshipDescription
    NSFetchedPropertyDescription
    NSPropertyDescription
    NSPersistentContainer
    NSPersistentStoreCoordinator
    NSPersistentStore
    NSPersistentStoreDescription
    NSFetchRequest
    NSFetchRequestResult
    NSFetchedResultsController
    NSFetchedResultsControllerDelegate
    NSAsynchronousFetchRequest
    NSAsynchronousFetchResult
    NSBatchInsertRequest
    NSBatchUpdateRequest
    NSBatchDeleteRequest
    NSMergePolicy
    NSQueryGenerationToken
    NSPersistentHistoryToken
    NSPersistentHistoryTransaction
    NSPersistentHistoryChange
    NSPersistentCloudKitContainer
    NSPersistentCloudKitContainerOptions
    
    # --- 网络相关 ---
    Alamofire
    AFHTTPSessionManager
    AFURLSessionManager
    AFSecurityPolicy
    AFNetworkReachabilityManager
    AFHTTPRequestSerializer
    AFHTTPResponseSerializer
    AFJSONRequestSerializer
    AFJSONResponseSerializer
    AFXMLParserResponseSerializer
    AFXMLDocumentResponseSerializer
    AFPropertyListRequestSerializer
    AFPropertyListResponseSerializer
    AFImageResponseSerializer
    AFCompoundResponseSerializer
    
    # --- 第三方常用库 ---
    SDWebImage
    SDImageCache
    SDWebImageManager
    SDWebImageDownloader
    SDWebImageOperation
    SDWebImageDecoder
    SDWebImageCoder
    SDAnimatedImage
    SDAnimatedImageView
    Kingfisher
    KingfisherManager
    ImageCache
    ImageDownloader
    ImageProcessor
    SnapKit
    Constraint
    ConstraintMaker
    ConstraintView
    Masonry
    MASConstraint
    MASViewConstraint
    MASCompositeConstraint
    MASViewAttribute
    MASLayoutConstraint
    
    # --- 更多常用属性名 ---
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
    allImages
    allMasks
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
    Custom
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
    Photo
    range
    radius
    random
    Result
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
    Replace
    result
    Random
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
    scrollViewDidScroll
    scrollViewDidEndScrollingAnimation
    scrollViewDidZoom
    scrollViewWillBeginDragging
    sectionCollectionView
    shared
    Section
    size
    Size
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
    textFieldDidChangeSelection
    textViewDidBeginEditing
    textViewDidChange
    textViewDidEndEditing
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
    
    # --- Swift 关键字 ---
    associatedtype
    class
    deinit
    enum
    extension
    fileprivate
    func
    import
    init
    inout
    internal
    let
    open
    operator
    private
    protocol
    public
    rethrows
    static
    struct
    subscript
    typealias
    var
    break
    case
    continue
    default
    defer
    do
    else
    fallthrough
    for
    guard
    if
    in
    repeat
    return
    switch
    where
    while
    as
    catch
    false
    is
    nil
    super
    self
    Self
    throw
    throws
    true
    try
    
    # --- 常用系统常量 ---
    kCFBooleanTrue
    kCFBooleanFalse
    kCFNull
    kCGColorSpaceGenericRGB
    kCGImageAlphaPremultipliedLast
    kCGImageAlphaPremultipliedFirst
    kCGImageAlphaNoneSkipLast
    kCGImageAlphaNoneSkipFirst
    kCGBlendModeNormal
    kCGBlendModeMultiply
    kCGBlendModeScreen
    kCGBlendModeOverlay
    kCGBlendModeDarken
    kCGBlendModeLighten
    kCGBlendModeColorDodge
    kCGBlendModeColorBurn
    kCGBlendModeSoftLight
    kCGBlendModeHardLight
    kCGBlendModeDifference
    kCGBlendModeExclusion
    kCGBlendModeHue
    kCGBlendModeSaturation
    kCGBlendModeColor
    kCGBlendModeLuminosity
    UIApplicationDidBecomeActiveNotification
    UIApplicationWillResignActiveNotification
    UIApplicationDidEnterBackgroundNotification
    UIApplicationWillEnterForegroundNotification
    UIApplicationWillTerminateNotification
    UIApplicationDidReceiveMemoryWarningNotification
    UIDeviceOrientationDidChangeNotification
    UIKeyboardWillShowNotification
    UIKeyboardDidShowNotification
    UIKeyboardWillHideNotification
    UIKeyboardDidHideNotification
    UITextFieldTextDidChangeNotification
    UITextViewTextDidChangeNotification
    NSNotificationCenter
    NSUserDefaults
    NSFileManager
    NSBundle
    NSProcessInfo
    NSRunLoop
    NSThread
    NSOperationQueue
    NSURLSession
    NSJSONSerialization
    NSPropertyListSerialization
    NSKeyedArchiver
    NSKeyedUnarchiver
    NSUserActivity
    NSExtensionContext
    NSItemProvider
    NSProgress
    NSMetadataQuery
    NSFileCoordinator
    NSFilePresenter
    NSUbiquitousKeyValueStore
    NSCloudKitMirroringDelegate
    NSPersistentCloudKitContainer
    NSCoreDataCoreSpotlightDelegate

    #自定义符号
    apply
    body
    cached
    callback
    cancel
    Cancel
    Clear
    Camera
    current
    email
    encoding
    data
    decoded
    Delete
    Delay
    application
    actionSheet
    applicationSupportURL
    applyMask
    applyConstraints
    collectionView
    configure
    configureAppearance
    colors
    contentMode
    cachesDirectory
    currentItem
    currentTime
    debug
    disable
    downloadTask
    enable
    error
    endPoint
    expandMaskEdges
    formattedString
    fromPath
    firstItem
    hide
    hidden
    
    insert
    imageNamed
    images
    imagePickerController
    imagePickerControllerDidCancel
    info
    inputs
    intersection
    itemSize
    jpushNotificationAuthorization
    jpushNotificationCenter
    localized
    left
    labels
    loadImage
    mask
    maskPath
    move
    numbers
    next
    navigationTitle
    onError
    onLoad
    option
    observeValue
    payment
    play
    player
    playerItem
    page
    pause
    prepare
    removeAll
    removeFromSuperview
    reset
    resized
    resetData
    rightBarButtonItem
    reload
    reloadData
    setImage
    selectedSegmentIndex
    separator
    show
    socket
    stop
    sessionId
    selectionLimit
    sourceType
    msgId
    matches
    modificationDate
    startPoint
    startTime
    stopAnimation
    selectedIndex
    table
    tableView
    threshold
    totalSize
    translation
    timeoutInterval
    transactionDate
    unzip
    uuid
    urlSession

    Update
    visibleCells
    vertical
    webView
    warning
    willMove
    with
    WebSocketManager
)

# 新增过滤规则函数
filter_additional_rules() {
    local name="$1"
    local intensity="$2"
    
    # 规则2: 首字母是_的不提取
    if [[ "$name" =~ ^_ ]]; then
        return 1
    fi
    
    # 规则3: 根据强度设置长度过滤
    if [[ "$intensity" == "medium" ]]; then
        # 中度混淆: 长度小于10的不提取
        if [[ ${#name} -lt 10 ]]; then
            return 1
        fi
    else
        # 默认强度: 长度小于4的不提取
        if [[ ${#name} -lt 4 ]]; then
            return 1
        fi
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

# 显示使用说明
show_usage() {
    echo -e "${GREEN}Swift符号提取工具${NC}"
    echo -e "${YELLOW}用法:${NC}"
    echo -e "  $0 [目录] [输出文件] [强度]"
    echo -e "  $0 -h|--help"
    echo ""
    echo -e "${YELLOW}参数说明:${NC}"
    echo -e "  目录        要扫描的Swift项目目录 (默认: $DEFAULT_DIR)"
    echo -e "  输出文件    结果输出文件 (默认: $OUTPUT_FILE)"
    echo -e "  强度        提取强度 (默认: normal)"
    echo ""
    echo -e "${YELLOW}强度选项:${NC}"
    echo -e "  normal      默认强度 - 过滤长度小于4的符号"
    echo -e "  medium      中度混淆 - 过滤长度小于10的符号"
    echo ""
    echo -e "${YELLOW}示例:${NC}"
    echo -e "  $0                                    # 使用默认参数"
    echo -e "  $0 localDrawMJ                       # 指定目录"
    echo -e "  $0 localDrawMJ symbols.txt           # 指定目录和输出文件"
    echo -e "  $0 localDrawMJ symbols.txt medium    # 指定目录、输出文件和中度混淆"
}

main() {
    local target_dir="${1:-$DEFAULT_DIR}"
    local output_file="${2:-$OUTPUT_FILE}"
    local intensity="${3:-$DEFAULT_INTENSITY}"
    
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        show_usage
        exit 0
    fi
    
    # 验证强度参数
    if [[ "$intensity" != "normal" && "$intensity" != "medium" ]]; then
        echo -e "${RED}错误: 无效的强度参数 '$intensity'。支持的选项: normal, medium${NC}"
        show_usage
        exit 1
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
    echo -e "${GREEN}提取强度: $intensity${NC}"
    if [[ "$intensity" == "medium" ]]; then
        echo -e "${YELLOW}  - 中度混淆模式: 过滤长度小于10的符号${NC}"
    else
        echo -e "${YELLOW}  - 默认模式: 过滤长度小于4的符号${NC}"
    fi
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
        if filter_blacklist "$sym" && filter_additional_rules "$sym" "$intensity"; then
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
# 提取强度: $intensity
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
