//
//  ViewAction.swift
//  AcessibilityFaceMovimentBR
//
//  Created by Joao Batista on 07/02/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import UIKit

public struct ViewAction: Equatable {
  let view: UIView
  let selector: Selector

  public init(view: UIView, selector: Selector) {
    self.view = view
    self.selector = selector
  }
}

