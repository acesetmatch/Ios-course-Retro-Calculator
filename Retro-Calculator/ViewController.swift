//
//  ViewController.swift
//  Retro-Calculator
//
//  Created by Shawn on 12/28/15.
//  Copyright © 2015 Shawn. All rights reserved.
//

import UIKit
import AVFoundation //audio video player

class ViewController: UIViewController {
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
        case Clear = "Clear"
    }
    
    @IBOutlet weak var outputLbl: UILabel!
    
    var btnSound: AVAudioPlayer!
    
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var currentOperation: Operation = Operation.Empty //Operation is made into a type and set as empty
    var result = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //extracting URL sound file
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundUrl = NSURL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOfURL: soundUrl) //loaded url
            btnSound.prepareToPlay() //function on av audio player to get sound ready for user
        } catch let err as NSError {
            print(err.debugDescription) //print in debugger
        }
    }
    
    @IBAction func numberPressed(btn: UIButton) {
        playSound()
        
        runningNumber += "\(btn.tag)" //btn.7 is button 7 on calculator
        outputLbl.text = runningNumber
    }


    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(Operation.Divide)
    }

    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(Operation.Multiply)
    }
    
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(Operation.Subtract)
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(Operation.Add)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(currentOperation)
    }

    @IBAction func onClearPressed(sender: AnyObject) {
        playSound()
        restartCalculator()
    }
   
    
    func processOperation(op: Operation) {
        playSound()
        
        if currentOperation != Operation.Empty {
            //Run some math
            
            //A User selected an operator, but then selected another operator without first entering a number
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
            
                if currentOperation  == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double (rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double (rightValStr)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                } else if currentOperation == Operation.Clear {
                    runningNumber = ""
                    result = "0"
                    leftValStr = result
                    outputLbl.text = result
                }
            

            leftValStr = result //result in stored on left side so its (leftvalue string) ... (right value string) = result
            outputLbl.text = result
            }
            currentOperation = op
            
        }else {
            //This is the first time operator has been pressed
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = op

        }
    }
  
    func restartCalculator() {
        leftValStr = "0"
        rightValStr = "0"
        runningNumber = ""
        outputLbl.text = "0"
        currentOperation = Operation.Empty
    }
    
    
    func playSound() {
        if btnSound.playing {
            btnSound.stop()
        }
        
        btnSound.play()
    }
}

