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

let input = Process.arguments[1]
print("Input is: \(input)" )