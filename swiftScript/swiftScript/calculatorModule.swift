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
    func seekHeadKey() -> T? {
        return head != nil ? head!.key : nil
    }
    func seekHeadPriority() -> Priority? {
        return head != nil ? head!.priority : nil
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
    
    func evaluate()->Double?{
        let error = stringToPostfix()
        if errorHandler(error) {
            return 0.0
        }
        result = calc()!
        return result
    }
    
    func errorHandler(error:ErrorType) -> Bool { //returns false if no errors
        switch error {
        case ErrorType.syntaxError:
            print("Syntax Error")
            return true
        case ErrorType.bracketsError:
            print("Mismatched brackets")
            return true
        default:
            break
        }
        return false
    }
    
    func addExpressionToStack(inout token:String, expression:String, expressionPriority:Priority) -> ErrorType {
        if token == ""{
            return ErrorType.syntaxError
        }
        postfixString = postfixString + token + " "
        token = ""
        while !operationsStack.isEmpty() && expressionPriority.rawValue <= operationsStack.seekHeadPriority()?.rawValue{
            postfixString = postfixString + operationsStack.pop()! + " "
        }
        
        operationsStack.push(String(expression), priority: expressionPriority)
        return ErrorType.noError
    }
    
    func bracketHandler() -> ErrorType {
        while operationsStack.seekHeadKey() != "("  && operationsStack.head != nil{
            postfixString = postfixString + operationsStack.pop()! + " "
        }
        operationsStack.pop()
        return ErrorType.noError
    }
    
    func stringToPostfix()->ErrorType{
        inputString = inputString.stringByReplacingOccurrencesOfString(" ", withString: "")//delete spaces
        var token = ""
        var error = ErrorType.noError
        for s in inputString.characters {
            switch s {
            case s where (s >= "0" && s <= "9"):
                token.append(s)
            case "*","/":
                error = addExpressionToStack(&token, expression: String(s), expressionPriority: Priority.multiply)
            case "+","-":
                error = addExpressionToStack(&token, expression: String(s), expressionPriority: Priority.adding)
            case ".":
                if token.rangeOfString(".") != nil {
                    return ErrorType.syntaxError
                }
                token = token + "."
            case "(":
                error = addExpressionToStack(&token, expression: "(", expressionPriority: Priority.bracket)
            case ")":
                error = bracketHandler()
            default:
                break
            }
            if error != ErrorType.noError {
                return error
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

