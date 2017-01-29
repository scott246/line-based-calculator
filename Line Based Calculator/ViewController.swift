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
    logarithms
    trigonometric functions
    square roots
 add support for negative numbers
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
    
    //whenever the input is changed, adjust the answer accordingly
    func textViewDidChange(_ textView: UITextView) {
        print("~~~~INPUT RECEIVED~~~~")
        expression = textView.text
        if expression.isEmpty {
            output.text = String(Double(0))
        }
        let ec = ErrorCheck()
        if (ec.checkForErrors(infix: expression)) {
            output.text = String(Double.nan)
        } else {
            let e = Evaluate()
            output.text = String(e.postfixEvaluate(postfix: e.convertToRPN(infix: expression)))
        }
        
        print("~~~~PARSING COMPLETE~~~~")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

