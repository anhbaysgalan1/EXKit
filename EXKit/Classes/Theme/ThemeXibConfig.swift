//
//  ThemeXibConfig.swift
//  Chainup
//
//  Created by liuxuan on 2019/1/15.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import Foundation
import SwiftTheme

extension NSObject {
    public func loadTheme () {
        EXThemeManager.restoreLastTheme()
    }
}

extension UIColor {
    public static func themeColor(keyPath:String,theme:EXThemeManager = .current) -> UIColor{
        var configurations:NSDictionary? = nil
        if theme == .current {
            configurations = ThemeManager.currentTheme
        }else{
            configurations = EXThemeManager.configurationsFor(theme: theme)
        }
        return themeColor(keyPath: keyPath,configurations: configurations)
    }
    private static func themeColor(keyPath:String,configurations:NSDictionary?) -> UIColor{
        let theme = configurations ?? ThemeManager.currentTheme
        let hexColor = theme?.value(forKeyPath: keyPath)
        if let colorValue = hexColor as? String {
            if colorValue.hasPrefix("#") {
                if colorValue.count == 7 {
                    return UIColor.extColorWithHex(colorValue)
                }else if colorValue.count == 9 {
                    let hexValue = colorValue.suffix(8)
                    var color: UInt32 = 0
                    let hexString: String = hexValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    let scanner = Scanner(string: String(hexString))
                    scanner.scanHexInt32(&color)
                    let mask = 0x000000FF
                    let a = Int(color >> 24) & mask
                    let alpha = CGFloat(a)/CGFloat(255)
                    
                    return UIColor.extColorWithHex("#"+colorValue.suffix(6),alpha:alpha)
                }
            }
        }
        return UIColor.white
    }
    
    public static func gradientColor(keyPath: String, frame: CGRect, startPoint: CGPoint, endPoint: CGPoint) -> UIColor? {
        guard let colorHexArray = ThemeManager.currentTheme?.value(forKeyPath: keyPath) as? Array<String> else { return nil}
        var cgColorArray: Array<CGColor> = []
        
        for colorHex in colorHexArray {
            let cgColor = UIColor.extColorWithHex(colorHex).cgColor
            cgColorArray.append(cgColor)
        }
        
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.colors = cgColorArray
        
        layer.startPoint = startPoint
        layer.endPoint = endPoint
        
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        UIGraphicsEndImageContext()
        return UIColor.init(patternImage: image)
    }
}

extension UIView {
    //设置view背景色
    @IBInspectable public var themebg: String? {
        set {
            guard let newValue = newValue else { return }
            if newValue == kline_up_key {
                let isGreen = EXKLineManager.isGreen()
                if !isGreen {
                    self.theme_backgroundColor = ThemeColorPicker .pickerWithKeyPath(kline_down_key)
                }
            }else if newValue == kline_down_key {
                let isGreen = EXKLineManager.isGreen()
                if !isGreen {
                    self.theme_backgroundColor = ThemeColorPicker .pickerWithKeyPath(kline_up_key)
                }
            }else {
                self.backgroundColor = UIColor.themeColor(keyPath: newValue)
//                self.theme_backgroundColor = ThemeColorPicker .pickerWithKeyPath(newValue)
            }
        }
        get {
            return ""
        }
    }
    //可设置view圆角
     @IBInspectable public var corneradius : CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0.0
        }
    }
    //可设置borderwidth
    @IBInspectable public var borderW: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    //设置bordercolor
    @IBInspectable public var borderC: String? {
        set {
            guard let newValue = newValue else { return }
            layer.theme_borderColor = ThemeCGColorPicker .pickerWithKeyPath(newValue)
        }
        get {
            return ""
        }
    }
}


extension UILabel {
    @IBInspectable public var themeTxtColor: String? {
    
        set {
            guard let newValue = newValue else { return }
            self.theme_textColor = ThemeColorPicker .pickerWithKeyPath(newValue)
        }
        get {
            return ""
        }
    }
}

extension UIImageView {
    
    @IBInspectable public var themeIcon: String? {
        set {
            guard let newValue = newValue else { return }
            self.image  = UIImage.themeImageNamed(imageName: newValue)
        }
        get {
            return ""
        }
    }
}

extension UIButton {
    @IBInspectable public var htitleC: String? {
        set {
            guard let newValue = newValue else { return }
            self.theme_setTitleColor(ThemeColorPicker.pickerWithKeyPath(newValue), forState:.highlighted)
        }
        get {
            return ""
        }
    }
    
    @IBInspectable public var titleC: String? {
        set {
            guard let newValue = newValue else { return }
            self.theme_setTitleColor(ThemeColorPicker.pickerWithKeyPath(newValue), forState:.normal)
        }
        get {
            return ""
        }
    }
    
    @IBInspectable public var themeIcon: String? {
        set {
            guard let newValue = newValue else { return }
            self.setImage(UIImage.themeImageNamed(imageName: newValue), for: .normal)
        }
        get {
            return ""
        }
    }
}

extension UITextField {
    @IBInspectable public var titleC: String? {
        set {
            guard let newValue = newValue else { return }
            self.theme_textColor = ThemeColorPicker .pickerWithKeyPath(newValue)
        }
        get {
            return ""
        }
    }
}

extension NSLayoutConstraint {
    /**
     Change multiplier constraint
     
     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
     */
    public func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem!,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}


