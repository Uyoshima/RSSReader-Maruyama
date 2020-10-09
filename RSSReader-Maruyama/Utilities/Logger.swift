//
//  Logger.swift
//  RSSReader-Maruyama
//
//  Created by 丸山翔 on 2020/09/16.
//  Copyright © 2020 丸山翔. All rights reserved.
//

import Foundation

public struct Logger {
    private static let DATE_FORMAT = "yyyy/MM/dd HH:mm:ss"
    
    public enum LogLevel: String {
        case verbose
        case debug
        case info
        case warn
        case error
    }
    
    public static func verbose(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        printToConsole(logLevel: .verbose, file: file, function: function, line: line, message: message)
    }
    
    public static func debug(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        printToConsole(logLevel: .debug, file: file, function: function, line: line, message: message)
    }
    
    public static func info(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        printToConsole(logLevel: .info, file: file, function: function, line: line, message: message)
    }
    
    public static func warn(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        printToConsole(logLevel: .warn, file: file, function: function, line: line, message: message)
    }
    
    public static func error(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        printToConsole(logLevel: .error, file: file, function: function, line: line, message: message)
        assertionFailure(message)
    }
    
    private static func printToConsole(logLevel: LogLevel, file:String, function: String, line: Int, message: String) {
        #if DEBUG
        print("\(Date().formatted(format: DATE_FORMAT)) [\(logLevel.rawValue.uppercased())] \(file.fileName).\(function) #\(line): \(message)")
        #endif
    }
}
