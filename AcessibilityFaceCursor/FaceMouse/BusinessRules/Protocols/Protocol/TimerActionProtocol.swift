//
//  TimerActionProtocol.swift
//  AcessibilityFaceMovimentBR
//
//  Created by Joao Batista on 06/02/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

protocol TimerActionProtocol {
  var delegate: TimerActionResponseProtocol? {get set}
  func startTimer(withTimerSeconds seconds: Int)
}
