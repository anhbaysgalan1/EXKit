//
//  EXEmptyDataSetable.swift
//  Chainup
//
//  Created by liuxuan on 2019/4/12.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

public protocol EXEmptyDataSetable {
    
}

public enum EXEmptyDataSetAttributeKeyType {
    /// 纵向偏移(-50)  CGFloat
    case verticalOffset
    /// 提示语(暂无数据)  String
    case tipStr
    /// 提示语的font(system15)  UIFont
    case tipFont
    /// 提示语颜色(D2D2D2)  UIColor
    case tipColor
    /// 提示图(LXFEmptyDataPic) UIImage
    case tipImage
    /// 允许滚动(true) Bool
    case allowScroll
}

public extension UIScrollView {
    
    private struct AssociatedKeys {
        static var exemptyAttributeDict:[EXEmptyDataSetAttributeKeyType : Any]?
    }
    /// 属性字典
    var exemptyAttributeDict: [EXEmptyDataSetAttributeKeyType : Any]? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.exemptyAttributeDict) as? [EXEmptyDataSetAttributeKeyType : Any]
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.exemptyAttributeDict, newValue as [EXEmptyDataSetAttributeKeyType : Any]?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension EXEmptyDataSetable where Self : UIViewController {
    
    func exEmptyDataSet(_ scrollView: UIScrollView, attributeBlock: (()->([EXEmptyDataSetAttributeKeyType : Any]))? = nil) {
        scrollView.exemptyAttributeDict = attributeBlock != nil ? attributeBlock!() : nil
        scrollView.emptyDataSetDelegate = self
        scrollView.emptyDataSetSource = self
    }
    
}

public extension UIView {
    private struct AssociatedKey {
        static var fromKline: String = "fromKline"
    }
    
    var fromKline: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.fromKline) as? Bool ?? false
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKey.fromKline, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}

extension NSObject : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    public func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        // 返回提示图片
        guard let tipImg = scrollView.exemptyAttributeDict?[.tipImage] as? UIImage else {
            return UIImage.themeImageNamedFromPod(imageName: "norecords",kline: scrollView.fromKline)
        }
        return tipImg
    }
    
    public func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        var text = EXUIDatasource.shared.common_tip_nodata
        if let tipStr = scrollView.exemptyAttributeDict?[.tipStr] as? String {
            text = tipStr
        }

        let attributeText = NSMutableAttributedString.init(string: text)
        let count = text.count
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center      //文本对齐方向
        var font = UIFont.ThemeFont.SecondaryRegular
    
        if let tipFont = scrollView.exemptyAttributeDict?[.tipFont] as? UIFont {
            font = tipFont
        }
        
        attributeText.addAttributes([kCTFontAttributeName as NSAttributedString.Key: font], range: NSMakeRange(0, count))
        
        var color = scrollView.fromKline ? UIColor.ThemekLine.labcolorDark : UIColor.ThemeLabel.colorDark
        if let tipColor = scrollView.exemptyAttributeDict?[.tipColor] as? UIColor {
            color = tipColor
        }
        attributeText.addAttributes([NSAttributedString.Key.foregroundColor as NSAttributedString.Key:color], range: NSMakeRange(0, count))
        return attributeText
    }
    
    open func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        
        guard let offset = scrollView.exemptyAttributeDict?[.verticalOffset] as? CGFloat else {
            return 0
        }
        return offset
    }
    
    open func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        guard let scrollable = scrollView.exemptyAttributeDict?[.allowScroll] as? Bool else {
            return true
        }
        return scrollable
    }
}
