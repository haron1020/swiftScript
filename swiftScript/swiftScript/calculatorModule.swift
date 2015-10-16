//
//  calculatorModule.swift
//  swiftScript
//
//  Created by Andrey Nazarov on 16.10.15.
//  Copyright © 2015 Andrey Nazarov. All rights reserved.
//

import Foundation

enum ErrorType:Int {
    case noError = 0
    case syntaxError = 1
    case bracketsError = 2
}

enum Priority:Int {
    case trig = 10
    case exp = 8
    case multiply = 6
    case adding = 4
    case bracket = 2
    case operand = 0
}

class Node<T> {
    var next:Node? = nil
    var key:T? = nil
    var priority:Priority? = nil
}

class Stack<T> {
    var head:Node<T>? = nil
    var size:Int = 0
    func push(key:T, priority:Priority) {
        if head != nil {
            let temp = Node<T>()
            temp.key = key
            temp.next = head
            head = temp
            temp.priority = priority
        } else {
            head = Node()
            head!.key = key
            head!.priority = priority
        }
        size++
    }
    func pop() -> T? {
        if size != 0 {
            let temp = head!.key
            let ptr = head
            head = head?.next
            ptr?.next = nil
            size--
            return temp!
        }
        return nil
    }
    func isEmpty()->Bool {
        return head == nil
    }
    func seek()->Int? {
        if let head = head{
            return head.priority!.rawValue
        }
        return 0
    }
}

class CalculatorBody {
    
    private var inputString = ""
    private var postfixString = ""
    private let operationsStack = Stack<String>()
    private let calculatingStack = Stack<Double>()
    private var result = 0.0
    
    func binaryOperation (fn:(Double, Double) -> Double) -> Double {
        let arg2 = calculatingStack.pop()
        let arg1 = calculatingStack.pop()
        return fn(arg1!, arg2!)
    }
    
    func set(input:String) {
        inputString = input
    }
    
    func getResult()->Double {
        return result
    }
    
    func evaluate()->ErrorType {
        let error = stringToPostfix()
        if error != ErrorType.noError {
            return error
        }
        result = calc()!
        return ErrorType.noError
    }
    
    func stringToPostfix()->ErrorType{
        inputString = inputString.stringByReplacingOccurrencesOfString(" ", withString: "")//delete spaces
        var token = ""
        for s in inputString.characters {
            switch s {
            case s where (s >= "0" && s <= "9"):
                token.append(s)
            case "*","/":
                if token == "" {
                    return ErrorType.syntaxError
                }
                postfixString = postfixString + token + " "
                token = ""
                if Priority.multiply.rawValue <= operationsStack.seek() {
                    while !operationsStack.isEmpty() {
                        postfixString = postfixString + operationsStack.pop()! + " "
                    }
                }
                operationsStack.push(String(s), priority: Priority.multiply)
            case "+","-":
                if token == "" {
                    return ErrorType.syntaxError
                }
                postfixString = postfixString + token + " "
                token = ""
                if Priority.adding.rawValue <= operationsStack.seek() {
                    while !operationsStack.isEmpty() {
                        postfixString = postfixString + operationsStack.pop()! + " "
                    }
                }
                operationsStack.push(String(s), priority: Priority.adding)
            case ".":
                if token.rangeOfString(".") != nil {
                    return ErrorType.syntaxError
                }
                token = token + "."
            default:
                break
            }
        }
        postfixString = postfixString + token
        while !operationsStack.isEmpty() {
            postfixString = postfixString + " " + operationsStack.pop()!
        }
        return ErrorType.noError
    }
    
    func calc() -> Double? {
        let tempString = postfixString.componentsSeparatedByString(" ")
        for item in tempString {
            switch item {
            case "+":
                calculatingStack.push(self.binaryOperation(+), priority: Priority.operand)
            case "*":
                calculatingStack.push(self.binaryOperation(*), priority: Priority.operand)
            case "/":
                calculatingStack.push(self.binaryOperation(/), priority: Priority.operand)
            case "-":
                calculatingStack.push(self.binaryOperation(-), priority: Priority.operand)
            default:
                calculatingStack.push(Double(item)!, priority: Priority.operand)
            }
        }
        return calculatingStack.pop()
    }
}

