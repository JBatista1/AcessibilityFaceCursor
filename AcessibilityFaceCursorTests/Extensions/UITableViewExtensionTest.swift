//
//  UITableViewExtensionTest.swift
//  AcessibilityFaceMouseTests
//
//  Created by Joao Batista on 10/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import XCTest
import UIKit
@testable import AcessibilityFaceMouse

class UITableViewExtensionTest: XCTestCase {

  let viewControllerDummy = MockTestViewController()

  override func setUpWithError() throws {
    viewControllerDummy.beginAppearanceTransition(true, animated: false)
    viewControllerDummy.endAppearanceTransition()
    viewControllerDummy.viewDidLoad()
  }

  override func tearDownWithError() throws {
  }

  // MARK: - Get Cell  -

  func testGetCellSucess() throws {
    viewControllerDummy.numberRow = 5
    viewControllerDummy.mockUITableView.reloadData()
    XCTAssertEqual(viewControllerDummy.mockUITableView.getCell().count, 5, "Deveria vir 5 celulas")
  }

  func testGetCellErrorNotCell() throws {
    viewControllerDummy.numberRow = 0
    viewControllerDummy.mockUITableView.reloadData()
    XCTAssertEqual(viewControllerDummy.mockUITableView.getCell().count, 0, "Não deveria vir nenhuma célula")
  }

  func testGetCellErrorNotSection() throws {
    viewControllerDummy.numberSection = 0
    viewControllerDummy.mockUITableView.reloadData()
    XCTAssertEqual(viewControllerDummy.mockUITableView.getCell().count, 0, "Não deveria vir nenhuma célula")
  }

  func testGetCellErrorNotSectionNotRow() throws {
    viewControllerDummy.numberSection = 1
    viewControllerDummy.numberRow = 0
    viewControllerDummy.mockUITableView.reloadData()
    XCTAssertEqual(viewControllerDummy.mockUITableView.getCell().count, 0, "Não deveria vir nenhuma célula")
  }

  // MARK: - Next Cell  -

  func testNextCellSuccessNextRow() throws {
    viewControllerDummy.numberRow = 15
    viewControllerDummy.mockUITableView.reloadData()
    var rowVisible = viewControllerDummy.mockUITableView.indexPathsForVisibleRows?.last
    viewControllerDummy.mockUITableView.nextCell()
    rowVisible?.row += 1
    XCTAssertEqual(rowVisible, viewControllerDummy.mockUITableView.indexPathsForVisibleRows?.last, "A celula deveria avançar uma posição")
  }

  func testNextCellSuccessNextSection() throws {
    viewControllerDummy.numberRow = 5
    viewControllerDummy.numberSection = 2
    viewControllerDummy.mockUITableView.reloadData()
    var rowVisible = viewControllerDummy.mockUITableView.indexPathsForVisibleRows?.last
    viewControllerDummy.mockUITableView.nextCell()
    rowVisible?.section += 1
    rowVisible?.row = 0
    XCTAssertEqual(rowVisible, viewControllerDummy.mockUITableView.indexPathsForVisibleRows?.last, "A celula deveria avançar uma posição")
  }

  func testNextCellSuccessOver() throws {
    viewControllerDummy.numberRow = 4
    viewControllerDummy.numberSection = 1
    viewControllerDummy.mockUITableView.reloadData()
    let rowVisible = viewControllerDummy.mockUITableView.indexPathsForVisibleRows?.last
    viewControllerDummy.mockUITableView.nextCell()
    XCTAssertEqual(rowVisible, viewControllerDummy.mockUITableView.indexPathsForVisibleRows?.last, "A celula não deveria mudar sua posição")
  }

  func testNextCellSuccessErrorNotVisibleCell() throws {
    viewControllerDummy.mockUITableView.frame = CGRect(x: 900, y: 9000, width: 0, height: 0)
    var rowVisible = viewControllerDummy.mockUITableView.indexPathsForVisibleRows?.last
    viewControllerDummy.mockUITableView.nextCell()
    rowVisible?.row += 1
    XCTAssertEqual(rowVisible, viewControllerDummy.mockUITableView.indexPathsForVisibleRows?.last, "A celula deveria retonrar 0.0")
  }

  // MARK: - Back Cell  -

  func testBackCellSuccessBackRow() throws {
    viewControllerDummy.numberRow = 15
    viewControllerDummy.mockUITableView.reloadData()

    viewControllerDummy.mockUITableView.nextCell()
    var rowVisible = viewControllerDummy.mockUITableView.indexPathsForVisibleRows?.last
    viewControllerDummy.mockUITableView.backCell()
    rowVisible?.row -= 1
    XCTAssertEqual(rowVisible, viewControllerDummy.mockUITableView.indexPathsForVisibleRows?.last, "A celula deveria recuar uma posição")
  }

  func testBackCellSuccessBackSection() throws {
    viewControllerDummy.numberRow = 4
    viewControllerDummy.numberSection = 3
    viewControllerDummy.mockUITableView.reloadData()
    viewControllerDummy.mockUITableView.nextCell()
    viewControllerDummy.mockUITableView.nextCell()
    viewControllerDummy.mockUITableView.nextCell()
    viewControllerDummy.mockUITableView.nextCell()
    var rowVisible = viewControllerDummy.mockUITableView.indexPathsForVisibleRows?.first
    viewControllerDummy.mockUITableView.backCell()
    rowVisible?.section -= 1
    rowVisible?.row = 3
    XCTAssertEqual(rowVisible, viewControllerDummy.mockUITableView.indexPathsForVisibleRows?.first, "A seção deveria recurar uma posição")
  }

  func testBackCellSuccessOver() throws {
    viewControllerDummy.numberRow = 4
    viewControllerDummy.numberSection = 1
    viewControllerDummy.mockUITableView.reloadData()
    let rowVisible = viewControllerDummy.mockUITableView.indexPathsForVisibleRows?.last
    viewControllerDummy.mockUITableView.backCell()
    XCTAssertEqual(rowVisible, viewControllerDummy.mockUITableView.indexPathsForVisibleRows?.last, "A celula não deveria avançar uma posição")
  }

  func testBackCellSuccessErrorNotVisibleCell() throws {
    viewControllerDummy.mockUITableView.frame = CGRect(x: 900, y: 9000, width: 0, height: 0)
    var rowVisible = viewControllerDummy.mockUITableView.indexPathsForVisibleRows?.last
    viewControllerDummy.mockUITableView.backCell()
    rowVisible?.row += 1
    XCTAssertEqual(rowVisible, viewControllerDummy.mockUITableView.indexPathsForVisibleRows?.last, "A celula deveria retornar 0.0")
  }
}
