//
//  EXThemeManager.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/30.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import SwiftTheme

public let THEME_CHANGE_NOTI = "THEME_CHANGE_NOTI"
public let KLINE_CHANGE_NOTI = "KLINE_CHANGE_NOTI"

private let lastThemeIndexKey = "lastedThemeIndex"
private let lastedKlineIndex = "lastedKlineIndex"

private let defaults = UserDefaults.standard

public enum EXThemeManager: Int {
    
    case day   = 0
    case night = 1
    case dayKlinenight = 2
    
    // MARK: -
    public static var current = EXThemeManager.day
    public static var before = EXThemeManager.day
    
    var plistName: String {
        switch self {
        case .day:
            return "DayTheme"
        case .night:
            return "NightTheme"
        case .dayKlinenight:
            return "DayKlineNightTheme"
        }
    }
    
    // MARK: - Switch Theme
    public static func switchTo(theme: EXThemeManager) {
        before = current
        current = theme
        let path = self.getThemePodFrameWorkBundle(podName:"EXKit")?.bundleURL
        
        guard let path = path else {
            print("色值路径查找失败")
            return
        }
        ThemeManager.setTheme(plistName: theme.plistName, path: .sandbox(path))
        saveLastTheme()
        NotificationCenter.default.post(name: NSNotification.Name.init(THEME_CHANGE_NOTI),object: nil)
    }
    
    public static func switchNight(isToNight: EXThemeManager) {
        if current.rawValue != isToNight.rawValue{
            switchTo(theme: isToNight)
        }
    }
    
    public static func isNight() -> Bool {
        return current == .night
    }
    public static func getPodFrameWorkBundle(podName:String) -> Bundle? {
        let podframework = Bundle.main.resourcePath! + "/Frameworks/\(podName).framework/"
        return Bundle(path: podframework)
    }
    
    public static func getThemePodFrameWorkBundle(podName:String) -> Bundle? {
        let podframework = Bundle.main.resourcePath! + "/Frameworks/\(podName).framework/\(podName).bundle"
        return Bundle(path: podframework)
    }
    
    
    public static func restoreLastTheme() {
        if defaults.dictionaryRepresentation().keys.contains(lastThemeIndexKey) {
            let idx = defaults.integer(forKey: lastThemeIndexKey)
            let temptheme = EXThemeManager(rawValue: idx)
            if let themem = temptheme {
                switchTo(theme:themem)
            }else {
                switchTo(theme: .day)
            }
        }else {
            if EXUIDatasource.shared.isDarkConfig {
                switchTo(theme: .night)
            }else {
                switchTo(theme: .day)
            }
        }
    }
    
    public static func saveLastTheme() {
        defaults.set(current.rawValue, forKey: lastThemeIndexKey)
    }
}

public extension EXThemeManager {
    internal static func configurationsFor(theme:EXThemeManager) -> NSDictionary? {
        let podPath = self.getThemePodFrameWorkBundle(podName:"EXKit")?.bundleURL
        guard let podPath = podPath else {
            return nil
        }
        guard let plistPath = ThemePath.sandbox(podPath).plistPath(name: theme.plistName) else {
            return nil
        }
        guard let plistDict = NSDictionary(contentsOfFile: plistPath) else {
            return nil
        }
        return plistDict
    }
}

public enum EXKLineManager: Int {
    case green = 0
    case red = 1
    // MARK: -
    public static var current = EXKLineManager.green
    public static var before = EXKLineManager.green
    
    // MARK: - Switch Theme
    public static func switchTo(theme: EXKLineManager) {
        before = current
        current = theme
        switch theme {
        case .green:
            break
        case .red:
            break
        }
        saveLastKline()
        NotificationCenter.default.post(name: NSNotification.Name.init(KLINE_CHANGE_NOTI),object: nil)
    }

    public static func isGreen() -> Bool {
        return current == .green
    }
    
    public static func restoreLastKline() {
        let idx = defaults.integer(forKey: lastedKlineIndex)
        let temptheme = EXKLineManager(rawValue: idx)
        if let themem = temptheme {
            switchTo(theme:themem)
        }else {
            switchTo(theme: .green)
        }
    }
    
    public static func saveLastKline() {
        defaults.set(current.rawValue, forKey: lastedKlineIndex)
    }
    
}

