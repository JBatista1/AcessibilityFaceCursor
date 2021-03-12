//
//  AccessibilityFaceAnchor.swift
//  AcessibilityFaceMovimentBR
//
//  Created by Joao Batista on 07/01/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import UIKit
import ARKit
import Speech

open class AccessibilityFaceAnchorViewController: AcessibilityViewController {

  // MARK: - Private Property
  
  private let sceneView = ARSCNView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
  private let moveCursor: MoveCursorProtocol = MoveCursorFaceAnchor()
  private var isShow = true
  private var actualPoint: CGPoint = .zero
  private var isCooldown = false

  open var voiceAction: VoiceActionProtocol = VoiceAction()
  
  // MARK: - Life cicle

  open override func viewDidLoad() {
    super.viewDidLoad()
    setupSceneView()
    setupViews()
    voiceAction.delegateResponseCommand = self
  }

  open override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    UIApplication.shared.isIdleTimerDisabled = true
    resetTracking()
    voiceAction.checkPermissions()
    if action.getType() == .voice {
      voiceAction.start()
    }
  }

  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }

  open override func viewDidDisappear(_ animated: Bool) {
    sceneView.session.pause()
    if action.getType() == .voice {
      voiceAction.stop()
    }
  }

  public func set(faceSensitivity: FaceSensitivity) {
    moveCursor.set(faceSensitivity: faceSensitivity)
  }

  // MARK: - Private Class Methods

  private func resetTracking() {
    guard ARFaceTrackingConfiguration.isSupported else {return}
    let configuration = ARFaceTrackingConfiguration()
    configuration.maximumNumberOfTrackedFaces = 1
    sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
  }

  private func setupSceneView() {
    sceneView.delegate = self
    sceneView.session.delegate = self
    sceneView.isHidden = true
    sceneView.preferredFramesPerSecond = ValuesConstants.framesPerSecond
  }

  private func setupViews() {
    view.addSubview(sceneView)
  }

  private func coordinatorVoiceAction(WithCommand command: VoiceCommand) {

  }

  private func animateCursor(toNextPoint nextPoint: CGPoint) {
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.9, delay: 0, usingSpringWithDamping: 3, initialSpringVelocity: 0.2, options: [.curveLinear], animations: {
        self.cursor.center = nextPoint
      }, completion: nil)
    }
  }

  private func verifyAction(withValueEyeRight eyeRight: CGFloat, theEyeLeft eyeLeft: CGFloat, tongueValue tongue: CGFloat, andPoint point: CGPoint) {
    if action.verifyAction(withValueEyeRight: eyeRight, theEyeLeft: eyeLeft, andTongueValue: tongue) {
      action.getViewForAction(withPoint: point)
    }
  }

  private func actionVoice(withPoint point: CGPoint) {
    action.getViewForAction(withPoint: point)
  }
}

// MARK: - Extension AR

extension AccessibilityFaceAnchorViewController: ARSCNViewDelegate, ARSessionDelegate {

  public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    guard let faceAnchor = anchor as? ARFaceAnchor,
      let eyeRight = faceAnchor.blendShapes[.eyeBlinkLeft] as? CGFloat,
      let eyeLeft = faceAnchor.blendShapes[.eyeBlinkRight] as? CGFloat,
      let tongue = faceAnchor.blendShapes[.tongueOut] as? CGFloat else { return }
    let point = CGPoint(x: CGFloat(node.eulerAngles.y).truncate(), y: CGFloat(node.eulerAngles.x).truncate())
    actualPoint = self.moveCursor.getNextPosition(withPoint: point)
    if action.getType() != .voice {
       self.verifyAction(withValueEyeRight: eyeRight, theEyeLeft: eyeLeft, tongueValue: tongue, andPoint: actualPoint)
    }
    self.animateCursor(toNextPoint: actualPoint)
  }
}

extension AccessibilityFaceAnchorViewController: VoiceActionCommandProtocol {
  public func commandDetected(withCommand command: VoiceCommand) {
    switch command {
    case .action:
      actionVoice(withPoint: actualPoint)
    case .backNavigation:
      selectedBackNavigationBar()
    case .scrollNext:
      scrollNextCell()
    case .scrollBack:
      scrollBackCell()
    case .unknown:
      break
    }
  }
}

