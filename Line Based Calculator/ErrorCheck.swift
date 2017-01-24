//
//  ErrorCheck.swift
//  Solvr
//
//  Created by Nathan Scott on 1/23/17.
//  Copyright © 2017 Nathan Scott. All rights reserved.
//

import Foundation

class ErrorCheck {
    
    //check the string for errors
    func checkForErrors(infix: String) -> Bool {
        //check for parentheses/bracket/brace errors
        let leftPar = infix.components(separatedBy: "(")
        let leftBrace = infix.components(separatedBy: "{")
        let leftBracket = infix.components(separatedBy: "[")
        let rightPar = infix.components(separatedBy: ")")
        let rightBrace = infix.components(separatedBy: "}")
        let rightBracket = infix.components(separatedBy: "]")
        if leftPar.count + leftBrace.count + leftBracket.count != rightPar.count + rightBrace.count + rightBracket.count {return true}
        
        //check for illegal operations
        for item in infix.unicodeScalars{
            switch(item.value){
            case 48...57:               //number
                break
            case 37,42,43,45,47,94,33:     //operator
                break
            case 40,41,91,93,123,125:   //parenthesis, bracket, brace
                break
            default:                    //anything else is an illegal operation
                return true
            }
        }
        
        //if you've made it this far, you're golden
        return false
    }
    
}
