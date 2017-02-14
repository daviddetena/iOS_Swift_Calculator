//
//  ViewController.swift
//  Calculator
//
//  Created by David de Tena on 13/02/2017.
//  Copyright © 2017 David de Tena. All rights reserved.
//

import UIKit

// Match each operation with its icon
enum CalcOp : String {
    case Add = "op-suma"
    case Substract = "op-resta"
    case Multiply = "op-multiplica"
    case Divide = "op-divide"
}

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var icoAdd: UIImageView!
    @IBOutlet weak var icoSubstract: UIImageView!
    @IBOutlet weak var icoMultiply: UIImageView!
    @IBOutlet weak var icoDivide: UIImageView!
    @IBOutlet weak var labelResult: UILabel!
    
    // MARK: - Custom properties
    let currencyFormatter = NumberFormatter()
    var result : String? {
        didSet {
            // With every change in result we get the text formatted in our label
            if let result = result{
                labelResult.text = currencyFormatter.string(for: NSNumber(value: Double(result.replacingOccurrences(of: ",", with: "."))!))
            }
        }
    }
    
    /// Save previous value
    var previousResult : String?
    
    var currentOperation : CalcOp? {
        willSet{
            // When a new operation is about to be pressed, reset op icons
            resetIcons();
        }
        
        didSet{
            // When a new value is set, "turn on" the icon for the op selected
            if let currentOperation = currentOperation{
                switch currentOperation {
                case .Add:
                    icoAdd.image = UIImage(named: "\(CalcOp.Add.rawValue)-on")
                case .Substract:
                    icoSubstract.image = UIImage(named: "\(CalcOp.Substract.rawValue)-on")
                case .Multiply:
                    icoMultiply.image = UIImage(named: "\(CalcOp.Multiply.rawValue)-on")
                case .Divide:
                    icoDivide.image = UIImage(named: "\(CalcOp.Divide.rawValue)-on")
                }
            }
            else{
                resetIcons()
            }
        }
    }
    
    var previousOperation : CalcOp?
    
    // MARK: - VC lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetCalculator()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.maximumFractionDigits = 6
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.locale = Locale.current
    }

    // MARK: - Overriden functions
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    // MARK: - Actions
    @IBAction func buttonPressed(_ sender: UIButton) {
        let key = sender.titleLabel!.text!
        
        switch key {
        case "1", "2", "3", "4", "5", "6", "7", "8", "9", "0":
            // If there was a previous result stored, append the new key pressed
            if var newResult = result{
                newResult.append(key)
                result = newResult
            }
            else{
                result = key
            }
        case ",":
            if var newResult = result {
                // Add a decimal separator only if it does not exist
                if newResult.range(of: ",") == nil {
                    newResult.append(".")
                    result = newResult
                }
            }
        case "+":
            currentOperation = .Add
            applyOperation()
        case "-":
            currentOperation = .Substract
            applyOperation()
        case "×":
            currentOperation = .Multiply
            applyOperation()
        case "÷":
            currentOperation = .Divide
            applyOperation()
        case "=":
            applyOperation()
            currentOperation = nil
            previousOperation = nil
            previousResult = nil
        case "AC":
            resetCalculator()
        case "±":
            if var newResult = result, let currentValue = Double(newResult){
                newResult = String(-currentValue)
                result = newResult
            }
        case "%":
            if var newResult = result, let currentValue = Double(newResult){
                newResult = String(currentValue / 100)
                result = newResult
            }
        default:
            print("Unexpected option pressed")
            
        }
    }
    
    // MARK: - Utils
    
    /// Apply the operation currently selected
    func applyOperation(){
        
        if result != nil {
            if var newResult = result, let prevOp = previousOperation, let prevResult = previousResult, let dblPreviousResult = Double(prevResult), let dblResult = Double(newResult){
                
                switch prevOp {
                case .Add:
                    newResult = String(dblPreviousResult + dblResult)
                case .Substract:
                    newResult = String(dblPreviousResult - dblResult)
                case .Multiply:
                    newResult = String(dblPreviousResult * dblResult)
                case .Divide:
                    if dblResult != 0 {
                        newResult = String(dblPreviousResult / dblResult)
                    }
                    else{
                        newResult = "0"
                    }
                }
                
                result = newResult
                previousResult = nil
                previousOperation = nil
            }
            else{
                // Ops chaining
                previousOperation = currentOperation
                previousResult = result
                result = nil
            }
        }
    }
    
    /// Set icons for UIImageViews
    func resetIcons(){
        icoAdd.image = UIImage(named: CalcOp.Add.rawValue)
        icoSubstract.image = UIImage(named: CalcOp.Substract.rawValue)
        icoMultiply.image = UIImage(named: CalcOp.Multiply.rawValue)
        icoDivide.image = UIImage(named: CalcOp.Divide.rawValue)
    }
    
    /// Reset calculator to it default state
    func resetCalculator(){
        resetIcons()
        result = nil
        previousResult = nil
        currentOperation = nil
        previousOperation = nil
        labelResult.text = "0"
    }
}

