//
//  ThemeImages.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/30.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

public extension UIImage {
    
    static func themeImageNamedFromPod(imageName:String) -> UIImage {
        
        guard let podBundle = Bundle.getImageBunlde(podName: "EXKit") else{
            return UIImage()
        }
        
        var newName = imageName
        if EXThemeManager.isNight() {
            newName += "_night"
        }else{
            newName += "_daytime"
        }
        if let img = UIImage(named: newName, in: podBundle, compatibleWith: nil){
            return img
        }
        if let img = UIImage(named: imageName, in: podBundle, compatibleWith: nil){
            return img
        }
        
        return UIImage()
    }
    
    
    static func themeImageNamed(imageName:String) -> UIImage {
        if EXThemeManager.isNight() {
            let temp = UIImage.init(named:imageName + "_night")
            if let exsitImg = temp {
                return exsitImg
            }else {
                if let img = UIImage.init(named: imageName) {
                    return img
                }
            }
            return UIImage()
        }else {
            let temp = UIImage.init(named:imageName + "_daytime")
            if let exsitImg = temp {
                return exsitImg
            }else {
                if let img = UIImage.init(named: imageName) {
                    return img
                }
            }
            return UIImage()
        }
    }
    
    static func themeImageNamed(imageName:String,kline:Bool) -> UIImage {
        if EXThemeManager.current == EXThemeManager.night ||
            (kline == true && EXThemeManager.current == EXThemeManager.dayKlinenight) {
            let temp = UIImage.init(named:imageName + "_night")
            if let exsitImg = temp {
                return exsitImg
            }else {
                if let img = UIImage.init(named: imageName) {
                    return img
                }
            }
            return UIImage()
        }else {
            let temp = UIImage.init(named:imageName + "_daytime")
            if let exsitImg = temp {
                return exsitImg
            }else {
                if let img = UIImage.init(named: imageName) {
                    return img
                }
            }
            return UIImage()
        }
    }
    
    static func themeImageNamedFromPod(imageName:String,kline:Bool) -> UIImage {
        if EXThemeManager.current == EXThemeManager.night ||
            (kline == true && EXThemeManager.current == EXThemeManager.dayKlinenight) {
            let temp = UIImage.init(named:imageName + "_night")
            if let exsitImg = temp {
                return exsitImg
            }else {
                if let img = UIImage.init(named: imageName) {
                    return img
                }
            }
            return UIImage()
        }else {
            let temp = UIImage.init(named:imageName + "_daytime")
            if let exsitImg = temp {
                return exsitImg
            }else {
                if let img = UIImage.init(named: imageName) {
                    return img
                }
            }
            return UIImage()
        }
    }
}
