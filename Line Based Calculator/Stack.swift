//
//  Stack.swift
//  Solvr
//
//  Created by Nathan Scott on 1/21/17.
//  Copyright © 2017 Nathan Scott. All rights reserved.
//

import Foundation

class Stack<T> {
    private var top: Int
    private var items: [T]
    var size: Int
    
    init(inputtedSize: Int) {
        top = -1
        items = []
        size = inputtedSize
    }
    
    func isFull() -> Bool {
        return (top >= size - 1)
    }
    
    func isEmpty() -> Bool {
        return (top == -1)
    }
    
    func push(item: T) -> Bool {
        if !isFull() {
            top += 1
            items.append(item)
            return true
        }
        return false
    }
    
    func pop() -> T? {
        if !isEmpty() {
            top -= 1
            return items.removeLast()
        }
        return nil
    }
    
    func peek() -> T? {
        if !isEmpty() {
            return items.last
        }
        return nil
    }
    
    func printStack() {
        for i in items {
            print("| \(i) |")
        }
        print("-----")
    }
}
