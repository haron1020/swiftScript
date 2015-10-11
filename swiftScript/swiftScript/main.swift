#!/usr/bin/env xcrun swift
//
//  main.swift
//  swiftScript
//
//  Created by Andrey Nazarov on 06.10.15.
//  Copyright © 2015 Andrey Nazarov. All rights reserved.
//

import Foundation

enum Types {
    case binaryOperation
    case argument
    case unaryOperation(op: String, fn:(Double) -> Double)
    case const(Op: String -> Double)
    //case function(op: String, fn: (Double) -> Double)
}
class Node {
    var key:String=""
    var kind:Types?
    var left:Node?
    var right:Node?
    var parent:Node?
    init(){}
}
/*
MODES:
0 - need parent
1 - need left
2 - need right
*/
class Tree {
    var root: Node?
    var mode: Int=0
    init() {}
    func isEmpty() -> Bool {
       return self.root == nil
    }
    func checkNodes(){
        if root == nil {
            root = Node()
            mode++
        }
        switch mode {
        case 0:
            break
        case 1:
            root?.left = Node()
        case 2:
            root?.right = Node()
        default:
            break
        }
        mode = (mode+1)%3
    }
    
    func getToken(input: String) -> Bool {// returns false if error
        self.checkNodes()
        for s in input.characters {
            switch s {
            case s where s >= "0" && s <= "9":
                if mode == 0 {
                    root!.right!.key.append(s)
                    root!.right!.kind = Types.argument
                    root!.right!.parent = root
                }
                if mode == 2 {
                    root!.left!.key.append(s)
                    root!.left!.kind = Types.argument
                    root!.left!.parent = root
                }
                break
            case ".":
                if mode == 0 {
                    if root!.right!.key.rangeOfString(".") != nil {
                        return false
                    }
                    root!.right!.key.append(s)
                    root!.right!.kind = Types.argument
                    root!.right!.parent = root
                }
                if mode == 2 {
                    if root!.left!.key.rangeOfString(".") != nil {
                        return false
                    }
                    root!.left!.key.append(s)
                    root!.left!.kind = Types.argument
                    root!.left!.parent = root
                }
                break
                
            case "+":
                root!.key = "+"
                self.checkNodes()
                root?.kind = Types.binaryOperation
            case "-":
                root!.key = "-"
                self.checkNodes()
                root?.kind = Types.binaryOperation
            default:
                break
            }
        }
        return true
    }
    func calc() {
        switch root!.key {
        case "+":
            root!.key = String(Double((root!.left!.key))! + Double(root!.right!.key)!)
        case "-":
            root!.key = String(Double((root!.left!.key))! - Double(root!.right!.key)!)
        default:
            break
        }
        root!.kind = Types.argument
    }
}

//dump(Process.arguments)
var input = Process.arguments[1]
input = input.stringByReplacingOccurrencesOfString(" ", withString: "")
print("Input is: \(input)" )

var myTree = Tree()
myTree.getToken(input)
myTree.calc()
print(myTree.root!.key)


