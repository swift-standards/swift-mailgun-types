//
//  File.swift
//  swift-mailgun-types
//
//  Created by Coen ten Thije Boonkkamp on 02/08/2025.
//

import Foundation
import HTML_Form_Coder_Codable
import HTML_Standard
import URLRouting

extension HTML.Form.Coder.Decoder {
    public static var mailgun: HTML.Form.Coder.Decoder {
        return HTML.Form.Coder.Decoder(
            dataDecodingStrategy: .base64,
            dateDecodingStrategy: .init { dateString in
                if let date = rfc2822Formatter.date(from: dateString) {
                    return date
                }

                if let timestamp = Double(dateString) {
                    return Date(timeIntervalSince1970: timestamp)
                }

                if let date = ISO8601DateFormatter().date(from: dateString) {
                    return date
                }

                return nil
            },
            arrayParsingStrategy: .brackets
        )
    }

    public static var mailgunRoutes: HTML.Form.Coder.Decoder {
        return HTML.Form.Coder.Decoder(
            dataDecodingStrategy: .base64,
            dateDecodingStrategy: .init { dateString in
                if let date = rfc2822Formatter.date(from: dateString) {
                    return date
                }

                if let timestamp = Double(dateString) {
                    return Date(timeIntervalSince1970: timestamp)
                }

                if let date = ISO8601DateFormatter().date(from: dateString) {
                    return date
                }

                return nil
            },
            arrayParsingStrategy: .accumulateValues
        )
    }
}

extension HTML.Form.Coder.Encoder {
    public static var mailgun: HTML.Form.Coder.Encoder {
        return HTML.Form.Coder.Encoder(
            dataEncodingStrategy: .base64,
            dateEncodingStrategy: .init { rfc2822Formatter.string(from: $0) },
            arrayEncodingStrategy: .brackets
        )
    }

    public static var mailgunRoutes: HTML.Form.Coder.Encoder {
        return HTML.Form.Coder.Encoder(
            dataEncodingStrategy: .base64,
            dateEncodingStrategy: .init { rfc2822Formatter.string(from: $0) },
            arrayEncodingStrategy: .accumulateValues
        )
    }

    public static var mailgunEvents: HTML.Form.Coder.Encoder {
        return HTML.Form.Coder.Encoder(
            dataEncodingStrategy: .base64,
            dateEncodingStrategy: .init { date in
                // Convert to Unix timestamp (epoch time) for Mailgun Events API
                String(Int(date.timeIntervalSince1970))
            },
            arrayEncodingStrategy: .accumulateValues
        )
    }
}

private let rfc2822Formatter: DateFormatter = {
    let rfc2822Formatter = DateFormatter()
    rfc2822Formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
    rfc2822Formatter.locale = Locale(identifier: "en_US_POSIX")
    rfc2822Formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return rfc2822Formatter
}()
