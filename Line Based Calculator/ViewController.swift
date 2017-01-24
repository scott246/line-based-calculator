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
    
    //add a character to the end of the entire expression
    func addToExpression(character:String){
        if character == "" && !expression.isEmpty {//backspace
            expression.remove(at: expression.index(before: expression.endIndex))
        }
        else {
            expression += character
        }
    }

    
    //whenever the input is changed, adjust the answer accordingly
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("~~~~INPUT RECEIVED~~~~")
        addToExpression(character: text)
        let ec = ErrorCheck()
        if (ec.checkForErrors(infix: expression)) {
            output.text = String(Double.nan)
        } else {
            let e = Evaluate()
            output.text = String(e.postfixEvaluate(postfix: e.convertToRPN(infix: expression)))
        }
        
        print("~~~~PARSING COMPLETE~~~~")
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

