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
    @IBOutlet weak var historyLabel: UILabel!
    
    
    var userIsInTheMiddleOfTypingANumber = false
    

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            /*
            if digit == "." && userHasEnteredDecimal == true {
                return
            } else if digit == "." && userHasEnteredDecimal == false {
                userHasEnteredDecimal = true
            }
            */
            if digit == "." && displayLabel.text!.rangeOfString(".") != nil {
                return
            }
            displayLabel.text = displayLabel.text! + digit
        } else {
            userIsInTheMiddleOfTypingANumber = true
            if digit == "." {
                displayLabel.text = "0."
            } else {
                displayLabel.text = digit
            }
        }
    }
    
    var operandStack = Array<Double>()
    
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        trackHistory(operation)
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        switch operation {
            case "×": performBinaryOperation() { $0 * $1 }
            case "÷": performBinaryOperation() { $1 / $0 }
            case "+": performBinaryOperation() { $0 + $1 }
            case "−": performBinaryOperation() { $1 - $0 }
            case "√": performUnaryOperation() { sqrt($0) }
            case "sin": performUnaryOperation() { sin($0) }
            case "cos": performUnaryOperation() { cos($0) }
            case "π": performConstants(operation)
            default: break
        }
    }
    
    
    
    func performBinaryOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performUnaryOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    
    func performConstants(symbol: String) {
        switch symbol {
            case "π":
                displayValue = M_PI
            default: break
        }
    }
    
    func trackHistory(historyElement: String) {
        historyLabel.text = historyLabel.text! + " " + historyElement
    }
    
    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack = [Double]()
        displayLabel.text = "0"
        historyLabel.text = ""
        print("C: operandStack = \(operandStack)")
    }
    

    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        trackHistory(displayLabel.text!)
        print("operandStack = \(operandStack)")
        
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
