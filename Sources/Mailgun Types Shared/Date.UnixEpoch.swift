//
//  Date.UnixEpoch.swift
//  swift-mailgun-types
//
//  Re-homed locally from swift-date-parsing (UnixEpochParsing) — that package is
//  being archived. A conversion bridging unix-epoch-seconds text <-> Foundation.Date,
//  used by the Mailgun Reporting Events query router (begin / end fields).
//
//  Ported onto the institute Parser surface (routing arc W3): dropped `import Parsing`
//  (pointfree) for URLRouting's re-exported Parser primitives; the epoch bridge is a
//  typed-throws `Parser.Conversion.Witness`, lifted at leaves via
//  `Parse(.string.map(Date.UnixEpoch.conversion))` (mirrors the ISO-8601 date pattern
//  used elsewhere in the routing migration).
//

import Foundation
import URLRouting

extension Date {
    public struct UnixEpoch {}
}

extension Date.UnixEpoch {
    /// A conversion bridging unix-epoch-seconds text and `Foundation.Date`.
    ///
    /// Use at a routing leaf via `Parse(.string.map(Date.UnixEpoch.conversion))`.
    public static var conversion: Parser.Conversion.Witness<String, Date, Parser.Conversion.Error> {
        .init(
            apply: { (input: String) throws(Parser.Conversion.Error) -> Date in
                guard let seconds = TimeInterval(input) else {
                    throw Parser.Conversion.Error.unrepresentable
                }
                return Date(timeIntervalSince1970: seconds)
            },
            unapply: { (output: Date) throws(Parser.Conversion.Error) -> String in
                String(Int(output.timeIntervalSince1970))
            }
        )
    }
}
