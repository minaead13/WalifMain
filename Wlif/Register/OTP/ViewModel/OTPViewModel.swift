//
//  OTPViewModel.swift
//  Wlif
//
//  Created by OSX on 02/07/2025.
//

import Foundation

protocol TimerViewModelDelegate : AnyObject {
    func timerDidUpdate(timeString : String)
    func timerDidFinish(Enabled: Bool)
}

class OTPViewModel {
    
    var userData: User?
    
    weak var delegate : TimerViewModelDelegate?
    var countdownTimer: Timer?
    var totalTimeInSeconds: TimeInterval = 60
    var timeRemaining: TimeInterval = 0
    private var isEnabled: Bool = false
    
    init() {
        startTimer()
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        timeRemaining = totalTimeInSeconds
    }
    
    @objc private func updateTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            let timeString = formatTime(timeRemaining)
            delegate?.timerDidUpdate(timeString: timeString)
        } else {
            countdownTimer?.invalidate()
            isEnabled = true
            delegate?.timerDidFinish(Enabled: isEnabled)
        }
    }
    
    func restartTimer() {
        timeRemaining = totalTimeInSeconds
        delegate?.timerDidUpdate(timeString: formatTime(timeRemaining))
        
        isEnabled = false
        delegate?.timerDidFinish(Enabled: isEnabled)
        startTimer()
    }
    
    func stopTimer() {
        countdownTimer?.invalidate()
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let seconds = Int(time)
        return "\(seconds)"
    }
}
