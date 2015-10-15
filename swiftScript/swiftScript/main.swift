#!/usr/bin/env xcrun swift
//
//  main.swift
//  swiftScript
//
//  Created by Andrey Nazarov on 06.10.15.
//  Copyright © 2015 Andrey Nazarov. All rights reserved.
//

import Foundation

enum Priority:Int {
    case trig = 10
    case exp = 8
    case multiply = 6
    case adding = 4
    case bracket = 2
    case operand = 0
}
enum Kind {
    case operand
    case operation
}

class Node<T> {
    var _next:Node? = nil
    var _key:T? = nil
    var _priority:Priority? = nil
    var _kind:Kind? = nil
}
class Stack<T> {
    var _head:Node<T>? = nil
    var _size:Int = 0
    func push(key:T, priority:Priority, kind:Kind) {
        if _head != nil {
            let temp = Node<T>()
            temp._key = key
            temp._next = _head
            _head = temp
            temp._priority = priority
            temp._kind = kind
        } else {
            _head = Node()
            _head!._key = key
            _head!._priority = priority
            _head!._kind = kind
        }
        _size++
    }
    func pop() -> T? {
        if _size != 0 {
            let temp = _head!._key
            let ptr = _head
            _head = _head?._next
            ptr?._next = nil
            _size--
            return temp!
        }
        return nil
    }
    func isEmpty()->Bool {
        return _head == nil
    }
    func seek()->Int? {
        if _head != nil {
            return _head?._priority?.rawValue
        }
        return 0
    }
}

func strToRpn(input:String)->String?{//returns nil if error
    var result = ""
    let operations = Stack<String>()
    var token = ""
    for s in input.characters {
        switch s {
        case s where (s >= "0" && s <= "9"):
            token.append(s)
        case "*","/":
            if token == "" {
                return nil
            }
            result = result + token + " "
            token = ""
            if Priority.multiply.rawValue <= operations.seek() {
                while !operations.isEmpty() {
                    result = result + operations.pop()! + " "
                }
            }
            operations.push(String(s), priority: Priority.multiply, kind:Kind.operation)
        case "+","-":
            if token == "" {
                return nil
            }
            result = result + token + " "
            token = ""
            if Priority.adding.rawValue <= operations.seek() {
                while !operations.isEmpty() {
                    result = result + operations.pop()! + " "
                }
            }
            operations.push(String(s), priority: Priority.adding, kind:Kind.operation)
        case ".":
            if token.rangeOfString(".") != nil {
                return nil
            }
            token = token + "."
        default:
            break
        }
    }
    result = result + token
    while !operations.isEmpty() {
        result = result + " " + operations.pop()!
    }
    return result
}
func calc(RPN: String) -> Double? {
    let calculatingStack = Stack<Double>()
    let myStringArr = RPN.componentsSeparatedByString(" ")
    for item in myStringArr {
        switch item {
            case "+":
                calculatingStack.push(calculatingStack.pop()! + calculatingStack.pop()!, priority: Priority.operand, kind: Kind.operand)
            case "*":
                calculatingStack.push(calculatingStack.pop()! * calculatingStack.pop()!, priority: Priority.operand, kind: Kind.operand)
            case "/":
                calculatingStack.push(calculatingStack.pop()! / calculatingStack.pop()!, priority: Priority.operand, kind: Kind.operand)
            case "-":
                calculatingStack.push((-1)*calculatingStack.pop()! + calculatingStack.pop()!, priority: Priority.operand, kind: Kind.operand)
            
        default:
            calculatingStack.push(Double(item)!, priority: Priority.operand, kind: Kind.operand)
        }
    }
    return calculatingStack.pop()
}


//dump(Process.arguments)
//var input = Process.arguments[1]
var input = "123-123-1-23-123-123-12-31-23-123-12-31-23-123-12-31-23-234-5-2345-2345-234-523-45-2345-3245-2345-2345234-5234-5234-5324-5234-523-4523-4523-45-2345-3245-234523-4523-45-3425-2345-324523-45-2345-2345-234-5-3"
input = input.stringByReplacingOccurrencesOfString(" ", withString: "")//delete spaces
let x = strToRpn(input)
if x != nil {
    print(calc(x!)!)
}
else {
    print("Syntax error")
}




