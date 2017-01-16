//
//  ViewController.swift
//  Line Based Calculator
//
//  Created by Nathan Scott on 1/15/17.
//  Copyright © 2017 Nathan Scott. All rights reserved.
//


/*
 TODO:
 order of operations
 add more functions
    parentheses (ugh)
    exponents
    modulus
 add multi-line ability
 add equation solving ability
 add conversion ability
 add function ability
 add variable ability
 */

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var input: UITextView!
    @IBOutlet weak var output: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        input.delegate = self
    }
    
    var totalInput = String()
    var inputIndex = 0
    
    var numberArray: [Double] = []
    var operatorArray: [String] = []
    
    var result: Double = 0
    
    func addToTotalInput(character:String){
        if character == "" && !totalInput.isEmpty {//backspace
            totalInput.remove(at: totalInput.index(before: totalInput.endIndex))
        }
        else {
            totalInput += character
        }
    }
    
    func calculate(arg1: Double, arg2: Double?, op: String?) -> Double {
        if (arg2 == nil || op == nil) {
            return arg1
        }
        switch(op){
            case "+"?:
                return arg1 + arg2!
            case "-"?:
                return arg1 - arg2!
            case "*"?:
                return arg1 * arg2!
            case "/"?:
                return arg1 / arg2!
            default:
                return 0
        }
    }
    
    func evaluate()->Double{
        var temp:Double = 0
        var prevCVal:UInt32 = 0
        result = 0
        for c in totalInput.unicodeScalars {
            if c.value >= 48 && c.value <= 57 { //numbers
                if prevCVal >= 48 && prevCVal <= 57 {
                    temp *= 10
                    temp += Double(c.value - 48)
                    prevCVal = c.value
                }
                else {
                    temp += Double(c.value - 48)
                    prevCVal = c.value
                }
            }
            else if c.value == 43 { //+ sign
                if ((prevCVal >= 48 && prevCVal <= 57)){
                    numberArray.append(temp)
                    temp = 0
                    prevCVal = c.value
                }
                operatorArray.append("+")
            }
            else if c.value == 45 { //- sign
                if ((prevCVal >= 48 && prevCVal <= 57)){
                    numberArray.append(temp)
                    temp = 0
                    prevCVal = c.value
                }
                operatorArray.append("-")
            }
            else if c.value == 42 { //* sign
                if ((prevCVal >= 48 && prevCVal <= 57)){
                    numberArray.append(temp)
                    temp = 0
                    prevCVal = c.value
                }
                operatorArray.append("*")
            }
            else if c.value == 47 { //(/) sign
                if ((prevCVal >= 48 && prevCVal <= 57)){
                    numberArray.append(temp)
                    temp = 0
                    prevCVal = c.value
                }
                operatorArray.append("/")
            }
        }
        numberArray.append(temp)
        if operatorArray.isEmpty {
            return numberArray[0]
        }
        if numberArray.count <= operatorArray.count {
            return 0
        }
        var i:Int? = 0
        var j:Int? = 0
        print(numberArray)
        print(operatorArray)
        while operatorArray.contains("*") || operatorArray.contains("/") {
            if (operatorArray.contains("*")){i = operatorArray.index(of: "*")!}
            if (operatorArray.contains("/")){j = operatorArray.index(of: "/")!}
            if (j != 0 && i != 0) {if (j! < i!) {i = j}}
            result = calculate(arg1: numberArray[i!], arg2: numberArray[i! + 1], op: operatorArray[i!])
            numberArray[i!+1] = result
            numberArray.remove(at: i!)
            operatorArray.remove(at: i!)
        }
        while operatorArray.contains("+") || operatorArray.contains("-") {
            if (operatorArray.contains("+")){i = operatorArray.index(of: "+")!}
            if (operatorArray.contains("-")){j = operatorArray.index(of: "-")!}
            if (j != 0 && i != 0) {if (j! < i!) {i = j}}
            result = calculate(arg1: numberArray[i!], arg2: numberArray[i! + 1], op: operatorArray[i!])
            numberArray[i!+1] = result
            numberArray.remove(at: i!)
            operatorArray.remove(at: i!)
        }
        return result
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        addToTotalInput(character: text)
        numberArray = []
        operatorArray = []
        output.text = String(evaluate())
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

