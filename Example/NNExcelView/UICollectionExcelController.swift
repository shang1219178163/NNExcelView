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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "NNExcelView"
        view.backgroundColor = .white
       
        view.addSubview(excelView)
                
        excelView.frame = CGRect(x: 0, y: 70, width: self.view.bounds.width, height: 300)
        excelView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    lazy var excelView: NNExcelView = {
        let excelView = NNExcelView(frame: self.view.bounds)
//        excelView.lockColumn = 2
        excelView.delegate = self
        return excelView
    }()
}

extension UICollectionExcelController: NNExcelViewDelegate {
    func excelView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(#function)_{\(indexPath.section),\(indexPath.row)}")
    }
    
    
}
