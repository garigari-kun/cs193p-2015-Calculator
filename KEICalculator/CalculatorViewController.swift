//
//  CalculatorViewController.swift
//  KEICalculator
//
//  Created by keisuke on 10/21/15.
//  Copyright © 2015 keisuke. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController
{
    
    @IBOutlet weak var displayLabel: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    // Instance of model
    var brain = CalculatorBrain()

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            displayLabel.text = displayLabel.text! + digit
        } else {
            displayLabel.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    

    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
        
    }
    
    // Computed property for appending into the stack and displaying a displayLabel
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(displayLabel.text!)!.doubleValue
        }
        set {
            displayLabel.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }


}
