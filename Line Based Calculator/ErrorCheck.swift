//
//  ErrorCheck.swift
//  Solvr
//
//  Created by Nathan Scott on 1/23/17.
//  Copyright © 2017 Nathan Scott. All rights reserved.
//

import Foundation

class ErrorCheck {
    var e = Evaluate()
    
    //check the string for errors
    func checkForErrors(infix: String) -> Bool {
        
        //check for parentheses/bracket/brace errors
        let leftPar = infix.components(separatedBy: "(")
        let leftBrace = infix.components(separatedBy: "{")
        let leftBracket = infix.components(separatedBy: "[")
        let rightPar = infix.components(separatedBy: ")")
        let rightBrace = infix.components(separatedBy: "}")
        let rightBracket = infix.components(separatedBy: "]")
        if leftPar.count + leftBrace.count + leftBracket.count != rightPar.count + rightBrace.count + rightBracket.count {
            return true
        }
        
        var previousItem = ""
        //check for illegal operations
        for item in infix.characters{
            
            switch(item){
            case "0"..."9",".":               //number
                break
            case "+","-","*","/","%","^","!":     //operator
                break
            case "(",")","[","]","{","}":   //parenthesis, bracket, brace
                break
            default:                    //anything else is an illegal operation
                return true
            }
        }
        
        //check that the last character isn't an operator
        if !infix.isEmpty {
            if e.isOperator(symbol: infix.characters.last!) {
                return true
            }
        }
        
        
        //check that there arent two operators in a row
        
        
        //if you've made it this far, you're golden
        return false
    }
    
}
