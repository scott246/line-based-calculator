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
 add support for different bases of numbers
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
    
    var expression = String()       //entire expression
    var expressionStub = String()   //part of the expression, like between parentheses
    
    var result: Double = 0          //final result
    
    //add a character to the end of the entire expression
    func addToExpression(character:String){
        if character == "" && !expression.isEmpty {//backspace
            expression.remove(at: expression.index(before: expression.endIndex))
        }
        else {
            expression += character
        }
    }
    
    //factorial calculator
    func factorial(arg: Double) -> Double{
        if (arg > 20) {
            return Double.nan
        }
        if (arg == 1 || arg == 0) {
            return 1
        }
        return factorial(arg: arg-1) * factorial(arg: arg-2)
    }
    
    //calculate a given one or two argument operation (arg1 op (arg2?))
    func calculate(arg1: Double, arg2: Double?, op: String) -> Double {
        switch(op){
            case "+":
                return arg1 + arg2!
            case "-":
                return arg1 - arg2!
            case "*":
                return arg1 * arg2!
            case "/":
                return arg1 / arg2!
            case "%":
                return arg1.truncatingRemainder(dividingBy: arg2!)
            case "^":
                return pow(arg1, arg2!)
            case "fact":
                return factorial(arg: arg1)
            default:
                return 0
        }
    }
    
    var depth = 0
    var isNegative:Bool = false
    var isDecimal:Bool = false
    
    //evaluate the expression from index i1 to i2
    func evaluate(i1: String.Index, i2: String.Index) -> Double{
        print("==EVALUATING==")
        print(expressionStub.substring(with: i1..<i2))
        
        //if the last character is an operator, return nan
        var lastchar:UInt32 = 0
        if (i1 != i2){
            lastchar = (expressionStub.substring(with: i1..<i2).unicodeScalars.last?.value)!
        }
        if lastchar == 43 || lastchar == 45 || lastchar == 42 || lastchar == 47 || lastchar == 94 { //last character is an operator
            return Double.nan
        }
        
        //if the expression contains "fact(xxx)", find that and deal with that first
        while expressionStub.contains("fact"){
            break;
        }
        
        var numberArray: [Double] = []          //array of numbers in the expression
        var operatorArray: [String] = []        //array of operators in the expression
        var temp:String = "0"
//        var decTemp:Double = 0.0
//        var decimalPlaces: Double = 10
        var prevCVal:UInt32 = 0
        
        expressionStub = expressionStub.substring(with: i1..<i2)
        
        //go through each character in the expression
        for c in expressionStub.unicodeScalars {
            // if the value is a number or decimal place
            if c.value >= 48 && c.value <= 57 || c.value == 46 {
                if prevCVal >= 48 && prevCVal <= 57 || prevCVal == 46 {
                    numberArray.removeLast()
                }
                temp = temp + String(c)
                numberArray.append(Double(temp)!)
                prevCVal = c.value
            }
            
            else if c.value == 43 { //+ sign
                if ((prevCVal >= 48 && prevCVal <= 57)){
                    if (!isNegative) {numberArray.removeLast(); numberArray.append(Double(temp)!)}
                    else {numberArray.removeLast(); numberArray.append(-Double(temp)!); isNegative = false}
                    temp = "0"
                    prevCVal = c.value
                }
                operatorArray.append("+")
            }
            else if c.value == 45 { //- sign
                if ((prevCVal >= 48 && prevCVal <= 57 || prevCVal == 41)){
                    if (!isNegative) {numberArray.removeLast(); numberArray.append(Double(temp)!)}
                    else {numberArray.removeLast(); numberArray.append(-Double(temp)!); isNegative = false}
                    temp = "0"
                    prevCVal = c.value
                    operatorArray.append("-")
                }
                else {
                    isNegative = true
                }
            }
            else if c.value == 42 { //* sign
                if ((prevCVal >= 48 && prevCVal <= 57)){
                    if (!isNegative) {numberArray.removeLast(); numberArray.append(Double(temp)!)}
                    else {numberArray.removeLast(); numberArray.append(-Double(temp)!); isNegative = false}
                    temp = "0"
                    prevCVal = c.value
                }
                operatorArray.append("*")
            }
            else if c.value == 47 { //(/) sign
                if ((prevCVal >= 48 && prevCVal <= 57)){
                    if (!isNegative) {numberArray.removeLast(); numberArray.append(Double(temp)!)}
                    else {numberArray.removeLast(); numberArray.append(-Double(temp)!); isNegative = false}
                    temp = "0"
                    prevCVal = c.value
                }
                operatorArray.append("/")
            }
            else if c.value == 37 { //% sign
                if ((prevCVal >= 48 && prevCVal <= 57)){
                    if (!isNegative) {numberArray.removeLast(); numberArray.append(Double(temp)!)}
                    else {numberArray.removeLast(); numberArray.append(-Double(temp)!); isNegative = false}
                    temp = "0"
                    prevCVal = c.value
                }
                operatorArray.append("%")
            }
            else if c.value == 94 { //^ sign
                if ((prevCVal >= 48 && prevCVal <= 57)){
                    if (!isNegative) {numberArray.removeLast(); numberArray.append(Double(temp)!)}
                    else {numberArray.removeLast(); numberArray.append(-Double(temp)!); isNegative = false}
                    temp = "0"
                    prevCVal = c.value
                }
                operatorArray.append("^")
            }
        }
        if (!isNegative) { if !numberArray.isEmpty{numberArray.removeLast()}; numberArray.append(Double(temp)!)}
        else {if !numberArray.isEmpty{numberArray.removeLast()}; numberArray.append(-Double(temp)!); isNegative = false}
        print(numberArray)
        print(operatorArray)
        
        // if there are no operators, return the first number in the number array
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
        
        //FOLLOW ORDER OF OPERATIONS
        
        //if the expression has an ^, deal with that first...
        while operatorArray.contains("^") {
            e = operatorArray.index(of: "^")
            result = calculate(arg1: numberArray[e!], arg2: numberArray[e! + 1], op: operatorArray[e!])
            numberArray[e!+1] = result
            numberArray.remove(at: e!)
            operatorArray.remove(at: e!)
        }
        
        //... if the expression has *, /, or %, deal with that next...
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
        
        //... finally, deal with the + and -'s.
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
    
    //whenever the input is changed, adjust the answer accordingly
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

