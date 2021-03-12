//
//  UIVIew+Position.swift
//  Commons
//
//  Created by Joao Batista on 20/10/20.
//  Copyright © 2020 Joao Batista. All rights reserved.
//

import UIKit

extension UIView {

  func absoluteValueToFrame() -> CGRect {
    if let baseWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
      return returnAbsoluteValue(basedInWindows: baseWindow)
    }
    return CGRect(x: 0, y: 0, width: 0, height: 0)
  }

  func returnAbsoluteValue(basedInWindows windows: UIWindow) -> CGRect {
    guard let absoluteframe = self.superview?.convert(self.frame, to: windows) else {
      return CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    return absoluteframe
  }

  func getViewAcessibility(WithType type: AccessibilityUIType) -> UIView? {
    for view in self.subviews where view.accessibilityIdentifier == type.identifier {
      return view
    }
    return nil
  }
}
