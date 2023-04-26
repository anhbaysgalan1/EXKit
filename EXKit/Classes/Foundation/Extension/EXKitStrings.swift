//
//  StringExtensions.swift
//  EXKit
//
//  Created by liuxuan on 2022/7/7.
//

import Foundation
import YYText
//string -> float ,string -> double
//string -> cgsize
//string -> cgsize
//changes????
public extension String {
    
    func util_subString(end: Int) -> String{
        if !(end <= count) { return self }
        let sInde = index(startIndex, offsetBy: end)
        return String(self[..<sInde])
    }
    
    func util_characterAtIndex(index:Int) -> Character
    {
        let ch = self[self.index(self.startIndex, offsetBy: index)]
        return ch
    }
    
    // Allows us to use String[index] notation
    subscript(index:Int) -> Character
    {
        return util_characterAtIndex(index: index)
    }
    
    
    func stringToFloat() -> (CGFloat) {
        let string = self
        var cgFloat:CGFloat = 0
        if let doubleValue = Double(string){
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }
    
    //判断字符高度，需传入字符大小和宽度
    //返回的是宽度和高度
    func textSizeWithFont(_ font: UIFont, width:CGFloat,option : NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin) -> CGSize {
        
        var textSize:CGSize!
        
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        if size.equalTo(CGSize.zero) {
            
            let attributes = [NSAttributedString.Key.font:font]
            
            textSize = self.size(withAttributes: attributes)
            
        } else {
            
            let attributes = [NSAttributedString.Key.font:font]
            
            let stringRect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
            
            textSize = stringRect.size
        }
        return textSize
    }
    
    func textHeightSizeWithFont(_ font: UIFont, height:CGFloat,option : NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin) -> CGSize {
        
        var textSize:CGSize!
        
        let size = CGSize(width: 10000, height: height)
        
        if size.equalTo(CGSize.zero) {
            
            let attributes = [NSAttributedString.Key.font:font]
            
            textSize = self.size(withAttributes: attributes)
            
        } else {
            
            let attributes = [NSAttributedString.Key.font:font]
            
            let stringRect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
            
            textSize = stringRect.size
        }
        return textSize
    }
    
    
    
    /**
     string字符串截取
     */
    func extStringSub(_ range : NSRange)->String{
        
        let beforeStr = NSString.init(string: self)
        
        let afterStr = beforeStr.substring(with: range)
        
        return afterStr as String
    }
    
    
    /// 字符串截取(可数的闭区间)例子：
    /// let str = "hello word"
    /// let tmpStr = hp[0 ... 5] tmpStr = hello
    /// - Parameter r: 字符串范围
    subscript (r: CountableClosedRange<Int>) -> String{
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            var endIndex:String.Index?
            if r.upperBound > self.count{
                endIndex = self.index(self.startIndex, offsetBy: self.count)
            }else{
                endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            }
            return String(self[startIndex..<endIndex!])
        }
    }
    
    
    /// 字符串截取(可数的开区间)例子：
    /// let str = "hello word"
    /// let tmpStr = hp[0 ..< 5] tmpStr = hello
    /// - Parameter r: 字符串范围
    subscript (r: CountableRange<Int>) -> String{
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            var endIndex:String.Index?
            if r.upperBound > self.count{
                endIndex = self.index(self.startIndex, offsetBy: self.count)
            }else{
                endIndex = self.index(self.startIndex, offsetBy: r.upperBound-1)
            }
            return String(self[startIndex..<endIndex!])
        }
    }
    
    
    //覆盖
    mutating func coverStringWithString(_ str : String ,startIndex : Int = 0 , endindex : Int){
        if self.count > endindex && startIndex < endindex{
            let index = endindex - startIndex
            var tmpstr = ""
            for _ in 0..<index{
                tmpstr = tmpstr + str
            }
            if let range = Range.init(NSRange.init(location: startIndex, length: index), in: self){
                self.replaceSubrange(range, with: tmpstr)
            }
        }else if self.count > startIndex && startIndex < endindex{
            let index = self.count - startIndex
            var tmpstr = ""
            for _ in 0..<index{
                tmpstr = tmpstr + str
            }
            if let range = Range.init(NSRange.init(location: startIndex, length: index), in: self){
                self.replaceSubrange(range, with: tmpstr)
            }
        }
    }
    
    //返回第一次出现的指定子字符串在此字符串中的索引
    //（如果backwards参数设置为true，则返回最后出现的位置）
    func positionOf(sub:String, backwards:Bool = false)->Int {
        var pos = -1
        if let range = range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
    
}



//MARK: regular Expression
public extension String {
    
    /**
     判断字符串是否为纯数字
     
     - returns: value
     */
    func isNumber() -> Bool{
        if self.count == 0{
            return false
        }else{
            let reg = "[0-9]*"
            let predicate = NSPredicate.init(format: "SELF MATCHES %@", reg)
            let result = predicate.evaluate(with: self)
            return result
        }
    }
    
    //判断是否符合交易密码规则，数字+字母，大于等于8位小于等于20
    func isValidTransactionpPwd() -> Bool {
        return isValidRegex(regex: "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$")
    }
    
    //判断是否符合输入金额、币种数量规则。decimal==0只能输入整数。其余，按decimal规则输入。
    //不能连续输入00，开头不能输入小数点，小数点也只能输入1个
    func isValidInputAmount(decimal:Int = 18) -> Bool {
        if decimal == 0 {
            //只能输入整数
            return isValidRegex(regex: "^\\+?[1-9][0-9]*$")
        }else {
            //通用输入，默认小数点后可输入18位
            let regex = "^[0][0-9]+$"
            let regexDot = "^[.]+$"
            let predicate0 = NSPredicate(format: "SELF MATCHES %@", regex)
            let predicateDot = NSPredicate(format: "SELF MATCHES %@", regexDot)
            
            let isZeroPrefix = predicate0.evaluate(with: self)
            let isDotPrefix = predicateDot.evaluate(with: self)
            
            if  isZeroPrefix || isDotPrefix {
                return false
            }
            
            return isValidRegex(regex: "^([0-9]*)?([\\,\\.])?([0-9]{0,\(decimal)})?$")
        }
    }
    
    private func isValidRegex(regex: String) -> Bool {
        let regex = regex
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let valid = predicate.evaluate(with: self)
        return valid
    }
    
    static func placeholderAttributeString(placeholder:String,fontSize:Int = 12,color:UIColor = UIColor.ThemeLabel.colorLite) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString.init(string: placeholder,
                                                              attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(fontSize)),
                                                                          NSAttributedString.Key.foregroundColor: color])
        return attributedString
    }
}

//MARK: caculate
public extension String {
    
    func StringToFloat()->(CGFloat){
        let string = self
        var cgFloat:CGFloat = 0
        if let doubleValue = Double(string){
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }
    
    func greaterThanOrEqualto(_ a:String) ->Bool  {
        return (self as NSString).isBig(a) || (self as NSString).isEqualValue(a)
    }
    
    func lessThanOrEqualto(_ a:String) ->Bool  {
        return (self as NSString).isSmall(a) || (self as NSString).isEqualValue(a)
    }
    
    func isEquals(_ a:String) -> Bool {
        return (self as NSString).isEqualValue(a)
    }
    
    func isSmallerThan(_ a:String) -> Bool {
        return (self as NSString).isSmall(a)
    }
    
    func isBiggerThan(_ a:String) -> Bool {
        return (self as NSString).isBig(a)
    }
    
    func stringByAding(sub:String,decimal:Int) -> String {
        return (self as NSString).adding(sub, decimals: decimal)
    }
    
    func stringBySubtracting(sub:String,decimal:Int,roundDown:Bool = true) -> String {
        if roundDown {
            return (self as NSString).subtractingRoundDown(sub, decimals: decimal)
        }else {
            return (self as NSString).subtracting(sub, decimals: decimal)
        }
    }
    
    func stringByDividing(divide:String,decimal:Int,roundDown:Bool = false) -> String {
        if roundDown {
            return (self as NSString).dividingRoundDown(by: divide, decimals: decimal)
        }else {
            return (self as NSString).dividing(by: divide, decimals: decimal)
        }
    }
    
    func decimalString(value:Int,alwaysRounding:Bool = false,holdZero:Bool = true) -> String {
        if alwaysRounding {
            return (self as NSString).decimalStringAlwaysRounding(value, holdsZero: holdZero)
        }else {
            if holdZero {
                return (self as NSString).decimalString1(value)
            }else {
                return (self as NSString).decimalString(value)
            }
        }
    }
    
    //roundplain 四舍五入
    func stringByMultiplying(multiple:String,decimal:Int,holdZero:Bool = false,useRoundPlain:Bool = false) -> String {
        if useRoundPlain {
            return (self as NSString).multiplyingBy1(multiple, decimals: decimal, holdZero: holdZero)
        }else {
            return (self as NSString).multiplying(by: multiple, decimals: decimal,holdZeor: holdZero)
        }
    }
    
    
    func formatAmountUseDecimal(_ decimal:String, holdZero:Bool = true) -> String {
        
        if self.isEmpty {
            return ""
        }
        
        if self == "--" {
            return self
        }
        
        if decimal.isEmpty {
            return self
        }
        
        guard let numberDecimal = Int(decimal) else {return self}
        let nsAmount = self as NSString
        if holdZero {
            let rst = nsAmount.decimalString1(numberDecimal)
            if let rightRst = rst {
                return rightRst
            }
            return self
        }else {
            let rst = nsAmount.decimalString(numberDecimal)
            if let rightRst = rst {
                return rightRst
            }
            return self
        }
    }
}


//MARK: app相关

public extension String {
    
    func decimalNumberWithDouble() -> String{
        if let conversionValue = Double(self){
            let decimalNumberWithDouble = String(conversionValue)
            let decNumber = NSDecimalNumber.init(string: decimalNumberWithDouble as String)
            return "\(decNumber)"
        }
        return self
    }
    
    
    func fmtTimeStr(_ fmt:String = "yyyy-MM-dd HH:mm:ss") -> String {
        var time = TimeInterval.init(0)
        if self.count >= 13{
            if let t = TimeInterval.init(self.prefix(10)){
                time = t
            }
        }else{
            if let t = TimeInterval.init(self){
                time = t
            }
        }
        return DateTools.dateToString(time ,dateFormat:fmt)
    }
    

    func copyToPasteBoard() {
        UIPasteboard.general.string = self
    }
    
    static func privacyString() -> String{
        return "*****"
    }
    
    //小额限制，展示最小btc的资产配置
    static func limitSatoshi() -> String {
        return "0.0001"
    }
    
    func md5PngFileName() ->String {
        return AppService.md5(self) + "@2x"
    }
    
    func isChinese() -> Bool{
        let match: String = "(^[\\u4e00-\\u9fa5]+$)"
        let predicate = NSPredicate(format: "SELF matches %@", match)
        return predicate.evaluate(with: self)
    }
    
    func isEmail() -> Bool {
        return isValidRegex(regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{0,25}")
    }
    func isPhone() -> Bool {
        return isValidRegex(regex: "^[0-9]{5,11}$")
    }
    func isChinaPhone() -> Bool {
        return isValidRegex(regex: "^1[0-9]{10}$")
    }
    
    func getValueColor() ->UIColor {
        if self.isBiggerThan("0") {
            return UIColor.ThemekLine.up
        }else if self.isEquals("0") {
            return UIColor.ThemeLabel.colorLite
        }else {
            return UIColor.ThemekLine.down
        }
    }
    
    func plusSymbolStr() ->String {
        if self.isBiggerThan("0") {
            return "+" + self
        }else {
            return self
        }
    }
    
    func desensitizedPhone() -> String {
        if self.count < 7 {
            return self
        }
        var start = ""
        for _ in 0..<self.count - 5 {
            start += "*"
        }
        let range = Range.init(NSRange.init(location: 3, length: self.count - 5), in: self)
        return self.replacingCharacters(in:range!, with: start)
    }
    
    func desensitizedMail() -> String {
        
        let array = self.components(separatedBy: "@")
        if array.count == 0 {
            return self
        }
        if let name = array.first {
            if name.count == 1 {
                return self
            }
            if name.count >= 4 {
                let range = Range.init(NSRange.init(location: 3, length: name.count - 3), in: self)
                return self.replacingCharacters(in:range!, with: "****")
            }
            else {
                let range = Range.init(NSRange.init(location: 1, length: name.count - 1), in: self)
                return self.replacingCharacters(in:range!, with: "****")
            }
        }
        return self
    }
    
    
    static func makeTipsAttributedString(content: String,
                                         actionContent: String,
                                         action: @escaping (() -> ())) -> NSMutableAttributedString {
        let accatt = NSMutableAttributedString.init().add(string: content, attrDic: [NSAttributedString.Key.foregroundColor : UIColor.ThemeLabel.colorDark , NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .medium)]).add(string: actionContent, attrDic: [NSAttributedString.Key.foregroundColor : UIColor.ThemeLabel.colorHighlight , NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .medium)])
        accatt.highLightTap((accatt.string as NSString).range(of: actionContent), { (view, attstr, range, rect) in
            action()
        })
        return accatt
    }
    
    
    func lineSpacingString(font: UIFont, color: UIColor, lineSpacing: CGFloat, textAligment: NSTextAlignment = NSTextAlignment.center) -> NSAttributedString {
        let paraph = NSMutableParagraphStyle()
        paraph.alignment = textAligment
        paraph.lineSpacing = lineSpacing
        let attributes = [NSAttributedString.Key.font: font,
                          NSAttributedString.Key.foregroundColor: color,
                          NSAttributedString.Key.paragraphStyle: paraph]
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    static func getCoinMapAttr(_ name:String ,
                         leftColor:UIColor = UIColor.ThemeLabel.colorLite,
                               leftFont: UIFont = UIFont.ThemeFont.HeadRegular,
                         rightColor:UIColor = UIColor.ThemeLabel.colorMedium,
                         rightFont:UIFont = UIFont.ThemeFont.SecondaryRegular) -> NSMutableAttributedString
     {
         let array = name.components(separatedBy: "/")
         if array.count >= 2{
             return self.getCoinMapWith(array[0], leftColor: leftColor, leftFont: leftFont, rightStr: array[1], rightColor: rightColor, rightFont: rightFont)
         }else{
             return self.getCoinMapWith(name, leftColor: leftColor, leftFont: leftFont, rightStr: "", rightColor: rightColor, rightFont: rightFont)
         }
     }
    static func getSwapCoinMapAttr(_ name:String ,
                         leftColor:UIColor = UIColor.ThemeLabel.colorLite,
                               leftFont: UIFont = UIFont.ThemeFont.HeadRegular,
                         rightColor:UIColor = UIColor.ThemeLabel.colorMedium,
                         rightFont:UIFont = UIFont.ThemeFont.SecondaryRegular) -> NSMutableAttributedString
     {
         
         var array = name.components(separatedBy: "-")
         if array.count >= 2{
             let right = array.last!
             var left = array[0]
             if array.count > 2 {
                 array.removeLast()
                 left = array.joined(separator: "-")
             }
             return self.getCoinMapWith(left, leftColor: leftColor, leftFont: leftFont, rightStr: right, rightColor: rightColor, rightFont: rightFont,joinStr: "-")
         }else{
             return self.getCoinMapWith(name, leftColor: leftColor, leftFont: leftFont, rightStr: "", rightColor: rightColor, rightFont: rightFont,joinStr: "-")
         }
     }
     static func getCoinMapWith(_ leftStr : String ,
                         leftColor : UIColor = UIColor.ThemeLabel.colorLite,
                         leftFont : UIFont = UIFont.ThemeFont.HeadBold,
                         rightStr : String , rightColor : UIColor = UIColor.ThemeLabel.colorMedium,
                         rightFont : UIFont = UIFont.ThemeFont.SecondaryRegular,
                                joinStr: String? = "/"
     ) -> NSMutableAttributedString{
         var att = NSMutableAttributedString().add(string: leftStr, attrDic: [NSAttributedString.Key.foregroundColor : leftColor,NSAttributedString.Key.font : leftFont])
         if rightStr != ""{
             att = att.add(string: "\(joinStr!)\(rightStr)", attrDic: [NSAttributedString.Key.foregroundColor : rightColor,NSAttributedString.Key.font : rightFont])
         }
         return att
     }
    
}

//MARK: RANGE
public extension String {
    
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    func ranges(of searchString: String,
                options mask: NSString.CompareOptions = [],
                locale: Locale? = nil) -> [Range<String.Index>]
    {
        var ranges: [Range<String.Index>] = []
        while let range = range(of: searchString, options: mask, range: (ranges.last?.upperBound ?? startIndex)..<endIndex, locale: locale) {
            ranges.append(range)
        }
        return ranges
    }
    
    func nsRanges(of searchString: String,
                  options mask: NSString.CompareOptions = [],
                  locale: Locale? = nil) -> [NSRange]
    {
        let ranges = self.ranges(of: searchString, options: mask, locale: locale)
        return ranges.map { nsRange(from: $0) }
    }
}

//MARK: handle Domains
public extension String {
    
    func hostStr() -> String {
        if let url = URL.init(string: self),let host = url.host {
            var paths = host.components(separatedBy: ".")
            if paths.count == 3 {
                paths.remove(at: 0)
            }
            let domain = paths.joined(separator: ".")
            return domain
        }
        return self
    }
    
    func fullDomain() -> String {
        if let url = URL.init(string: self),let host = url.host {
            return host
        }
        return self
    }
    
    //从ip链接取appapi000xxxx还是从正常连接取appapi000xxx
    func hostCompany(_ fromIpAddress:Bool = false) -> String {
        if let url = URL.init(string: self),let host = url.host {
            if fromIpAddress {
                var path = url.path
                if path.hasPrefix("/") {
                    path.removeFirst()
                }
                let paths = path.components(separatedBy: "/")
                if paths.count > 0 {
                    return paths[0]
                }
            }else {
                let paths = host.components(separatedBy: ".")
                if paths.count > 0 {
                    return paths[0]
                }
            }
        }
        return self
    }
}


public extension NSMutableAttributedString{
    
    func highLightTap(_ range : NSRange , _ tapAction : @escaping ((UIView, NSAttributedString, NSRange, CGRect) -> ())){
        let highLightOfReplyUser = YYTextHighlight()
        highLightOfReplyUser.tapAction = tapAction
        self.yy_setTextHighlight(highLightOfReplyUser, range:range)
    }
    
    func add(attString : NSAttributedString) -> NSMutableAttributedString{
        self.append(attString)
        return self
    }
    
    func add(string : String, attrDic : [NSAttributedString.Key : Any])-> NSMutableAttributedString{
        self.append(NSAttributedString.init(string: string, attributes: attrDic))
        return self
    }
    
    func appendAttributedString(_  att : NSAttributedString) -> NSMutableAttributedString{
        self.append(att)
        return self
    }
}
public extension String {
    
    var urlStr: String{
        var charSet = CharacterSet.urlQueryAllowed
        charSet.insert(charactersIn: "#")
        let encodingURL = self.addingPercentEncoding(withAllowedCharacters: charSet )
        return encodingURL ?? ""
    }
    /*
     *去掉首尾空格
     */
    var removeHeadAndTailSpace:String {
        let whitespace = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉首尾空格 包括后面的换行 \n
     */
    var removeHeadAndTailSpacePro:String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉所有空格
     */
    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    /*
     *去掉首尾空格 后 指定开头空格数
     */
    func beginSpaceNum(num: Int) -> String {
        var beginSpace = ""
        for _ in 0..<num {
            beginSpace += " "
        }
        return beginSpace + self.removeHeadAndTailSpacePro
    }
}

public extension String {
    func getHeightlineH(width: CGFloat, font: CGFloat, lineH: CGFloat) -> CGFloat {

         let paraph = NSMutableParagraphStyle()
         paraph.lineSpacing = lineH
         //样式属性集合
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: font),
                          NSAttributedString.Key.paragraphStyle: paraph]
         let rect = self.boundingRect(with: CGSize(width: width, height: 9999), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
         return rect.size.height + 1
     }
    func getHeightline(width: CGFloat, font: CGFloat, lineH: CGFloat) -> CGFloat {

         let paraph = NSMutableParagraphStyle()
         paraph.lineSpacing = lineH
         //样式属性集合
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: font),
                          NSAttributedString.Key.paragraphStyle: paraph]
         let rect = self.boundingRect(with: CGSize(width: width, height: 9999), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
         return rect.size.height + 1
     }
    func getTextWidth(width: CGFloat = Device_W, font: CGFloat, lineH: CGFloat = 0) -> CGFloat {

         let paraph = NSMutableParagraphStyle()
         paraph.lineSpacing = lineH
         //样式属性集合
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: font),
                          NSAttributedString.Key.paragraphStyle: paraph]
         let rect = self.boundingRect(with: CGSize(width: width, height: 9999), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.size.width
     }
}
