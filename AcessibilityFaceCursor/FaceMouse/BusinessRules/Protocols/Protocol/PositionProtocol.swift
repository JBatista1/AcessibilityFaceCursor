//
//  PositionProtocol.swift
//  AcessibilityFaceMouse
//
//  Created by Joao Batista on 07/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import UIKit

protocol PositionProtocol: AnyObject {
  func getViewSelectedBased(thePoint point: CGPoint) -> Int?
  func getViewSelectedBased(thePoint point: CGPoint, InTableViewCells tableViewCells: [UIView]) -> Int?
  func getViewSelectedBased(thePoint point: CGPoint, InCollectionViewCells collectionViewCells: [UIView]) -> Int?
  func verify(withPoint point: CGPoint, insideInFrame frame: CGRect) -> Bool
  func set(theViews views: [UIView])
}
