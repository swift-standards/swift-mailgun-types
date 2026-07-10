//
//  Date.UnixEpoch.swift
//  swift-mailgun-types
//
//  Re-homed locally from swift-date-parsing (UnixEpochParsing) — that package is
//  being archived. A ParserPrinter bridging unix-epoch-seconds text <-> Foundation.Date,
//  used by the Mailgun Reporting Events query router (begin / end fields).
//

import Foundation
import Parsing

extension Date {
    public struct UnixEpoch {}
}

extension Date.UnixEpoch {
    public struct Parser: ParserPrinter {

        public init() {}

        public var body: some ParserPrinter<Substring, Date> {
            Rest()
                .map(.string)
                .map(Date.UnixEpoch.Conversion())
        }
    }
}

extension Date.UnixEpoch {
    struct Conversion: Parsing.Conversion {
        public typealias Input = String
        public typealias Output = Date

        public func apply(_ input: String) throws -> Date {
            guard let seconds = TimeInterval(input) else {
                throw Date.UnixEpoch.Conversion.Error.invalidEpoch(input)
            }
            return Date(timeIntervalSince1970: seconds)
        }

        public func unapply(_ output: Date) throws -> String {
            String(Int(output.timeIntervalSince1970))
        }

        public enum Error: Swift.Error {
            case invalidEpoch(String)
        }
    }
}
