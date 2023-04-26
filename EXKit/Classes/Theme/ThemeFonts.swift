//
//  ThemeFonts.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/12.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

public extension UIFont {
    class func fontWithName(fontName: String, size: CGFloat) -> UIFont? {
        if let f = UIFont(name: fontName, size: size) {
            return f
        }
        return UIFont.systemFont(ofSize: size)

    }

    struct ThemeFont {
        public static var RMedium :UIFont { return  getFont(size: 32, aweight: .medium)}
        public static var H1Medium :UIFont { return getFont(size: 28, aweight: .medium)}
        public static var H1Bold :UIFont { return   getFont(size: 28, aweight: .medium)}
        public static var H2Medium :UIFont { return getFont(size: 24, aweight: .medium)}
        public static var H2Bold :UIFont { return   getFont(size: 24, aweight: .medium)}
        public static var H3Bold :UIFont { return   getFont(size: 18, aweight: .medium)}
        public static var H3Medium :UIFont { return getFont(size: 18, aweight: .medium)}
        public static var H3Regular :UIFont { return getFont(size: 18, aweight: .regular)}
        public static var HeadRegular :UIFont { return getFont(size: 16, aweight: .regular)}
        public static var HeadMedium :UIFont { return getFont(size: 16, aweight: .medium)}
        public static var HeadBold :UIFont { return getFont(size: 16, aweight: .medium)}
        public static var BodyRegular:UIFont { return getFont(size: 14, aweight: .regular)}
        public static var BodyMedium:UIFont { return getFont(size: 14, aweight: .medium)}
        public static var BodyBold :UIFont { return  getFont(size: 14, aweight: .medium)}
        public static var Semibold :UIFont { return  getFont(size: 14, aweight: .medium)}
        public static var BodyBoldTalic : UIFont{return UIFont.init(name: "Arial-BoldItalicMT", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)}
        public static var SecondaryBold:UIFont { return  getFont(size: 12, aweight: .medium)}
        public static var SecondaryRegular :UIFont { return  getFont(size: 12, aweight: .regular)}
        public static var SecondaryMedium :UIFont { return getFont(size: 12, aweight: .medium)}
        public static var MinimumRegular:UIFont { return getFont(size: 10, aweight: .regular)}
        public static var MinimumBold :UIFont { return getFont(size: 10, aweight: .medium)}
        public static var TagRegular:UIFont { return getFont(size: 8, aweight: .regular)}
        
        
        private static var fontNames:[UIFont.Weight:String] = [:]
        public static func getFontPath(size:CGFloat,aweight:Weight) ->UIFont? {
            var fontName = fontNames[aweight]
            if fontName == nil {
                var path = ""
                if aweight == .bold {
                    path = EXKitDataSource.shareInstance.fontBoldPath ?? ""
                }else if aweight == .medium {
                    path = EXKitDataSource.shareInstance.fontMediumPath ?? ""
                }else if aweight == .regular {
                    path = EXKitDataSource.shareInstance.fontRegularPath ?? ""
                }
                if path.isEmpty {
                    return nil
                }
                
                let fontUrl = URL(fileURLWithPath: path)
                if let fontData = CGDataProvider(url: fontUrl as CFURL) {
                    if let fontRef = CGFont(fontData) {
                        CTFontManagerRegisterGraphicsFont(fontRef, nil)
                        fontName = fontRef.postScriptName! as String
                        fontNames[aweight] = fontName
                    }
                }
            }
            guard let fontName = fontName,let font = UIFont(name: fontName, size: size) else {
                return nil
            }
            return font
            
        }

        public static func getFont(size:CGFloat,aweight:Weight) ->UIFont {
            
            
            if aweight == .bold {
                
                if let hnFont = getFontPath(size: size, aweight: aweight) {
                    return hnFont
                }else {
                    return UIFont.systemFont(ofSize: size, weight: aweight)
                }
            }else if aweight == .medium {
                if let hnFont = getFontPath(size: size, aweight: aweight) {
                    return hnFont
                }else {
                    return UIFont.systemFont(ofSize: size, weight: aweight)
                }
            }else {
                if let hnFont = getFontPath(size: size, aweight: aweight) {
                    return hnFont
                }else {
                    return UIFont.systemFont(ofSize: size, weight: aweight)
                }
            }
        }
        
        public static func getPFSCFont(size:CGFloat,aweight:Weight) ->UIFont {
            if aweight == .bold {
                if let hnFont = UIFont.init(name: "PingFang SC Medium", size: size) {
                    return hnFont
                }else {
                    return UIFont.systemFont(ofSize: size, weight: aweight)
                }
            }else if aweight == .medium {
                if let hnFont = UIFont.init(name: "PingFang SC Medium", size: size) {
                    return hnFont
                }else {
                    return UIFont.systemFont(ofSize: size, weight: aweight)
                }
            }else {
                if let hnFont = UIFont.init(name: "PingFang SC", size: size) {
                    return hnFont
                }else {
                    return UIFont.systemFont(ofSize: size, weight: aweight)
                }
            }
        }
        
        
    }
}

public extension NSObject {
    
    /*
     == DINPro-Medium
     == DINPro-Regular
     == DINPro-Bold
     */
    func themeHNFont(size:CGFloat) -> UIFont{
        return UIFont.ThemeFont.getFont(size: size, aweight: .regular)
    }
    
    func themeHNBoldFont(size:CGFloat)  -> UIFont{
        return UIFont.ThemeFont.getFont(size: size, aweight: .medium)
    }
    
    func themeHNMediumFont(size:CGFloat)  -> UIFont{
        return UIFont.ThemeFont.getFont(size: size, aweight: .medium)
    }
    
    func themeHNBoldItalicFont(size:CGFloat)  -> UIFont{
        if let hnFont = UIFont.init(name: "HelveticaNeue-BoldItalic", size: size) {
            return hnFont
        }else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
}

extension UIFont {
    public struct Ex {
        public static func regular(_ size:CGFloat) -> UIFont {
            return DIN(size: size, weight: .regular)
        }
        public static func medium(_ size:CGFloat) -> UIFont {
            return DIN(size: size, weight: .medium)
        }
        public static func bold(_ size:CGFloat) -> UIFont {
            return DIN(size: size, weight: .bold)
        }
        public static func DIN(size:CGFloat, weight:UIFont.Weight) -> UIFont {
            return ThemeFont.getFont(size: size, aweight: weight)
        }
        public static func PingFangSC(size:CGFloat, weight:UIFont.Weight) -> UIFont {
            return ThemeFont.getPFSCFont(size: size, aweight: weight)
        }
    }
}
