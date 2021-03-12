//
//  ViewControllerExtensionTest.swift
//  AcessibilityFaceMouseTests
//
//  Created by Joao Batista on 09/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import XCTest
import UIKit
@testable import AcessibilityFaceMouse

class ViewControllerExtensionTest: XCTestCase {

  var mockTabbarControllerDummy = MockTabBarController()
  var mockNavigationControllerDummy = MockNavigationController()

  override func setUpWithError() throws {

    //MARK: - Setup TabBar

    mockTabbarControllerDummy.beginAppearanceTransition(true, animated: false)
    mockTabbarControllerDummy.endAppearanceTransition()
    mockTabbarControllerDummy.viewWillAppear(true)

    // MARK: - Setup NavigationBar

    mockNavigationControllerDummy.beginAppearanceTransition(true, animated: false)
    mockNavigationControllerDummy.endAppearanceTransition()
    mockNavigationControllerDummy.viewWillAppear(true)
  }
  
  override func tearDownWithError() throws {
  }

  @objc func testSelector(){}

  // MARK: - Test TabBar -
  
  func testGetTabBarSucess() throws {
    XCTAssertNotNil(mockTabbarControllerDummy.initialTabBar.getTabBar(), "Deveria ter pegue a tabbar desta viewController")
  }
  
  func testGetTabBarError() throws {
    XCTAssertNil(mockTabbarControllerDummy.getTabBar(), "Deveria vir vazio pois não tem tabbar")
  }

  func testcreateViewsActionInTabBarSuccess() throws {
    XCTAssertEqual(mockTabbarControllerDummy.initialTabBar.createViewsActionInTabBar(withSelector: #selector(testSelector)).count, 1, "Deveria ter pegue a tabbar desta viewController")
  }

  func testcreateViewsActionInTabBarError() throws {
   XCTAssertEqual(mockTabbarControllerDummy.createViewsActionInTabBar(withSelector: #selector(testSelector)).count, 0, "Deveria ter pegue a tabbar desta viewController")
  }
  
 // MARK: - Test NavigationBar -

  func testGetNavigationBarSucess() throws {
    XCTAssertNotNil(mockNavigationControllerDummy.initialNavBar.getNavigationBar(), "Deveria ter pegue a NavigationBar desta viewController")
  }

  func testGetNavigationBarError() throws {
    XCTAssertNil(mockNavigationControllerDummy.getNavigationBar(), "Nao deveria ter uma navigationcontroller")
  }

  func testGetNavigationBackButtonError() throws {
    XCTAssertNil(mockNavigationControllerDummy.getNavigationBackButton(), "Deveria vir vazio essa viewController")
  }

  func testGgetViewActionNavigationAndTabBarSucessWithTab() throws {
    XCTAssertEqual(mockTabbarControllerDummy.initialTabBar.getViewActionNavigationAndTabBar(withSelectorTabBar: #selector(testSelector), andSelectorNavBar: #selector(testSelector)).count, 1, "Deveria vir Com a action da tabBar")
  }


  func testGgetViewActionNavigationAndTabBarErrorWithTab() throws {
    XCTAssertEqual(mockTabbarControllerDummy.getViewActionNavigationAndTabBar(withSelectorTabBar: #selector(testSelector), andSelectorNavBar: #selector(testSelector)).count, 0, "Deveria vir sem nenhum action ")
  }
}
