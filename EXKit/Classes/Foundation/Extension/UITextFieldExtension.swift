//
//  UITextField.swift
//  Chainup
//
//  Created by zewu wang on 2019/5/28.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

// MARK: -添加自定义清除按钮

public extension UITextField {
    
    ///给UITextField添加一个清除按钮
    func setModifyClearButton(kline:Bool = false) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage.themeImageNamedFromPod(imageName: "public_deleteall"), for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 35, height: 32)
        clearButton.contentMode = .scaleAspectFit
        clearButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 19, bottom: 0, right: 0)
        clearButton.addTarget(self, action: #selector(UITextField.clear(sender:)), for: .touchUpInside)
        let container = UIView(frame: clearButton.frame)
        container.backgroundColor = .clear
        container.addSubview(clearButton)
        
        self.rightView = container
        self.rightViewMode = .whileEditing
    }
    
    /// 点击清除按钮，清空内容
    @objc func clear(sender: AnyObject) {
        self.text = ""
        self.sendActions(for: .valueChanged)
    }
    
    //设置placeHolder的富文本
    func setPlaceHolderAtt(_ str : String , color : UIColor = UIColor.ThemeLabel.colorDark , font : CGFloat = 14){
        setPlaceHolderAtt(str, color: color, font: font, weight: .regular)
    }
    
    func setPlaceHolderAtt(_ str : String , color : UIColor = UIColor.ThemeLabel.colorDark , font : CGFloat = 14, weight: UIFont.Weight){
        let placeHolderAtt = NSMutableAttributedString().add(string: str, attrDic: [NSAttributedString.Key.font :UIFont.ThemeFont.getFont(size: font, aweight: weight), NSAttributedString.Key.foregroundColor : color])
        self.attributedPlaceholder = placeHolderAtt
    }
    
}
