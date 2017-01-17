//
//  ViewController.swift
//  Line Based Calculator
//
//  Created by Nathan Scott on 1/15/17.
//  Copyright © 2017 Nathan Scott. All rights reserved.
//


/*
 TODO:
 add more functions
    parentheses (ugh)
    factorial
    logarithms
    trigonometric functions
    square roots
 add support for negative numbers and decimals
 add multi-line ability
 add equation solving ability
 add conversion ability
 add function ability
 add variable ability
 add instructions
 add settings
 add multi-page function
 add history
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
    
    var expression = String()
    var expressionStub = String()
    
    var result: Double = 0
    
    func addToExpression(character:String){
        if character == "" && !expression.isEmpty {//backspace
            expression.remove(at: expression.index(before: expression.endIndex))
        }
        else {
            expression += character
        }
    }
    
    func calculate(arg1: Double, arg2: Double, op: String) -> Double {
        switch(op){
            case "+":
                return arg1 + arg2
            case "-":
                return arg1 - arg2
            case "*":
                return arg1 * arg2
            case "/":
                return arg1 / arg2
            case "%":
                return arg1.truncatingRemainder(dividingBy: arg2)
            case "^":
                return pow(arg1, arg2)
            default:
                return 0
        }
    }
    
    var depth = 0
    
    func evaluate(i1: String.Index, i2: String.Index) -> Double{
        print("==EVALUATING==")
        print(expressionStub.substring(with: i1..<i2))
        var numberArray: [Double] = []
        var operatorArray: [String] = []
        var temp:Double = 0
        var prevCVal:UInt32 = 0
        expressionStub = expressionStub.substring(with: i1..<i2)

        for c in expressionStub.unicodeScalars {
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
            else if c.value == 37 { //% sign
                if ((prevCVal >= 48 && prevCVal <= 57)){
                    numberArray.append(temp)
                    temp = 0
                    prevCVal = c.value
                }
                operatorArray.append("%")
            }
            else if c.value == 94 { //^ sign
                if ((prevCVal >= 48 && prevCVal <= 57)){
                    numberArray.append(temp)
                    temp = 0
                    prevCVal = c.value
                }
                operatorArray.append("^")
            }
        }
        numberArray.append(temp)
        print(numberArray)
        print(operatorArray)
        if operatorArray.isEmpty {
            print("~Result: ")
            print(numberArray[0])
            return numberArray[0]
        }
        var e:Int? = 0
        var i:Int? = 0
        var j:Int? = 0
        var k:Int? = 0
        var a:Int? = 0
        var s:Int? = 0
        var opCounts:[String:Int] = [:]
        
        for item in operatorArray {
            opCounts[item] = (opCounts[item] ?? 0) + 1
        }
        
        print(opCounts)
        while operatorArray.contains("^") {
            e = operatorArray.index(of: "^")
            result = calculate(arg1: numberArray[e!], arg2: numberArray[e! + 1], op: operatorArray[e!])
            numberArray[e!+1] = result
            numberArray.remove(at: e!)
            operatorArray.remove(at: e!)
        }
        while operatorArray.contains("*") || operatorArray.contains("/") || operatorArray.contains("%") {
            if (operatorArray.contains("*")){i = operatorArray.index(of: "*")!}
            if (operatorArray.contains("/")){j = operatorArray.index(of: "/")!}
            if (operatorArray.contains("%")){k = operatorArray.index(of: "%")!}
            if (j != 0 || i != 0) {
                if (j! < i!) {
                    i = j
                }
                if k != 0{
                    if k! < i! || (!operatorArray.contains("*") && !operatorArray.contains("/")) {
                        i = k
                    }
                }
            }
            result = calculate(arg1: numberArray[i!], arg2: numberArray[i! + 1], op: operatorArray[i!])
            numberArray[i!+1] = result
            numberArray.remove(at: i!)
            operatorArray.remove(at: i!)
        }
        while operatorArray.contains("+") || operatorArray.contains("-") {
            if (operatorArray.contains("+")){a = operatorArray.index(of: "+")!}
            if (operatorArray.contains("-")){s = operatorArray.index(of: "-")!}
            if (s != 0 || a != 0) {if (s! < a!) {a = s}}
            result = calculate(arg1: numberArray[a!], arg2: numberArray[a! + 1], op: operatorArray[a!])
            numberArray[a!+1] = result
            numberArray.remove(at: a!)
            operatorArray.remove(at: a!)
        }
        print("~Result: ")
        print(result)
        print(numberArray)
        print(operatorArray)
        return result
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        addToExpression(character: text)
        expressionStub = expression
        output.text = String(evaluate(i1: expression.startIndex, i2: expression.endIndex))
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

