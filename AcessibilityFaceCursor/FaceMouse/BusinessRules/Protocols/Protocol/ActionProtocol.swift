//
//  ActionProtocol.swift
//  AcessibilityFaceMovimentBR
//
//  Created by Joao Batista on 07/02/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import UIKit

public protocol ActionProtocol: AnyObject {
  func verifyAction(withValueEyeRight eyeRight: CGFloat, theEyeLeft eyeLeft: CGFloat, andTongueValue tongue: CGFloat) -> Bool
  func getViewForAction(withPoint point: CGPoint)
  func setTypeStartAction(withType type: TypeStartAction)
  func set(viewsAction: [ViewAction])
  func getType() -> TypeStartAction
}
