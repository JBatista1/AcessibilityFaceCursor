//
//  UITableViewExtension.swift
//  AcessibilityFaceMovimentBR
//
//  Created by Joao Batista on 25/02/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import UIKit

public extension UITableView {
  
  func getCell() -> [UITableViewCell] {
    var cells = [UITableViewCell]()

    if self.numberOfSections == 0 || (self.numberOfSections == 1 && self.numberOfRows(inSection: 0) == 0) || self.numberOfRows(inSection: 0) == 0 {
      return []
    }

    for section in 0...(self.numberOfSections-1) {
      for row in 0...(self.numberOfRows(inSection: section)-1) {
        if let cell = self.cellForRow(at: IndexPath(row: row, section: section)) {
          cells.append(cell)
          cell.accessibilityElements = [IndexPath(row: row, section: section)]
        }
      }
    }
    return cells
  }

  func nextCell(withScrollPosition scrollPosition: ScrollPosition = .none) {
    guard var actualIndexPath = self.indexPathsForVisibleRows?.last else { return
    }
    if actualIndexPath.row + 1 <= self.numberOfRows(inSection: actualIndexPath.section) - 1 {
      actualIndexPath.row += 1
    }else if actualIndexPath.section + 1 <= self.numberOfSections - 1 {
      actualIndexPath.section += 1
      actualIndexPath.row = 0
    }
    self.scrollToRow(at: actualIndexPath, at: scrollPosition, animated: true)
  }

  func backCell(withScrollPosition scrollPosition: ScrollPosition = .none) {
    guard var actualIndexPath = self.indexPathsForVisibleRows?.first else {return}
    if actualIndexPath.row - 1 >= 0 {
      actualIndexPath.row -= 1
    }else if actualIndexPath.section - 1 >= 0 {
      actualIndexPath.section -= 1
      actualIndexPath.row = self.numberOfRows(inSection: actualIndexPath.section) - 1
    }
    self.scrollToRow(at: actualIndexPath, at: scrollPosition, animated: true)
  }
}
