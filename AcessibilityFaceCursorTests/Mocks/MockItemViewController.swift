//
//  MockItemViewController.swift
//  AcessibilityFaceMouseTests
//
//  Created by Joao Batista on 08/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import UIKit

class MockItemViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    setNavigationBar()
    title = "MockItemViewController"
    // Do any additional setup after loading the view.
  }

  func setNavigationBar() {
//    let buttonsystem = UIButton(type: .system)
//    let buttonRounded  = UIButton(type: .roundedRect)
//    let content = UINavigationBar()
//    content.addSubview(buttonsystem)
//    content.addSubview(buttonRounded)
//    self.navigationController?.navigationBar.addSubview(buttonsystem)
//    self.navigationController?.navigationBar.addSubview(buttonRounded)
//    self.navigationController?.navigationBar.addSubview(content)

  }

  @objc func backClicked (sender: UIBarButtonItem!){
    self.dismiss(animated: true, completion: nil);
  }

  public func pushNextView() {
    
  }
}
