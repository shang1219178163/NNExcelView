//
//  UICollectionLayoutExcel.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2020/5/22.
//  Copyright © 2020 BN. All rights reserved.
//

import UIKit


@objcMembers public class UICollectionLayoutExcel: UICollectionViewFlowLayout {

    var lockColumn: Int = 1
    
    private var itemAttributes: [[UICollectionViewLayoutAttributes]] = []
    private var contentSize: CGSize = .zero

    // MARK: -lifecycle
    public override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView,
            collectionView.numberOfSections > 0
        else { return }
        
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
                    
                    lockSomeLayoutAtt(atttibute!, indexPath: indexPath)
                }
            }
            return
        }
        
        itemAttributes.removeAll()
        for section in 0..<numberOfSections {
            var sectionAttributes: [UICollectionViewLayoutAttributes] = []

            let numberOfItems = collectionView.numberOfItems(inSection: section)
            for row in 0..<numberOfItems {
                
                let indexPath = IndexPath(item: row, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: itemSize.width*CGFloat(row),
                                          y: itemSize.height*CGFloat(section),
                                          width: itemSize.width,
                                          height: itemSize.height).integral
                                
                lockSomeLayoutAtt(attributes, indexPath: indexPath)
                sectionAttributes.append(attributes)
            }
            itemAttributes.append(sectionAttributes)
        }
  
        guard let attributes = itemAttributes.last?.last else { return }
        contentSize = CGSize(width: attributes.frame.maxX, height: attributes.frame.maxY)
    }
    
    ///锁定第一行和第一列
    private func lockSomeLayoutAtt(_ attributes: UICollectionViewLayoutAttributes, indexPath: IndexPath) {
        guard let collectionView = collectionView else { return }
        ///锁定的悬浮
        if indexPath.section == 0 && indexPath.row < lockColumn {
            attributes.zIndex = 1024
        } else if indexPath.section == 0 || indexPath.row < lockColumn {
            attributes.zIndex = 1023
        }
        
        var frame = attributes.frame
        if indexPath.section == 0 {
            frame.origin.y = collectionView.contentOffset.y;
        }

        if indexPath.row < lockColumn {
            let offsetX: CGFloat = itemSize.width*CGFloat(indexPath.row)
            frame.origin.x = collectionView.contentOffset.x + offsetX;
        }
        attributes.frame = frame;
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

