//
//  Evaluate.swift
//  Solvr
//
//  Created by Nathan Scott on 1/23/17.
//  Copyright © 2017 Nathan Scott. All rights reserved.
//

import Foundation

class Evaluate {
    func isOperator(symbol: Character) -> Bool {
        return (symbol == "+" || symbol == "-" || symbol == "*" || symbol == "/" || symbol == "%" || symbol == "^")
    }
    
    func isLeftAssociative(symbol: Character) -> Bool {
        return (symbol == "+" || symbol == "-" || symbol == "*" || symbol == "/" || symbol == "%")
    }
    
    func isRightAssociative(symbol: Character) -> Bool {
        return (symbol == "^")
    }
    
    func getPrecedence(symbol: Character) -> Int {
        switch symbol {
        case "+","-":
            return 0
        case "*","/","%":
            return 5
        case "^":
            return 10
        default:
            return 0
        }
    }
    
    //function to convert infix notation to postfix notation (shunting yard algorithm)
    func convertToRPN(infix: String) -> [String] {
        var postfix = [String]()        //result as an array
        var tempNumber = String()     //temporary number
        let stack = Stack<Character>.init(inputtedSize: infix.characters.count)
        
        //scan the stack
        for char in infix.characters {
            switch char {
            case "+", "-", "*", "/", "^", "%":
                if !tempNumber.isEmpty {
                    postfix.append(tempNumber)
                    tempNumber = ""
                }
                if (stack.peek() != nil){
                    while (isOperator(symbol: stack.peek()!) && ((isLeftAssociative(symbol: char) && getPrecedence(symbol: char) <= getPrecedence(symbol: stack.peek()!)) || (isRightAssociative(symbol: char) && (getPrecedence(symbol: char) < getPrecedence(symbol: stack.peek()!))))) {
                        var temp:String = ""
                        temp.append(stack.pop()!)
                        postfix.append(temp)
                    }
                }
                
                stack.push(item: char)
                break
            case "(":
                if !tempNumber.isEmpty {
                    postfix.append(tempNumber)
                    tempNumber = ""
                }
                stack.push(item: char)
                break
            case ")":
                if !tempNumber.isEmpty {
                    postfix.append(tempNumber)
                    tempNumber = ""
                }
                while (stack.peek()! != "(") {
                    var temp:String = ""
                    temp.append(stack.pop()!)
                    postfix.append(temp)
                }
                stack.pop()!
                break
            default: //number
                tempNumber.append(char)
                break
            }
            print("RPN Stack:")
            stack.printStack()
        }
        if !tempNumber.isEmpty {
            postfix.append(tempNumber)
            tempNumber = ""
        }
        while !stack.isEmpty() {
            var temp:String = ""
            temp.append(stack.pop()!)
            postfix.append(temp)
            print("RPN Stack:")
            stack.printStack()
        }
        print("POSTFIX NOTATION:")
        print(postfix)
        return postfix
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
        if arg2 == nil {return arg1}
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
    
    //evaluate a given postfix array
    func postfixEvaluate(postfix: [String]) -> Double {
        var result: Double = 0.0
        let stack = Stack<Double>.init(inputtedSize: postfix.count)
        if postfix.isEmpty {
            return result
        }
        
        //add everything to a stack
        for element in postfix {
            if isOperator(symbol: element.characters.first!) {
                stack.push(item: calculate(arg1: stack.pop()!, arg2: stack.pop(), op: element))
            } else {
                stack.push(item: Double(element)!)
            }
            print("EvaluationStack: ")
            stack.printStack()
        }
        result = stack.pop()!
        return result
    }
}
