//
//  VoiceAction.swift
//  AcessibilityFaceMovimentBR
//
//  Created by Joao Batista on 02/03/21.
//  Copyright © 2021 Joao Batista. All rights reserved.
//

import Speech

open class VoiceAction: VoiceActionProtocol {

  internal var audioEngine = AVAudioEngine()

  private let request = SFSpeechAudioBufferRecognitionRequest()
  private var task: SFSpeechRecognitionTask!
  private var timer = TimerControl()
  private (set) var isCooldown : Bool = false
  private (set) var isInitialized : Bool = false
  private (set) var speechReconizer: SFSpeechRecognizer?
  private (set) var actionVoiceCommands: ActionVoiceCommands = ActionVoiceCommands.getDefault()

  open weak var delegateResponseCommand: VoiceActionCommandProtocol?
  open weak var delegate: VoiceActionResponseProtocol?

  init(locale: Locale = ValuesConstants.locale) {
    speechReconizer = SFSpeechRecognizer(locale: locale)
    timer.delegate = self
    request.requiresOnDeviceRecognition = true
  }

  open func set(TheActionWord actionVoiceCommands: ActionVoiceCommands) {
    self.actionVoiceCommands = actionVoiceCommands
  }

  open func set(locale: Locale) {
    speechReconizer = SFSpeechRecognizer(locale: locale)
  }

  open func start() {
    if !audioEngine.isRunning && isInitialized {
      startAudioEngine()
    }
  }

  open func stop() {
    audioEngine.pause()
  }

  open func checkPermissions() {
    SFSpeechRecognizer.requestAuthorization { authStatus in
      DispatchQueue.main.async {
        switch authStatus {
        case .authorized:
          self.delegate?.permissionGranted()
        case .denied:
          self.delegate?.errorPermission(status: .denied)
        case .restricted:
          self.delegate?.errorPermission(status: .restricted)
        case .notDetermined:
          self.delegate?.errorPermission(status: .notDetermined)
        @unknown default:
          self.delegate?.errorGeneric()
        }
      }
    }
  }

  open func initialRecording() {
    isInitialized = true
    let node = audioEngine.inputNode
    let recordingFormat = node.outputFormat(forBus: 0)

    node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
      self.request.append(buffer)
    }
    startAudioEngine()
  }

  private func startAudioEngine() {
    audioEngine.prepare()
    do {
      try audioEngine.start()
    } catch {
      delegate?.errorGeneric()
    }

    recognitionTask()
  }

  private func recognitionTask() {

    task = speechReconizer?.recognitionTask(with: request, resultHandler: { (response, error) in
      guard let response = response else {
        self.delegate?.errorGeneric()
        return
      }

      if error != nil {
        self.delegate?.errorGeneric()
        return
      }

      let message = response.bestTranscription.formattedString.split(separator: " ")
      if let actioText = message.last {
        let actionWords = self.actionVoiceCommands.getCommandsString()
        for action in actionWords where action.lowercased() == String(actioText).lowercased() && !self.isCooldown {
          self.delegateResponseCommand?.commandDetected(withCommand: self.actionVoiceCommands.getCommandoEnum(withText: action))
          self.timer.startTimer(withTimerSeconds: ValuesConstants.cooldown)
          self.isCooldown = true
        }
      }
    })
  }
}

extension VoiceAction: TimerActionResponseProtocol {
  func finishTimer() {
    isCooldown = false
  }
}
