//
//  AcessibilityGetSensitivityViewController.swift
//  AcessibilityFaceMovimentBR
//
//  Created by Joao Batista on 28/02/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import UIKit
import ARKit

open class AcessibilityGetSensitivityViewController: UIViewController {

  // MARK: - Private Property

  private let sceneView = ARSCNView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
  private var isInCapture: Bool = false
  private var direction: DirectiorFaceMoviment = .axisX
  private var manager = ManagePointSensibility()

  // MARK: - Public Property
  
  public weak var sensibilityDelegate: GetSensitivityProtocol?

  // MARK: - Life cicle

  open override func viewDidLoad() {
    super.viewDidLoad()
    setupSceneView()
    setupViews()
    manager.delegate = self
  }

  open override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    UIApplication.shared.isIdleTimerDisabled = true
    resetTracking()
  }

  open override func viewDidDisappear(_ animated: Bool) {
    sceneView.session.pause()
  }
  
  // MARK: - Public Class Methods

  open func initialCapture(withDirection direction: DirectiorFaceMoviment) {
    self.direction = direction
    isInCapture = true
  }

  // MARK: - Private Class Methods

  private func resetTracking() {
    guard ARFaceTrackingConfiguration.isSupported else {return}
    let configuration = ARFaceTrackingConfiguration()
    configuration.maximumNumberOfTrackedFaces = 1
    sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
  }

  private func setupSceneView() {
    sceneView.delegate = self
    sceneView.session.delegate = self
    sceneView.isHidden = true
  }

  private func setupViews() {
    view.addSubview(sceneView)
  }
}

// MARK: - Extension AR

extension AcessibilityGetSensitivityViewController: ARSCNViewDelegate, ARSessionDelegate {

  public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    let point = CGPoint(x: CGFloat(node.eulerAngles.y).truncate(), y: CGFloat(node.eulerAngles.x).truncate())
    if isInCapture {
       manager.insertValueToCompare(thePoint: point, andDirection: direction)
    }
  }
}

extension AcessibilityGetSensitivityViewController: ManagerPointSesibilittyProtocol {
  func capturaStartGetValue() {
    sensibilityDelegate?.startCaptura()
  }

  func captureFinishWith(theValue value: CGFloat) {
    sensibilityDelegate?.returnCapture(theValue: value)
    isInCapture = false
  }
}
