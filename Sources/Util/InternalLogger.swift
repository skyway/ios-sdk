//
//  InternalLogger.swift
//
//  Created by Naoto Takahashi on 2023/04/21.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

import SkyWayCore

final class InternalLogger {
    static func trace(
        message: String,
        filename: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        Logger.traceLog(
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
        Logger.debugLog(
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
        Logger.infoLog(
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
        Logger.warnLog(
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
        Logger.errorLog(
            withMessage: message,
            filename: filename,
            function: function,
            line: Int32(line)
        )
    }
}
