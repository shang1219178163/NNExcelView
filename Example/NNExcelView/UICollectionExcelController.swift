//
//  UICollectionExcelController.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2020/5/22.
//  Copyright © 2020 BN. All rights reserved.
//

import UIKit
import NNExcelView

class UICollectionExcelController: UIViewController{
    
    lazy var excelView: NNExcelView = {
        let excelView = NNExcelView(frame: self.view.bounds)
//        excelView.titleLabel.isHidden = true
//        excelView.inset =  UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        excelView.lockColumn = 2
        excelView.showTestData = true
        excelView.delegate = self
        return excelView
    }()
    
    // MARK: -lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
        view.backgroundColor = .white
        title = "NNExcelView"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(handleActionItem(_:)))
       
        view.addSubview(excelView)
//        excelView.backgroundColor = .systemGreen

//        excelView.headerView = {
//           let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
//            view.backgroundColor = .systemRed
//            return view
//        }()
//
//        excelView.footerView = {
//           let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
//            view.backgroundColor = .systemOrange
//            return view
//        }()
        excelView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        excelView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0);
            make.left.equalToSuperview().offset(0);
            make.right.equalToSuperview().offset(0);
            make.height.equalTo(400)
        }
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func handleActionItem(_ item: UIBarButtonItem) {
        excelView.reloadData()
    }
}

extension UICollectionExcelController: NNExcelViewDelegate {
    func excelView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(#function)_{\(indexPath.section),\(indexPath.row)}")
    }
    
    
}
extension UIColor{
    /// [源]0x开头的16进制Int数字(无#前缀十六进制数表示，开头就是0x)
    static func hexValue(_ hex: Int, a: CGFloat = 1.0) -> UIColor {
        return UIColor(red: CGFloat((hex & 0xFF0000) >> 16)/255.0, green: CGFloat((hex & 0xFF00) >> 8)/255.0, blue: CGFloat(hex & 0xFF)/255.0, alpha: a)
    }
    
    /// 线条默认颜色(同cell分割线颜色)
    static var line: UIColor {
        return UIColor.hexValue(0xe4e4e4)
    }
    
    static var excelTitleBackgroudColor: UIColor {
        return UIColor.hexValue(0xF5F5F5)
    }
}
