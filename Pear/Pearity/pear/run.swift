//
//  run.swift
//  pearitycli
//
//  Created by Pierre Segula on 6/5/22.
//  Copyright © 2022 Pear Security. All rights reserved.
//

import Foundation

/// Run command and return the result.
/// - Parameters:
///   - binary: path to bsd executable
///   - arguments: arguments for executable
/// - Returns: runCommandReturnStr waits for execution and returns the result as a String.
@discardableResult
func runCommandReturnStr(binary: String, arguments: [String]) -> String? {
    let file = "file://"
    let process = Process()
    
    process.executableURL = URL(fileURLWithPath: file + binary)
    process.arguments = arguments
    
    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = pipe
    process.qualityOfService = .userInteractive
    process.launch()
    process.waitUntilExit()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
     
    guard
        let output = String(data: data, encoding: String.Encoding.utf8),
        !output.isEmpty
    else {
        return nil
    }
  
    process.terminate()

    // Return the last entry. This gets rid of XPC noise by ctkbind during the pairing process
    if let lastEntry = output.split(whereSeparator: \.isNewline).last {
        return String(lastEntry)
    }
    
    return output
}
