//
//  ViewController.swift
//  Timer_Test
//
//  Created by Gregory Keeley on 5/17/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var centerSwitch: UISwitch!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var startTimerButton: UIButton!
    

    @IBOutlet weak var switchYConstraint: NSLayoutConstraint!
    
    var currentScore: Int = 0 {
        didSet {
            if currentScore >= highScore {
                highScore = currentScore
            }
            currentScoreLabel.text = ("Current Score: \(currentScore)")
        }
    }
    
    var highScore: Int = 0 {
        didSet {
            if currentScore >= highScore {
                highScoreLabel.text = ("High Score: \(highScore)")
            }
        }
    }
    
    var timerIsPaused: Bool = true
    var timer = Timer()
    
    var addToConstraint = true
    
    var seconds: Int = 0 {
        didSet {
            if seconds < 10 && minutes < 10 {
            timerLabel.text = ("0\(minutes):0\(seconds)")
            } else if seconds < 10 && minutes >= 10 {
                timerLabel.text = ("\(minutes):0\(seconds)")
            } else {
                timerLabel.text = ("0\(minutes):\(seconds)")
            }
        }
    }
    
    var minutes: Int = 0 {
        didSet {
            if minutes < 10 {
                timerLabel.text = ("0\(minutes):0\(seconds)")
            } else {
                timerLabel.text = ("\(minutes):0\(seconds)")
            }
        }
    }
    
    var hours: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func changeScore(_ sender: UISwitch) {
        currentScore += 1
    }
    @IBAction func resetCurrentScoreButtonPressed(_ sender: UIButton) {
        currentScore = 0
    }
    
    @IBAction func startTimerButtonPressed1(_ sender: UIButton) {
        startTimer()
        if timerIsPaused {
            startTimerButton.setTitle("Start", for: .normal)
        } else {
            startTimerButton.setTitle("Stop", for: .normal)
        }
    }

    // Function that starts the timer
    private func startTimer() {
        timerIsPaused.toggle()
        if timerIsPaused == false {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { tempTimer in
                self.moveSwitch()
                if self.seconds == 59 {
                    self.seconds = 00
                    if self.minutes == 59 {
                        self.minutes = 00
                        self.hours = self.hours + 1
                    } else {
                        self.minutes = self.minutes + 1
                    }
                } else {
                    self.seconds = self.seconds + 1
                }
            }
        } else {
            timer.invalidate()
        }
    }
    // Animation block to move switch each second
    private func moveSwitch() {
        if addToConstraint {
            if switchYConstraint.constant <= 25 {
                UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction], animations: {
                    self.switchYConstraint.constant += 5
                    self.view.layoutIfNeeded()
                })
            } else if switchYConstraint.constant >= 25 {
                addToConstraint = false
            }
        }
        if addToConstraint == false {
            if switchYConstraint.constant >= -25 {
                UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction], animations: {
                    self.switchYConstraint.constant -= 5
                    self.view.layoutIfNeeded()
                })
            } else if switchYConstraint.constant <= -25 {
                addToConstraint = true
            }
        }
    }
}

