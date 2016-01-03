//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Ian Boersma on 12/28/15.
//  Copyright © 2015 iboersma. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // Provide multiple options for user input.  Typically capitalized.  We will use this as a variable 'type' further down.
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        // provide case when no operator has been selected
        case Empty = "Empty"
    }
    // Calculator output
    @IBOutlet weak var outputLbl: UILabel!
    
    // create empty object variable for btnSound from AVAudioPlayer class
    var btnSound: AVAudioPlayer!
    
    // create and initialize to empty the numbers printed to the screen of the calculator
    var runningNumber = ""
    
    // create and initialize to empty left number in calc and right number in calc entered by user (eg: 456 x 234).  When user presses an operator button, we store runningNumber in leftValStr and put new number in rightValStr
    var leftValStr = ""
    var rightValStr = ""
    
    // create a variable to store operator that was selected by user (eg: / + * -).  We define this variable as type "Operation" from our Enum above. We initialize this to the "Empty" Enum value.
    var currentOperation: Operation = Operation.Empty
    
    var result = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Load wav sound file for use when button is clicked
        // Get path of our wav file on filesystem
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        // AVAudioPLayer requires that the input be in the form of an NSURL object, so we create that below
        let soundUrl =  NSURL(fileURLWithPath: path!)
        
        // Assign the soundUrl URL to the btnSound object.  NOTE: Swift 2.0 requires that we use a try/catch block if there is any chance the AVAudioPlayer could error out, so we wrap the assignment in a "do" block...
        do {
            try btnSound = AVAudioPlayer(contentsOfURL: soundUrl)
            // get audio file loaded for immediate use
            btnSound.prepareToPlay()
        } catch let err as NSError {
            // if it errors out, print the error to console
            print(err.debugDescription)
        }
        
        
    }
    
    @IBAction func numberPressed(btn: UIButton!) {
        
        playSound()
        // Grab tag property of button pressed from btn object and add it to runningNumber var
        runningNumber += "\(btn.tag)"
        
        outputLbl.text = runningNumber
    }

    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(Operation.Divide)
        
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(Operation.Multiply)
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(Operation.Add)
    }
    
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(Operation.Subtract)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(currentOperation)
    }
    // We create a function with a parameter of type "Operation" that we will use for each IBAction with a different param value
    func processOperation(op: Operation) {
        
        if currentOperation != Operation.Empty {
            // Some operator has been selected by the user
            
            if runningNumber != "" {
                
                // User selected an operator but then selected another operator without first entering a number
                // Run some math
                rightValStr = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide  {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation  == Operation.Add    {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                } else {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                }
                // store result in leftValStr for further use
                leftValStr = result
                // update output with result
                outputLbl.text = result

            }
    
            // store currentOperation for further use
            currentOperation = op
            
            
        } else {
            // This is the first time an operator has been pressed
            leftValStr = runningNumber
            // reset runningNumber
            runningNumber = ""
            // store currentOperation
            currentOperation = op
        }
    }
    
    @IBAction func onClearPressed(sender: AnyObject) {
        
        currentOperation = Operation.Empty
        result = ""
        outputLbl.text = result
        
    }
    func playSound() {
        // We make sure sounds don't overlap if user clicks too quickly
        if btnSound.playing {
            btnSound.stop()
        }
         btnSound.play()
    }
}

