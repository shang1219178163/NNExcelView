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
    
    public var cellItemBlock:((UILabel, IndexPath)->Void)?
    public var block:((UICollectionView, IndexPath)->Void)?

    ///一行可见显示数目
    public var visibleNumOfRow: CGFloat = 3.0;
    ///一行可见高度
    public var itemSizeHeight: CGFloat = 45;
    
    private lazy var layout: UICollectionLayoutExcel = {
        let layout = UICollectionLayoutExcel()
        layout.itemSize = CGSize(width: self.bounds.width/self.visibleNumOfRow, height: self.itemSizeHeight)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
//        // 初始化
//        let layout = UICollectionViewFlowLayout()
//        let itemW = (self.bounds.width - 5*5.0)/4.0
//        layout.itemSize = CGSize(width: itemW, height: itemW)
//        layout.minimumLineSpacing = 5
//        layout.minimumInteritemSpacing = 5
// //        layout.scrollDirection = .vertical
//        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        // 设置分区头视图和尾视图宽高
//        layout.headerReferenceSize = CGSize(width: kScreenWidth, height: 60)
//        layout.footerReferenceSize = CGSize(width: kScreenWidth, height: 60)
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = true
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.delegate = self
        collectionView.dataSource = self
        // 注册cell
        collectionView.register(UICollectionCellExcel.self, forCellWithReuseIdentifier: "UICTViewCellExcel")
        return collectionView
    }()
    
    public var inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    public var headerView: UIView?{
        willSet{
            guard let newValue = newValue else { return }
            addSubview(newValue)
        }
    }
    public var footerView: UIView?{
        willSet{
            guard let newValue = newValue else { return }
            addSubview(newValue)
        }
    }
    
    private var indexP = IndexPath(row: 0, section: 0)

    private var titleLabelHeight: CGFloat = 30;

    public lazy var titleLabel: UILabel = {
        let view = UILabel(frame: .zero);
        view.text = "   👈左滑查看更多信息"
        view.textColor = .gray;
        view.textAlignment = .left;
        view.font = UIFont.systemFont(ofSize: 13)
        return view;
    }()

    public var titleList: [String] = [];
    public var dataList: [[String]] = [];
    public var lockColumn: Int = 1{
        willSet{
            layout.lockColumn = lockColumn
            collectionView.reloadData()
        }
    }
    ///显示选择效果
    public var canSelectItem: Bool = false
    
    public var showTestData: Bool = false{
        willSet{
            dataList.removeAll()
            dataList.append(contentsOf: testList)
            reloadData()
        }
    }
    
    public var headerBackgroudColor: UIColor = .excelHeaderBackgroudColor

    public lazy var testList: [[String]] = {
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
        
        addSubview(titleLabel)
        addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if bounds.height <= 10.0 {
            return;
        }
        
        var collectionViewTopOffset: CGFloat = 0
        var collectionViewBomOffset: CGFloat = 0

        if let headerView = headerView, headerView.isHidden == false {
            headerView.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(inset.top);
                make.left.equalToSuperview().offset(inset.left);
                make.right.equalToSuperview().offset(-inset.right);
                make.height.equalTo(headerView.bounds.height);
            }
            collectionViewTopOffset = headerView.bounds.height
        } else {
            if titleLabel.isHidden == false {
                titleLabel.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().offset(inset.top);
                    make.left.equalToSuperview().offset(inset.left);
                    make.right.equalToSuperview().offset(-inset.right);
                    make.height.equalTo(titleLabelHeight);
                }
                collectionViewTopOffset = titleLabelHeight
            }
        }
        
        if let footerView = footerView, footerView.isHidden == false {
            footerView.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(inset.left);
                make.right.equalToSuperview().offset(-inset.right);
                make.bottom.equalToSuperview().offset(-inset.bottom);
                make.height.equalTo(footerView.bounds.height);
            }
            collectionViewBomOffset = footerView.bounds.height
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(collectionViewTopOffset);
            make.left.equalToSuperview().offset(inset.left);
            make.right.equalToSuperview().offset(-inset.right);
            make.bottom.equalToSuperview().offset(-collectionViewBomOffset);
        }
        
        layout.itemSize = CGSize(width: (self.bounds.width - inset.left - inset.right)/self.visibleNumOfRow, height: self.itemSizeHeight)
        collectionView.reloadData()
    }
    // MARK: -funtions
    public func reloadData() {
        if dataList.count <= 0 {
            titleLabel.text = "暂无数据,请稍后重试";
            return
        }
  
        if titleList.count > 0 && dataList.contains(titleList) == false {
            dataList.insert(titleList, at: 0)
        }
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
        
        cell.lineLeft.isHidden = indexPath.row > 0
        cell.label.backgroundColor = indexPath.section == 0 ? headerBackgroudColor : .white
        
        cellItemBlock?(cell.label, indexPath)
//        cell.getViewLayer()
        return cell
   }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.excelView(collectionView, didSelectItemAt: indexPath)
        block?(collectionView, indexPath)
        
        if canSelectItem == false {
            return
        }
        
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
