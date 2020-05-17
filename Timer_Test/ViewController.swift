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
        checkDeviceType()
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
    
    private func checkDeviceType() {
        print(UIDevice.current.modelName)
    }
    
}
//MARK:- UIDevice extension to get a simple name of the device. Maybe I can use this to get the device type back, and determine what screen size I am using
public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}
