//
//  EXKitDataSource.swift
//  DZNEmptyDataSet
//
//  Created by liuxuan on 2022/7/7.
//

import UIKit

public class EXKitDataSource: NSObject {
    
    var fontMediumPath:String?
    var fontBoldPath:String?
    var fontRegularPath:String?    
    
    public static var shareInstance : EXKitDataSource {
        struct Static {
            static let instance: EXKitDataSource = EXKitDataSource()
        }
        return Static.instance
    }
    
    private func getPodFrameWorkBundle() -> Bundle? {
        let podframework = Bundle.main.resourcePath! + "/Frameworks/EXKit.framework/"
        return Bundle(path: podframework)
    }
    
    public func handleDataSources() {
        if let bundle = getPodFrameWorkBundle() {
            self.fontBoldPath = bundle.path(forResource: "DINPro-Bold.otf", ofType:nil,inDirectory: "EXKit.bundle")
            self.fontMediumPath = bundle.path(forResource: "DINPro-Medium.otf", ofType:nil,inDirectory: "EXKit.bundle")
            self.fontRegularPath = bundle.path(forResource: "DINPro-Regular.otf", ofType:nil,inDirectory: "EXKit.bundle")
        }
    }
    
}
