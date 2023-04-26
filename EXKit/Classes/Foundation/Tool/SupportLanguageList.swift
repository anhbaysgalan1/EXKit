//
//  SupportLanguageList.swift
//  EXKit
//
//  Created by liuxuan on 2022/7/8.
//

import UIKit
import MJExtension

@objcMembers class LanguageItem:NSObject {
    var key:String = ""
    var resource:String = ""
    var server:String = ""
}


class SupportLanguageList: NSObject {
    
    var supportLans:[LanguageItem] = []
    //resource 是本地ios的文件名
    //server 是服务端返回的下划线的
    //key判断用
    static let languageList :[[String:String]] = [
        [
            "key":"zh-Hans",
            "resource": "zh-Hans",
            "server": "zh_CN"
        ],
        [
            "key":"zh-Hant",
            "resource": "zh-Hant",
            "server": "el_GR"
        ],
        [
            "key":"zh-Hant",
            "resource": "zh-Hant",
            "server": "zh_TC"//这里放在后面:el_GR和zh_TC都是繁体中文,因为使用的代码遍历没有break,所以后面的数据会生效
        ],
        [
            "key":"en",
            "resource": "en",
            "server": "en_US"
        ],
        [
            "key":"ko",
            "resource": "ko-KR",
            "server": "ko_KR"
        ],
        [
            "key":"vi",
            "resource": "vi",
            "server": "vi_VN"
        ],
        [
            "key":"ja",
            "resource": "ja",
            "server": "ja_JP"
        ]
    ]
    
    public static var shareInstance : SupportLanguageList {
        struct Static {
            static let instance: SupportLanguageList = SupportLanguageList()
        }
        Static.instance.supportLans = Static.instance.allLanguages()
        return Static.instance
    }

}


extension SupportLanguageList {
    
    //获取所有国家地区(默认过滤黑名单)
    func allLanguages() -> [LanguageItem] {
        var items:[LanguageItem] = []
        for item in SupportLanguageList.languageList{
            if let entity = LanguageItem.mj_object(withKeyValues: item) {
                items.append(entity)
            }
        }
        return items
    }
    
    func getLocalKeys(needFormat:Bool = false) ->[String] {
        if needFormat {
            return self.supportLans.map({return $0.server.replacingOccurrences(of: "_", with: "-")})
        }else {
            return self.supportLans.map({return $0.server})
        }
    }
    
    func getLanItem(lan:String) -> LanguageItem?{
        for item in self.supportLans {
            if lan == item.server || lan == item.server.replacingOccurrences(of: "_", with: "-"){
                return item
            }
        }
        return nil
    }
    
    
    
}
