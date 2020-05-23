//
//  UICollectionLayoutExcel.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2020/5/22.
//  Copyright © 2020 BN. All rights reserved.
//

import UIKit


@objcMembers public class UICollectionLayoutExcel: UICollectionViewFlowLayout {

    var columnWidths: [CGFloat] = []
    var lockColumn: Int = 1
    
    var itemAttributes: [[UICollectionViewLayoutAttributes]] = []
    var contentSize: CGSize = .zero

    // MARK: -lifecycle
    public override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView,
            collectionView.numberOfSections > 0
        else { return }
 
        var xOffset: CGFloat = 0.0;//X方向的偏移量
        var yOffset: CGFloat = 0.0;//Y方向的偏移量
        var contentWidth: CGFloat = 0.0;//collectionView.contentSize的宽度
        var contentHeight: CGFloat = 0.0;//collectionView.contentSize的高度
        
        let numberOfSections = collectionView.numberOfSections

        if itemAttributes.count > 0 {
            for section in 0..<numberOfSections {
                let numberOfItems = collectionView.numberOfItems(inSection: section)
                for row in 0..<numberOfItems {
                    if section != 0 && row >= lockColumn {
                        continue
                    }
                    
                    let indexPath = IndexPath(item: row, section: section)
                    let atttibute = layoutAttributesForItem(at: indexPath)
                    
                    layoutAtt(atttibute!, indexPath: indexPath)
                }
            }
            return
        }
        
        itemAttributes.removeAll()
        for section in 0..<numberOfSections {
            var sectionAttributes: [UICollectionViewLayoutAttributes] = []

            let numberOfItems = collectionView.numberOfItems(inSection: section)
            for row in 0..<numberOfItems {
                
                var itemWith = itemSize.width
                if columnWidths.count > row {
                    if let width = columnWidths[row] as CGFloat?{
                        itemWith = width > 0.0 ? width : itemSize.width
                    }
                }

                let itemsize = CGSize(width: itemWith, height: itemSize.height)
//                print("\(#function),\(row), \(itemsize)")

                let indexPath = IndexPath(item: row, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemsize.width, height: itemsize.height).integral
                if indexPath.section == 0 && indexPath.row < lockColumn {
                    attributes.zIndex = 1024
                } else if indexPath.section == 0 || indexPath.row < lockColumn {
                    attributes.zIndex = 1023
                }
                
                print("\(#function){\(section), \(row)}, \(attributes.frame), \(attributes.zIndex)")
//                if section != 0 && row >= lockColumn {
//                    continue
//                }
                
                layoutAtt(attributes, indexPath: indexPath)
                sectionAttributes.append(attributes)
                
                xOffset += itemSize.width
                if row == numberOfItems - 1 {
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }
//                    column = 0
                    xOffset = 0
                    yOffset += itemSize.height
                }
            }
            itemAttributes.append(sectionAttributes)
//            DDLog(itemAttributes.count, section, sectionAttributes.count)
        }
  
        guard let attributes = itemAttributes.last?.last else { return }
        contentHeight = attributes.frame.origin.y + attributes.frame.size.height
        contentSize = CGSize(width: contentWidth, height: contentHeight)
    }
    
    
    private func layoutAtt(_ layoutAtt: UICollectionViewLayoutAttributes, indexPath: IndexPath) {
        guard let collectionView = collectionView else { return }
        if indexPath.section == 0 {
            var frame = layoutAtt.frame
            frame.origin.y = collectionView.contentOffset.y;
            layoutAtt.frame = frame
        }
        
        if indexPath.row < lockColumn {
            var frame = layoutAtt.frame
            var offsetX: CGFloat = 0
        
            for row in 0..<indexPath.row {
                offsetX += columnWidths[row]
            }
            
            frame.origin.x = collectionView.contentOffset.x + offsetX;
            layoutAtt.frame = frame;
        }
    }
    
    
    public override var collectionViewContentSize: CGSize{
        return contentSize
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes[indexPath.section][indexPath.row]
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes: [UICollectionViewLayoutAttributes] = []
        
        for e in itemAttributes.enumerated() {
            let list = e.element.filter { rect.intersects($0.frame) == true }
            attributes.append(contentsOf: list)
        }
        return attributes
    }

    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}

