//
//  Logger.swift
//
//  Created by Naoto Takahashi on 2023/04/21.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

import SkyWayCore

final class Logger {
    static func trace(
        message: String,
        filename: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        SKWLoggerWrapper.traceLog(
            withMessage: message,
            filename: filename,
            function: function,
            line: Int32(line)
        )
    }

    static func debug(
        message: String,
        filename: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        SKWLoggerWrapper.debugLog(
            withMessage: message,
            filename: filename,
            function: function,
            line: Int32(line)
        )
    }

    static func info(
        message: String,
        filename: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        SKWLoggerWrapper.infoLog(
            withMessage: message,
            filename: filename,
            function: function,
            line: Int32(line)
        )
    }

    static func warn(
        message: String,
        filename: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        SKWLoggerWrapper.warnLog(
            withMessage: message,
            filename: filename,
            function: function,
            line: Int32(line)
        )
    }

    static func error(
        message: String,
        filename: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        SKWLoggerWrapper.errorLog(
            withMessage: message,
            filename: filename,
            function: function,
            line: Int32(line)
        )
    }
}
