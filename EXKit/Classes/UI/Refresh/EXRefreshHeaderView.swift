//
//  EXRefreshHeaderView.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/27.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import MJRefresh

public class EXRefreshHeaderView: MJRefreshHeader {
    
    var container:UIView = UIView()
    var titleLabel:UILabel = UILabel()
    var logo:UIImageView = UIImageView()

    public override var state: MJRefreshState {
        didSet {
            if state == MJRefreshState.idle {
                self.titleLabel.text = EXUIDatasource.shared.refresh_down_Title
                self.stopAnimating()
            }else if state == MJRefreshState.pulling {
                self.titleLabel.text = EXUIDatasource.shared.refresh_trigger
            }else if state == MJRefreshState.refreshing {
                self.titleLabel.text =  EXUIDatasource.shared.refresh_refreshing
                self.startAnimating()
            }
        }
    }
    

    public override func prepare() {
        super.prepare()
        self.mj_h = 64
        self.addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(logo)
        logo.image = EXUIDatasource.shared.refresh_image
        titleLabel.textColor = UIColor.ThemeLabel.colorMedium
        titleLabel.bodyRegular()
    }
    
    func startAnimating(){
        logo.layer.add(self.animation(), forKey: "rotate")
    }
    
    func stopAnimating() {
        logo.layer.removeAnimation(forKey: "rotate")
    }
    
    func animation() -> CABasicAnimation{
        let animation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.toValue = Double.pi * 2.0
        animation.duration = 0.5
        animation.repeatCount = Float.greatestFiniteMagnitude
        return animation
    }
    
    public override func placeSubviews() {
        super.placeSubviews()
        container.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        logo.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.right.equalTo(titleLabel.snp.left).offset(-5)
            make.height.width.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(logo.snp.right).offset(5)
            make.right.equalToSuperview()
            make.centerY.equalTo(logo)
        }
    }
    
    public override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentOffsetDidChange(change)
    }
    
    public override func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentSizeDidChange(change)
    }
    
    public override func scrollViewPanStateDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewPanStateDidChange(change)
    }
    

}
