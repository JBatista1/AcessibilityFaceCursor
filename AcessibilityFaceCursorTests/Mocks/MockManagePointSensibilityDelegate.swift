//
//  MockManagePointSensibilityDelegate.swift
//  AcessibilityFaceMouseTests
//
//  Created by Joao Batista on 09/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import UIKit
@testable import AcessibilityFaceMouse

class MockManagePointSensibilityDelegate: ManagerPointSesibilittyProtocol {
  var capturaStartGetValueSpy: Bool = false
  var captureFinishWithSpy: CGFloat = 0.0
  init() {}

  func capturaStartGetValue() {
    capturaStartGetValueSpy = true
  }

  func captureFinishWith(theValue value: CGFloat){
    captureFinishWithSpy = value
  }
}
