//
//  TimerControl.swift
//  AcessibilityFaceMovimentBR
//
//  Created by Joao Batista on 06/02/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import Foundation

class TimerControl: TimerActionProtocol {

  private var timer: Timer?
  private var secondTimer: Int = 0
  private var runTimer: Int = 0
  weak var delegate: TimerActionResponseProtocol?

  init() {}

  func startTimer(withTimerSeconds seconds: Int) {
    secondTimer = seconds
    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(finishTimer), userInfo: nil, repeats: true)
  }
  
  // MARK: - Class Methods

  @objc private func finishTimer() {
    runTimer += 1
    verifyTimerIsFinish(withRunTimer: runTimer)
  }

  private func verifyTimerIsFinish(withRunTimer runTimer: Int) {
    if runTimer >= secondTimer {
      delegate?.finishTimer()
      timer?.invalidate()
    }
  }
}
