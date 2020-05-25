//
//  NNExcelView.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2020/5/22.
//  Copyright © 2020 BN. All rights reserved.
//

import UIKit
import SnapKit

@objc public protocol NNExcelViewDelegate: NSObjectProtocol{
    @objc func excelView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath);

}

///表视图
@objcMembers public class NNExcelView: UIView{
    
    public weak var delegate: NNExcelViewDelegate?

    public lazy var layout: UICollectionLayoutExcel = {
        let layout = UICollectionLayoutExcel()
        let itemW = (self.bounds.width - 5*5.0)/4.0
        layout.itemSize = CGSize(width: itemW, height: 45)
        return layout
    }()
    
    public lazy var collectionView: UICollectionView = {
//        guard let collectionView = self.subView(UICollectionView.self) as? UICollectionView else {
            // 初始化
            let layout = UICollectionViewFlowLayout()
            let itemW = (self.bounds.width - 5*5.0)/4.0
            layout.itemSize = CGSize(width: itemW, height: itemW)
            layout.minimumLineSpacing = 5
            layout.minimumInteritemSpacing = 5
            //        layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            // 设置分区头视图和尾视图宽高
    //        layout.headerReferenceSize = CGSize(width: kScreenWidth, height: 60)
    //        layout.footerReferenceSize = CGSize(width: kScreenWidth, height: 60)

            let collectionView = UICollectionView(frame: CGRect(x:0, y:64, width:self.bounds.width, height:400), collectionViewLayout: layout)
            collectionView.backgroundColor = .white
            collectionView.showsVerticalScrollIndicator = true
            collectionView.showsHorizontalScrollIndicator = true
            collectionView.delegate = self
            collectionView.dataSource = self

            // 注册cell
            collectionView.register(UICollectionCellExcel.self, forCellWithReuseIdentifier: "UICTViewCellExcel")
            // 注册headerView
            collectionView.register(UICollectionCellExcel.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionCellExcel"+"Header")
            // 注册footView
            collectionView.register(UICollectionCellExcel.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier:  "UICollectionCellExcel"+"Footer")
            return collectionView
            
//        }
//        return collectionView
    }()
    
//    var headerView: UIView?
//    var footerView: UIView?
    
    public lazy var label: UILabel = {
        let view = UILabel(frame: .zero);
        view.text = "👈左滑查看更多信息"
        view.textColor = .gray;
        view.textAlignment = .left;
        view.font = UIFont.systemFont(ofSize: 13)
        return view;
    }()
    
    public lazy var labelBottom: UILabel = {
        let view = UILabel(frame: .zero);
        view.text = "👈左滑查看更多信息"
        view.textColor = .gray;
        view.textAlignment = .left;
        view.font = UIFont.systemFont(ofSize: 13)
        return view;
    }()
    
    public var itemSize = CGSize(width: 80, height: 45){
        willSet{
            layout.itemSize = newValue
        }
    }
    public var xGap: CGFloat = 15;
    
    public var titleList: [String] = [];
    public var dataList: [[String]] = [];
    public var widthList: [CGFloat] = [];
    public var lockColumn: Int = 1;
    
//    var lockOffsetX: CGFloat = 0;
    
    var indexP: IndexPath = IndexPath(row: 0, section: 0)
    
    lazy var testList: [[String]] = {
        let list = [
        ["名称","总数","剩余","IP","状态","状态1","状态2","状态3","状态4"],
        ["ces1","0","0","3.4.5.6","027641081087","1","0","3.4.5.6","027641081087"],
        ["ces2","0","0","3.4.5.6","027641081087","2","0","3.4.5.6","027641081087"],
        ["ces3","0","0","3.4.5.6","027641081087","3","0","3.4.5.6","027641081087"],
        ["ces4","0","0","3.4.5.6","027641081087","4","0","3.4.5.6","027641081087"],
        ["ces5","0","0","3.4.5.6","027641081087","5","0","3.4.5.6","027641081087"],
        ["ces6","","0","3.4.5.6","027641081087","6","0","3.4.5.6","027641081087"],
        ["ces7","0","0","3.4.5.6","027641081087","7","0","3.4.5.6","027641081087"],
        ["ces8","0","0","3.4.5.6","027641081087","8","0","3.4.5.6","027641081087"],
        ["ces9","0","0","3.4.5.6","027641081087","9","0","3.4.5.6","027641081087"],
        ];
        return list
    }()

    // MARK: -lifecycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        addSubview(labelBottom)
        addSubview(collectionView)
        
        collectionView.collectionViewLayout = layout
        
        dataList.append(contentsOf: testList)
        labelBottom.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if bounds.height <= 0.0 {
            return;
        }
        let labHeight: CGFloat = label.isHidden ? 0.0 : 30
        label.frame = CGRect(x: xGap, y: 0, width: bounds.width - xGap*2, height: labHeight)
        collectionView.frame = CGRect(x: 0, y: label.frame.maxY, width: bounds.width, height: bounds.height - labHeight)
    }
    
    public func reloadData() {
        if dataList.count <= 0 {
            label.text = "暂无数据,请稍后重试";
            return
        }
        for e in dataList.enumerated() {
            if widthList.count == 0 {
                return
            }
            assert(e.element.count == widthList.count, "第\(e.offset)行item宽度数组个数和数组元素个数不相同")
        }
        
        if widthList.count == 0 {
            let count = max(titleList.count, dataList.first!.count)
            widthList = [CGFloat](repeating: itemSize.width, count: count)
        }
        
        layout.lockColumn = lockColumn;
        
        layout.itemAttributes.removeAll()
        layout.columnWidths.removeAll()
        layout.columnWidths.append(contentsOf: widthList)
        
//        let arrsub = layout.columnWidths.subarray(0, layout.lockColumn)
//        lockOffsetX = arrsub.reduce(0) { $0 + $1 }
        
        if titleList.count > 0 && dataList.contains(titleList) == false {
            dataList.insert(titleList, at: 0)
        }
//        print("\(#function)_\(layout.columnWidths)_\(layout.columnCount)_\(widthList.count)_\(lockOffsetX)")
        collectionView.reloadData()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("\(#function)_\(lockOffsetX)_\(scrollView.contentOffset.y)")
        // 禁止下拉
        if (scrollView.contentOffset.y <= 0) {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
        }
        ///禁止右滑
        if (scrollView.contentOffset.x < 0) {
            scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
        }

//        // 禁止上拉
//        if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height) {
//            scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.size.height
//        }
    }
}

extension NNExcelView: UICollectionViewDataSource, UICollectionViewDelegate{

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count: Int = dataList.count
        return count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count: Int = dataList[section].count
        return count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICTViewCellExcel", for: indexPath) as? UICollectionCellExcel else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        }
        cell.indexP = indexPath
        let title: String = dataList[indexPath.section][indexPath.row]
        cell.label.text = String(format:"%ditem",indexPath.row)
        cell.label.text = title

//        cell.getViewLayer()
        return cell
   }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.excelView(collectionView, didSelectItemAt: indexPath)
        guard let newCell = collectionView.cellForItem(at: indexPath) as? UICollectionCellExcel,
        let oldCell = collectionView.cellForItem(at: indexP) as? UICollectionCellExcel
        else { return }
        
        if indexP != indexPath  {
            newCell.label.textColor = .systemBlue

            oldCell.label.textColor = .gray
            indexP = indexPath
        }

    }

}
