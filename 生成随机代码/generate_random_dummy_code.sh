#!/bin/bash

# Swift 随机no-use代码生成脚本 - 高度随机化版本
# 生成各种不同结构的类、协议、扩展和调用模式

PROJECT_DIR="./localDrawMJ"
DUMMY_DIR="$PROJECT_DIR/DummyCode"
MAIN_FILES=("$PROJECT_DIR/AppDelegate.swift" "$PROJECT_DIR/Home/DYHomeVC.swift")

# 颜色输出
info() { echo -e "[\033[1;32minfo\033[0m] $1"; }
error() { echo -e "[\033[1;31merror\033[0m] $1"; }

# 生成随机字符串
randomString() {
    openssl rand -base64 64 | tr -cd 'a-zA-Z' | head -c $(( RANDOM % 10 + 5 ))
}

# 随机选择数组元素
randomChoice() {
    local arr=("$@")
    echo "${arr[$RANDOM % ${#arr[@]}]}"
}

# 生成随机类名
randomClassName() {
    local prefixes=("DY" "UI" "Core" "Base" "Custom" "Helper" "Manager" "Service" "Tool" "Network" "Data" "Cache" "Security" "Animation" "Graphics")
    local middles=("" "$(randomString)" "Smart" "Auto" "Quick" "Fast" "Secure" "Advanced" "Modern")
    local suffixes=("Controller" "View" "Manager" "Service" "Helper" "Tool" "Handler" "Processor" "Engine" "Factory" "Builder" "Adapter" "Delegate" "Provider")
    
    local prefix=$(randomChoice "${prefixes[@]}")
    local middle=$(randomChoice "${middles[@]}")
    local suffix=$(randomChoice "${suffixes[@]}")
    echo "${prefix}${middle}${suffix}"
}

# 生成随机协议名
randomProtocolName() {
    local adjectives=("Configurable" "Manageable" "Processable" "Cacheable" "Serializable" "Observable" "Trackable" "Validatable")
    local suffix=$(randomChoice "${adjectives[@]}")
    echo "${suffix}$(randomString)"
}

# 生成随机方法名
randomMethodName() {
    local verbs=("process" "handle" "manage" "execute" "perform" "calculate" "validate" "configure" "initialize" "update" "transform" "analyze" "optimize" "synchronize" "authenticate" "encrypt" "decode" "serialize")
    local nouns=("Data" "Request" "Response" "Config" "State" "Info" "Content" "Result" "Value" "Item" "Cache" "Session" "Token" "Metadata" "Payload" "Context")
    local modifiers=("" "Async" "Sync" "Safe" "Fast" "Secure" "Auto" "Smart")
    
    local verb=$(randomChoice "${verbs[@]}")
    local noun=$(randomChoice "${nouns[@]}")
    local modifier=$(randomChoice "${modifiers[@]}")
    echo "${modifier}${verb}${noun}$(randomString)"
}

# 生成随机属性名
randomPropertyName() {
    local adjectives=("current" "default" "main" "active" "selected" "cached" "temp" "local" "global" "shared" "private" "internal" "secure" "encrypted")
    local nouns=("Value" "State" "Config" "Data" "Info" "Content" "Result" "Item" "Object" "Manager" "Handler" "Cache" "Session" "Token")
    
    local adj=$(randomChoice "${adjectives[@]}")
    local noun=$(randomChoice "${nouns[@]}")
    echo "${adj}${noun}$(randomString)"
}

# 生成随机类型
randomType() {
    local types=("String" "Int" "Bool" "Double" "Float" "[String]" "[Int]" "Dictionary<String, Any>" "Set<String>" "Data" "URL" "Date")
    randomChoice "${types[@]}"
}

# 生成随机父类
randomSuperClass() {
    local superClasses=("NSObject" "UIViewController" "UIView" "NSOperation" "URLSessionTask")
    randomChoice "${superClasses[@]}"
}

# 生成随机协议
generateRandomProtocol() {
    local protocolName=$(randomProtocolName)
    local fileName="$DUMMY_DIR/${protocolName}.swift"
    
    local method1=$(randomMethodName)
    local method2=$(randomMethodName)
    local prop1=$(randomPropertyName)
    
    cat > "$fileName" << EOF
//
//  ${protocolName}.swift
//  Generated dummy protocol
//

import Foundation

protocol ${protocolName} {
    var ${prop1}: $(randomType) { get set }
    
    func ${method1}() -> $(randomType)
    func ${method2}(with parameter: $(randomType)) -> Bool
}

// Default implementation
extension ${protocolName} {
    func ${method1}() -> $(randomType) {
        return "$(randomString)" as! $(randomType)
    }
}
EOF

    echo "$protocolName"
}

# 生成随机结构体
generateRandomStruct() {
    local structName="$(randomString)Data"
    local fileName="$DUMMY_DIR/${structName}.swift"
    
    # 生成固定的属性名数组
    local prop1=$(randomPropertyName)
    local prop2=$(randomPropertyName)
    local prop3=$(randomPropertyName)
    
    local type1=$(randomType)
    local type2=$(randomType)
    local type3=$(randomType)
    
    cat > "$fileName" << EOF
//
//  ${structName}.swift
//  Generated dummy struct
//

import Foundation

struct ${structName}: Codable {
    let ${prop1}: ${type1}
    let ${prop2}: ${type2}
    var ${prop3}: ${type3}
    
    init() {
        self.${prop1} = "$(randomString)" as! ${type1}
        self.${prop2} = $(( RANDOM % 1000 )) as! ${type2}
        self.${prop3} = $( [ $((RANDOM % 2)) -eq 0 ] && echo "true" || echo "false" ) as! ${type3}
    }
    
    func $(randomMethodName)() -> $(randomType) {
        return "$(randomString)" as! $(randomType)
    }
}
EOF

    echo "$structName"
}

# 生成随机枚举
generateRandomEnum() {
    local enumName="$(randomString)Type"
    local fileName="$DUMMY_DIR/${enumName}.swift"
    
    cat > "$fileName" << EOF
//
//  ${enumName}.swift
//  Generated dummy enum
//

import Foundation

enum ${enumName}: String, CaseIterable {
    case $(randomString) = "$(randomString)"
    case $(randomString) = "$(randomString)"
    case $(randomString) = "$(randomString)"
    
    var $(randomPropertyName): String {
        return self.rawValue + "_$(randomString)"
    }
    
    func $(randomMethodName)() -> Bool {
        return $( [ $((RANDOM % 2)) -eq 0 ] && echo "true" || echo "false" )
    }
}
EOF

    echo "$enumName"
}

# 生成复杂的虚假类
generateComplexDummyClass() {
    local className=$(randomClassName)
    local fileName="$DUMMY_DIR/${className}.swift"
    local superClass=$(randomSuperClass)
    
    # 随机决定类的复杂度
    local complexity=$(( RANDOM % 4 + 1 ))
    local methodCount=$(( RANDOM % 8 + 3 ))
    local propertyCount=$(( RANDOM % 6 + 2 ))
    
    # 生成方法名数组
    local methods=()
    for ((i=0; i<methodCount; i++)); do
        methods+=("$(randomMethodName)")
    done
    
    # 生成属性名数组
    local properties=()
    for ((i=0; i<propertyCount; i++)); do
        properties+=("$(randomPropertyName)")
    done
    
    cat > "$fileName" << EOF
//
//  ${className}.swift
//  Generated complex dummy class
//

import UIKit
import Foundation

class ${className}: ${superClass} {
    
    // MARK: - Properties
EOF

    # 生成属性
    for prop in "${properties[@]}"; do
        local propType=$(randomType)
        local accessLevel=$(randomChoice "private" "internal" "public")
        echo "    ${accessLevel} var ${prop}: ${propType} = \"$(randomString)\" as! ${propType}" >> "$fileName"
    done
    
    cat >> "$fileName" << EOF
    
    // MARK: - Initialization
EOF

    # 根据父类生成不同的初始化器
    if [[ "$superClass" == "UIView" ]]; then
        cat >> "$fileName" << EOF
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCommonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCommonInit()
    }
    
    private func setupCommonInit() {
        ${methods[0]}()
EOF
        # 随机调用一些初始化方法
        local initCallCount=$(( RANDOM % 3 + 1 ))
        for ((i=1; i<=initCallCount && i<${#methods[@]}; i++)); do
            echo "        ${methods[i]}()" >> "$fileName"
        done
        echo "    }" >> "$fileName"
    elif [[ "$superClass" == "UIViewController" ]]; then
        cat >> "$fileName" << EOF
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupCommonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCommonInit()
    }
    
    private func setupCommonInit() {
        ${methods[0]}()
EOF
        # 随机调用一些初始化方法
        local initCallCount=$(( RANDOM % 3 + 1 ))
        for ((i=1; i<=initCallCount && i<${#methods[@]}; i++)); do
            echo "        ${methods[i]}()" >> "$fileName"
        done
        echo "    }" >> "$fileName"
    else
        # 对于 NSObject 和其他类，使用默认的 init()
        cat >> "$fileName" << EOF
    override init() {
        super.init()
        ${methods[0]}()
EOF
        # 随机调用一些初始化方法
        local initCallCount=$(( RANDOM % 3 + 1 ))
        for ((i=1; i<=initCallCount && i<${#methods[@]}; i++)); do
            echo "        ${methods[i]}()" >> "$fileName"
        done
        echo "    }" >> "$fileName"
    fi
    
    // MARK: - Public Methods
EOF

    # 生成方法实现
    for ((i=0; i<${#methods[@]}; i++)); do
        local method=${methods[i]}
        local returnType=$(randomChoice "Void" "String" "Int" "Bool" "$(randomType)")
        
        if [[ "$returnType" == "Void" ]]; then
            cat >> "$fileName" << EOF
    func ${method}() {
         let _ = "$(randomString)"
        let _ = $(( RANDOM % 1000 ))
EOF
        else
            cat >> "$fileName" << EOF
    func ${method}() -> ${returnType} {
        let result = "$(randomString)" as! ${returnType}
EOF
        fi
        
        # 随机调用其他方法
        if (( i < ${#methods[@]} - 1 )); then
            local nextMethod=${methods[$(( i + 1 ))]}
            echo "        ${nextMethod}()" >> "$fileName"
        fi
        
        if [[ "$returnType" != "Void" ]]; then
            echo "        return result" >> "$fileName"
        fi
        echo "    }" >> "$fileName"
        echo "" >> "$fileName"
    done
    
    # 生成静态方法
    cat >> "$fileName" << EOF
    // MARK: - Static Methods
    static func create${className}() -> ${className} {
        let instance = ${className}()
        instance.${methods[0]}()
        return instance
    }
    
    static func $(randomMethodName)() -> $(randomType) {
        return "$(randomString)" as! $(randomType)
    }
}

// MARK: - Extension
extension ${className} {
    
    func $(randomMethodName)() {
        let _ = "$(randomString)"
        ${methods[$(( RANDOM % ${#methods[@]} ))]}()
    }
    
    var $(randomPropertyName): $(randomType) {
        return "$(randomString)" as! $(randomType)
    }
}
EOF

    echo "$className"
}

# 生成随机调用代码
generateRandomCallCode() {
    local className=$1
    local callPatterns=(
        "lazy_initialization"
        "factory_pattern"
        "observer_pattern"
        "singleton_access"
        "async_operation"
    )
    
    local pattern=$(randomChoice "${callPatterns[@]}")
    local methodName="handle$(randomString)"
    
    case $pattern in
        "lazy_initialization")
            echo "
    // MARK: - Lazy Initialization Pattern
    private lazy var $(randomPropertyName): ${className} = {
        let instance = ${className}()
        return instance
    }()
    
    private func ${methodName}() {
        let _ = $(randomPropertyName)
        $(randomPropertyName).$(randomMethodName)()
    }"
            ;;
        "factory_pattern")
            echo "
    // MARK: - Factory Pattern
    private func create$(randomString)() -> ${className} {
        return ${className}.create${className}()
    }
    
    private func ${methodName}() {
        let instances = (0..<$(( RANDOM % 3 + 1 ))).map { _ in create$(randomString)() }
        instances.forEach { $0.$(randomMethodName)() }
    }"
            ;;
        "observer_pattern")
            echo "
    // MARK: - Observer Pattern
    private var $(randomPropertyName): [${className}] = []
    
    private func register$(randomString)(_ observer: ${className}) {
        $(randomPropertyName).append(observer)
    }
    
    private func ${methodName}() {
        $(randomPropertyName).forEach { $0.$(randomMethodName)() }
    }"
            ;;
        "singleton_access")
            echo "
    // MARK: - Singleton Access
    private static let shared$(randomString) = ${className}()
    
    private func ${methodName}() {
        let _ = Self.shared$(randomString)
        Self.shared$(randomString).$(randomMethodName)()
    }"
            ;;
        "async_operation")
            echo "
    // MARK: - Async Operation
    private func ${methodName}() {
        DispatchQueue.global().async {
            let instance = ${className}()
            instance.$(randomMethodName)()
            DispatchQueue.main.async {
                let _ = instance.$(randomPropertyName)
            }
        }
    }"
            ;;
    esac
}

# 插入代码到现有文件
insertCodeToFile() {
    local filePath=$1
    local code=$2
    
    if [[ -f "$filePath" ]]; then
        echo "$code" >> "$filePath"
        info "Inserted random dummy code to $(basename "$filePath")"
    fi
}

# 清理现有虚假代码
cleanExistingDummyCode() {
    if [[ -d "$DUMMY_DIR" ]]; then
        rm -rf "$DUMMY_DIR"
        info "Cleaned existing dummy code"
    fi
}

# 主函数
main() {
    case $1 in
        "-g"|"--generate")
            info "Generating highly randomized dummy Swift code..."
            
            cleanExistingDummyCode
            mkdir -p "$DUMMY_DIR"
            
            declare -a generatedItems
            
            # 生成协议
            for i in {1..2}; do
                protocolName=$(generateRandomProtocol)
                generatedItems+=("protocol:$protocolName")
                info "Generated protocol: $protocolName"
            done
            
            # 生成结构体
            for i in {1..2}; do
                structName=$(generateRandomStruct)
                generatedItems+=("struct:$structName")
                info "Generated struct: $structName"
            done
            
            # 生成枚举
            enumName=$(generateRandomEnum)
            generatedItems+=("enum:$enumName")
            info "Generated enum: $enumName"
            
            # 生成复杂类
            for i in {1..4}; do
                className=$(generateComplexDummyClass)
                generatedItems+=("class:$className")
                info "Generated complex class: $className"
            done
            
            # 为主要文件添加随机调用代码
            for mainFile in "${MAIN_FILES[@]}"; do
                if [[ -f "$mainFile" ]]; then
                    for item in "${generatedItems[@]}"; do
                        IFS=':' read -r type name <<< "$item"
                        if [[ "$type" == "class" ]]; then
                            callCode=$(generateRandomCallCode "$name")
                            insertCodeToFile "$mainFile" "$callCode"
                        fi
                    done
                fi
            done
            
            info "Highly randomized dummy code generation completed!"
            info "Generated ${#generatedItems[@]} items in $DUMMY_DIR"
            ;;
            
        "-c"|"--clean")
            info "Cleaning dummy code..."
            cleanExistingDummyCode
            info "Please manually remove dummy extensions from main files"
            ;;
            
        "-h"|"--help")
            echo "Usage: $0 [option]"
            echo "Options:"
            echo "  -g, --generate    Generate highly randomized dummy Swift code"
            echo "  -c, --clean       Clean generated dummy code"
            echo "  -h, --help        Show this help message"
            ;;
            
        *)
            error "Invalid option. Use -h for help."
            ;;
    esac
}

main $@
