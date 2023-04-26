//
//  EXCommonAlert.swift
//  EXKit
//
//  Created by cwd on 2022/7/7.
//

import UIKit
public enum BottomBtnLayoutStyle {
    case horizontal
    case vertical
}
public enum BtnStyle {
    case cancel //取消
    case sure //确认
    case other
    //按钮背景色
    var bgColor: UIColor{
        switch self {
        case .cancel:
          return UIColor.ThemeView.card2
        case .sure:
          return UIColor.ThemeView.highlight
        default:
          return UIColor.ThemeView.card2
        }
    }
    //按钮背景色
    var bgHighLightColor: UIColor{
        switch self {
        case .cancel:
          return UIColor.ThemeView.card2
        case .sure:
          return UIColor.ThemeView.highlight
        default:
            return UIColor.ThemeView.card2
        }
    }
    //按钮背景色
    var disenbleColor: UIColor{
        return UIColor.ThemeBtn.disable
    }
    //文字颜色
    var titleColor: UIColor{
        switch self {
        case .cancel:
            return UIColor.ThemeLabel.colorLite
        case .sure:
            return UIColor.ThemeLabel.white
        default:
            return UIColor.ThemeLabel.colorLite
        }
    }
    //文字颜色
    var titleFont: UIFont{
        return UIFont.ThemeFont.BodyMedium
//        switch self {
//        case .cancel:
//            return UIFont.ThemeFont.BodyRegular
//        case .sure:
//            return UIColor.ThemeLabel.white
//        default:
//            return UIColor.ThemeLabel.colorLite
//        }
    }
}
public enum BottomBtnType: Int {
    case cancel = 0
    case sure
}

public typealias AlertCallback = (BottomBtnType) -> ()

public class EXCommonAlert: EXBaseView {
    private let margin: CGFloat = 40
    public var alertCallBack: AlertCallback?
    
    //MARK: UI
    public override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: .allCorners, radius: 12)
    }
    
    //MARK: lazy
    lazy var container: UIStackView = {
        let v = UIStackView()
        v.distribution = .fill
        v.axis = .vertical
        v.alignment = .fill
        v.backgroundColor = UIColor.ThemeView.alertBg
        return v
    }()
    //头部icon
    lazy var headImageView: UIView = {
        let v = UIView()
        return v
    }()
    
    lazy var iconImg : UIImageView = {
        let arrowImmg = UIImageView()
        arrowImmg.contentMode = .scaleAspectFit
//        arrowImmg.image = UIImage(named: "")
//        arrowImmg.backgroundColor = .red
        return arrowImmg
    }()
    //标题
    lazy var titleView: UIView = {
        let v = UIView()
        return v
    }()
    //文案显示
    lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        v.numberOfLines = 0
        v.font = UIFont.ThemeFont.HeadBold
        v.textColor = UIColor.ThemeLabel.colorLite
        return v
    }()
    //子标题
    lazy var contentView: UIView = {
        let v = UIView()
        return v
    }()
    //文案显示
    public lazy var contentLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        v.numberOfLines = 0
        v.font = UIFont.ThemeFont.BodyRegular
        v.textColor = UIColor.ThemeLabel.colorMedium
        return v
    }()
    //底部按钮
    lazy var bottomBtnView: UIView = {
        let v = UIView()
        return v
    }()
    //取消
    lazy var btn1 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(onClickAction(sender:)), for: UIControl.Event.touchUpInside)
        btn.tag = 0
        btn.extSetCornerRadius(4)
        return btn
    }()
    //确认
    lazy var btn2 : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.ThemeView.highlight, for: .normal)
        btn.addTarget(self, action: #selector(onClickAction(sender:)), for: UIControl.Event.touchUpInside)
        btn.tag = 1
        btn.extSetCornerRadius(4)
        return btn
    }()

    public override func setSubView() {
        self.backgroundColor = UIColor.ThemeView.alertBg
        container.backgroundColor = UIColor.ThemeView.alertBg
        self.addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.lessThanOrEqualToSuperview()
            make.center.equalToSuperview()
        }
        
        container.addArrangedSubviews([headImageView,titleView,contentView,bottomBtnView])
        
        headImageView.addSubview(iconImg)
        iconImg.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.width.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
        }
       
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
        
        bottomBtnView.addSubViews([btn1,btn2])
        btn2.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        }
        btn1.snp.makeConstraints { make in
            make.top.equalTo(btn2.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        }
        
        
        bottomBtnView.snp.makeConstraints { make in
            make.height.equalTo(20 + 44 * 2 + 12 + 16)
        }
        
    }
   
    
    
   
    
    //MARK: action
    @objc func onClickAction(sender: UIButton){
        self.alertCallBack?(BottomBtnType(rawValue: sender.tag)!)
        EXKitAlert.dismiss()
    }
    
    /**
     
     tipImage 弹框顶部的提示图
     title ：  标题
     message： 内容
     btnLayoutStyle： 底部2个按钮 的布局方式
     bottomOnlyOneBtn: 底部一个按钮默认传 onlyOneBtnTitle
     
     */
    
    public func configAlert(tipImage: UIImage? = nil,
                            title:String,
                            message:String? = nil,
                            msgUseAttri: Bool? = true,
                            cancelBtnTitle:String? = EXUIDatasource.shared.cancelTitle,
                            sureBtnTitle: String? = EXUIDatasource.shared.confirmTitle,
                            onlyOneBtnTitle: String? = EXUIDatasource.shared.alertOnlyBtnTitle,
                            cancelBtnStyle:BtnStyle? = BtnStyle.cancel,
                            sureBtnStyle:BtnStyle? = BtnStyle.sure,
                            btnLayoutStyle:BottomBtnLayoutStyle = .horizontal,
                            bottomOnlyOneBtn: Bool? = false,
                            alertCallBack: @escaping AlertCallback
    ){
        self.alertCallBack = alertCallBack
        if let tipImage = tipImage {
            headImageView.isHidden = false
            iconImg.image = tipImage
        }else{
            headImageView.isHidden = true
            titleLabel.snp.updateConstraints({ make in
                make.top.equalToSuperview().offset(32)
            })
        }
        titleLabel.text = title
        if let message = message {
            contentView.isHidden = false
            if let msgUseAttri = msgUseAttri,msgUseAttri == true {
                contentLabel.attributedText = message.lineSpacingString(font: UIFont.systemFont(ofSize: 14), color:UIColor.ThemeLabel.colorMedium, lineSpacing: 12, textAligment: .left)
            }else{
                contentLabel.text = message
                contentLabel.textAlignment = .center
            }
            
        }else{
            contentView.isHidden = true
        }
        if let cancelBtnStyle = cancelBtnStyle {
            btn1.setBackgroundColor(color: cancelBtnStyle.bgColor, forState: .normal)
            btn1.setBackgroundColor(color: cancelBtnStyle.bgHighLightColor, forState: .highlighted)
            btn1.setBackgroundColor(color: cancelBtnStyle.bgColor, forState: .selected)
            btn1.setTitleColor(cancelBtnStyle.titleColor, for: .normal)
            btn1.titleLabel?.font = cancelBtnStyle.titleFont
        }
        if let cancelBtnTitle = cancelBtnTitle {
            btn1.setTitle(cancelBtnTitle, for: .normal)
        }
       
        if let sureBtnStyle = sureBtnStyle {
            btn2.setBackgroundColor(color: sureBtnStyle.bgColor, forState: .normal)
            btn2.setBackgroundColor(color: sureBtnStyle.bgHighLightColor, forState: .highlighted)
            btn2.setBackgroundColor(color: sureBtnStyle.bgColor, forState: .selected)
            btn2.setTitleColor(sureBtnStyle.titleColor, for: .normal)
            btn2.titleLabel?.font = sureBtnStyle.titleFont
        }
       
        if let sureBtnTitle = sureBtnTitle {
            btn2.setTitle(sureBtnTitle, for: .normal)
        }
        if let bottomOnlyOneBtn = bottomOnlyOneBtn,bottomOnlyOneBtn == true {
            btn1.isHidden = true
            btn2.setTitle(onlyOneBtnTitle, for: .normal)
            bottomBtnView.snp.updateConstraints { make in
                make.height.equalTo(20 + 44 + 20)
            }
            return //不调整horizontal 按钮布局了
        }
        if btnLayoutStyle == .horizontal{ //默认是垂直的 ,这里处理水平布局
            var top = 20
            if message == nil{ //如果没有内容，顶部间距需大一些32
                top += 12
            }
            let btnw = (Device_W - margin * 2/*父视图左右边距*/ - 20 * 2 - 16) * 0.5
            btn1.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.height.equalTo(44)
                make.width.equalTo(btnw)
                make.top.equalToSuperview().offset(top)
            }
            btn2.snp.remakeConstraints { make in
                make.left.equalTo(btn1.snp.right).offset(16)
                make.height.equalTo(44)
                make.width.equalTo(btnw)
                make.right.equalToSuperview().offset(-20)
                make.top.equalToSuperview().offset(top)
            }
            
            bottomBtnView.snp.remakeConstraints { make in
                make.height.equalTo(top + 44 + 20)
            }
        }
        
        
    }
    
}






