#!/usr/bin/env xcrun swift
//
//  main.swift
//  swiftScript
//
//  Created by Andrey Nazarov on 06.10.15.
//  Copyright © 2015 Andrey Nazarov. All rights reserved.
//

import Foundation

extension String {
    subscript(i: Int) -> String {
        return String(self[self.startIndex.advancedBy(i)])
    }
}

func eraseSpaces(inout arg: String) {
    for (var i = 0; i<arg.characters.count;i++) {
        if arg[i] == " " {
            arg.removeAtIndex(arg.startIndex.advancedBy(i))
            --i
        }
    }
}

enum Types {
    case binaryOperation
    case argument
    case unaryOperation(op: String, fn:(Double) -> Double)
    case const(Op: String -> Double)
    //case function(op: String, fn: (Double) -> Double)
}
class Node {
    var key:String
    var kind:Types?
    var left:Node?
    var right:Node?
    var parent:Node?
    init() {
        self.left = nil
        self.right = nil
        self.key = ""
        self.parent = nil
        kind = nil
    }
}
/*
MODES:
0 - need parent
1 - need left
2 - need right
*/
class Tree {
    var root: Node?
    var mode: Int
    init() {
        root = nil
        mode = 0
    }
    func isEmpty() -> Bool {
        if self.root == nil {
            return true
        }
        return false
    }
    func checkNodes() {
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
    
    func getToken(input: String) {
        self.checkNodes()
        for s in input.characters {
            switch s {
            case "0","1","2","3","4","5","6","7","8","9":
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
//var input = "    3         - 6        9"
eraseSpaces(&input)
print("Input is: \(input)" )

var myTree = Tree()
myTree.getToken(input)
myTree.calc()
print(myTree.root?.key)
