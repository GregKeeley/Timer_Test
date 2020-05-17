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

    @IBOutlet weak var switchYConstraint: NSLayoutConstraint!
    
    
    var timerIsPaused: Bool = true
    var timer = Timer()
    
    var addToConstraint = true
    
    var seconds: Int = 00 {
        didSet {
            timerLabel.text = ("\(minutes):\(seconds)")
        }
    }
    var minutes: Int = 00
    var hours: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func startTimerButtonPressed1(_ sender: UIButton) {
        startTimer()
        print("Start")
    }

    
    private func startTimer() {
        print(timerIsPaused)
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
    private func moveSwitch() {
        if addToConstraint {
            if switchYConstraint.constant <= 25 {
                print(switchYConstraint.constant)
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

