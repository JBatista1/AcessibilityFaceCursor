//
//  CGFloatExtension.swift
//  AcessibilityFaceMouseTests
//
//  Created by Joao Batista on 11/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import XCTest
import UIKit
@testable import AcessibilityFaceMouse

class CGFloatExtensionTest: XCTestCase {

  // MARK: - Succes truncate Value -

  func testTruncateSucessDefault() throws {
    let valueTest: CGFloat = 0.99837463524
    XCTAssertEqual(valueTest.truncate(), 0.9983)
  }

  func testTruncateSucessWithTruncateMaxValue() throws {
    let valueTest: CGFloat = 0.99837463524232123
    XCTAssertEqual(valueTest.truncate(withDecimalplaces: 18), 0.99837463524232123)
  }

  func testTruncateSucessWithTruncateMinValue() throws {
    let valueTest: CGFloat = 0.99837463524
    XCTAssertEqual(valueTest.truncate(withDecimalplaces: 1), 0.9)
  }

  // MARK: - Error truncate Value -

  func testTruncateErrorNegativeValue() throws {
    let valueTest: CGFloat = 0.99837463524
    XCTAssertEqual(valueTest.truncate(withDecimalplaces: -1), 0.99837463524)
  }
  
  func testTruncateErrorOverValueW() throws {
    let valueTest: CGFloat = 0.99837463524232123
    XCTAssertEqual(valueTest.truncate(withDecimalplaces: 50), 0.99837463524232123)
  }

}
