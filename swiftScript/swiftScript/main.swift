#!/usr/bin/env xcrun swift
//
//  main.swift
//  swiftScript
//
//  Created by Andrey Nazarov on 06.10.15.
//  Copyright © 2015 Andrey Nazarov. All rights reserved.
//

import Foundation

dump(Process.arguments)
var input:String = Process.arguments[1]
input.removeAtIndex(input.characters.indexOf(" ")!)
dump(input)

enum Types {
    case binaryOperation(op: String, fn: (Double, Double) -> Double)
    case argument(op: String)
    case unaryOperation(op: String, fn:(Double) -> Double)
    case const(Op: String -> Double)
    case function(op: String, fn: (Double) -> Double)
}

class Node {
    var key:String?
    var left:Node?
    var right:Node?
    var parent:Node?
    init() {
        self.left = nil
        self.right = nil
        self.key = nil
        self.parent = nil
    }
}

class Tree {
    var root: Node?
    init() {
        root = nil
    }
    func isEmpty() -> Bool {
        if self.root == nil {
            return true
        }
        return false
    }
  
}

var myTree = Tree()
print(myTree.isEmpty())
//myTree.addNode(input)

print("Input is: \(input)" )