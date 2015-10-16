#!/usr/bin/env xcrun swift
//
//  main.swift
//  swiftScript
//
//  Created by Andrey Nazarov on 06.10.15.
//  Copyright © 2015 Andrey Nazarov. All rights reserved.
//

import Foundation



//dump(Process.arguments)
//var input = Process.arguments[1]

var input : String? = "(1+2)*3"

var myCalc : CalculatorBody? = CalculatorBody()
myCalc!.set(input!)
myCalc!.evaluate()
print(myCalc!.getResult())

myCalc = nil
input = nil



