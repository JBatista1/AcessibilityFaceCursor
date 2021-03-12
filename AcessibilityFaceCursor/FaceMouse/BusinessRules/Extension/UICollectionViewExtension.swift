//
//  UICollectionViewExtension.swift
//  AcessibilityFaceMovimentBR
//
//  Created by Joao Batista on 26/02/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import UIKit

public extension UICollectionView {

  func getCell() -> [UICollectionViewCell] {
    var cells = [UICollectionViewCell]()

    if self.numberOfSections == 0 || (self.numberOfSections == 1 && self.numberOfItems(inSection: 0) == 0) || self.numberOfItems(inSection: 0) == 0 {
      return []
    }

    for section in 0...(self.numberOfSections-1) {
      for item in 0...(self.numberOfItems(inSection: section)-1) {
        if let cell = self.cellForItem(at: IndexPath(item: item, section: section)) {
          cells.append(cell)
          cell.accessibilityElements = [IndexPath(item: item, section: section)]
        }
      }
    }
    return cells
  }
  
  func nextCell(withScrollPosition scrollPosition: ScrollPosition = .bottom) {
    guard var indexPath = self.indexPathsForVisibleItems.sorted().last else {return}
    if indexPath.item + 1 <= self.numberOfItems(inSection: indexPath.section) - 1 {
      indexPath.item += 1
    }else if indexPath.section + 1 <= self.numberOfSections - 1 {
      indexPath.section += 1
      indexPath.item = 0
    }
    self.scrollToItem(at: indexPath, at: scrollPosition, animated: true)
  }

  func backCell(withScrollPosition scrollPosition: ScrollPosition = .top) {
    guard var indexPath = self.indexPathsForVisibleItems.first else {return}
    if indexPath.item - 1 >= 0 {
      indexPath.item -= 1
    }else if indexPath.section - 2 >= 0 {
      indexPath.section -= 1
      indexPath.item = self.numberOfItems(inSection: indexPath.section) - 1
    }
    self.scrollToItem(at: indexPath, at: scrollPosition, animated: true)
    self.reloadInputViews()
  }
}
