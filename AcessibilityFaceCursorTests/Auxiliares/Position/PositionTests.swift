//
//  PositionTests.swift
//  AcessibilityFaceMouseTests
//
//  Created by Joao Batista on 11/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import XCTest
import UIKit
@testable import AcessibilityFaceMouse

class PositionTests: XCTestCase {

  // MARK: - Set Views test

  func testSetViewsPositionSucess() throws {
    let views = [UIView(frame: CGRect(x: 20, y: 20, width: 400, height: 400))]
    let testViews = [UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))]
    let position = Position(views: views)
    position.set(theViews: testViews)

    XCTAssertEqual(position.views, testViews, "As views tinham que ter sido atualizadas")
  }
}
