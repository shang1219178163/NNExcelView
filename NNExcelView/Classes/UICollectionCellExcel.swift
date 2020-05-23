//
//  UICollectionCellExcel.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2020/5/22.
//  Copyright © 2020 BN. All rights reserved.
//

import UIKit
import SnapKit

@objcMembers public class UICollectionCellExcel: UICollectionViewCell {
    
    var indexP = IndexPath(row: 0, section: 0)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.addSubview(label)
        
        label.addSubview(lineTop)
        label.addSubview(lineBottom)
        label.addSubview(lineRight)

        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        
//        lineRight.backgroundColor = .red
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        lineTop.isHidden = (indexP.section != 0)
        
        label.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(0)
            make.right.bottom.equalToSuperview().offset(0)
        }
        
        lineTop.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        lineBottom.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
         
        lineRight.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-1)
            make.width.equalTo(0.5)
        }
 
    }
    
    // MARK: -lazy
    lazy var label: UILabel = {
        let label = UILabel(frame: .zero);
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 2;
        label.lineBreakMode = .byCharWrapping;
        label.textAlignment = .center;
        
        label.textColor = .gray;
        return label;
    }()
    
    
    lazy var lineTop: UIView = {
        let view = UIView(frame: .zero);
        view.backgroundColor = .line
        return view
    }()
    
    lazy var lineBottom: UIView = {
        let view = UIView(frame: .zero);
        view.backgroundColor = .line
        return view
    }()
    
    lazy var lineRight: UIView = {
        let view = UIView(frame: .zero);
        view.backgroundColor = .line
        return view
    }()
 
    
}

extension UIColor{
    /// [源]0x开头的16进制Int数字(无#前缀十六进制数表示，开头就是0x)
    static func hexValue(_ hex: Int, a: CGFloat = 1.0) -> UIColor {
        return UIColor(red: CGFloat((hex & 0xFF0000) >> 16)/255.0, green: CGFloat((hex & 0xFF00) >> 8)/255.0, blue: CGFloat(hex & 0xFF)/255.0, alpha: a)
    }
    
    /// 线条默认颜色(同cell分割线颜色)
    static var line: UIColor {
        return UIColor.hexValue(0xe4e4e4);
    }
}
