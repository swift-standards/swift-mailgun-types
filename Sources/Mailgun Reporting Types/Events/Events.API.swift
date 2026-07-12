//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Foundation
import Mailgun_Types_Shared
import RFC_2822

// Comma-separated-list conversions, resolved at file scope. These replace the retired
// `Many { Prefix { $0 != "," } … } separator: { "," }` engine spellings (not vended on
// the institute routing surface) with equivalent split/join conversions — the same
// class as the `Date.UnixEpoch.conversion` bridge.
private typealias RecipientsConversion = Parser.Conversion.Witness<String, [EmailAddress], Parser.Conversion.Error>
private typealias TagsConversion = Parser.Conversion.Witness<String, [String], Never>
private typealias QueryConversionError = Parser.Conversion.Error

/// Comma-separated `recipients` query value ⇆ `[EmailAddress]`.
private var recipientsConversion: RecipientsConversion {
    RecipientsConversion(
        apply: { (raw: String) throws(QueryConversionError) -> [EmailAddress] in
            var addresses: [EmailAddress] = []
            for part in raw.split(separator: ",") {
                guard let address = EmailAddress(rawValue: String(part)) else {
                    throw QueryConversionError.unrepresentable
                }
                addresses.append(address)
            }
            return addresses
        },
        unapply: { (addresses: [EmailAddress]) -> String in
            addresses.map(\.rawValue).joined(separator: ",")
        }
    )
}

/// Comma-separated `tags` query value ⇆ `[String]`.
private var tagsConversion: TagsConversion {
    TagsConversion(
        apply: { (raw: String) -> [String] in
            raw.split(separator: ",").map(String.init)
        },
        unapply: { (tags: [String]) -> String in
            tags.joined(separator: ",")
        }
    )
}

extension Mailgun.Reporting.Events {
    @Cases
    public enum API: Equatable, Sendable {
        case list(
            domain: Domain,
            query: Mailgun.Reporting.Events.List.Query?
        )
    }
}

extension Mailgun.Reporting.Events.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Reporting.Events.API> {
            OneOf {
                URLRouting.Route(
                    .convert(
                        apply: { (domain: $0.0, query: $0.1) },
                        unapply: { ($0.domain, $0.query) }
                    )
                    .map(.case(Mailgun.Reporting.Events.API.cases.list))
                ) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.events
                    // The memberwise query group is built inline (not behind a standalone
                    // `ParserPrinter` wrapper): the group's `Parser.Converted` failure is an
                    // `Either`, which only collapses to the routing error at the enclosing
                    // `Route` node — a wrapper's pinned `Failure` cannot express it.
                    Optionally {
                        Parse(
                            .convert(
                                apply: {
                                    (
                                        $0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0,  // begin
                                        $0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.1,  // end
                                        $0.0.0.0.0.0.0.0.0.0.0.0.0.0.1,  // ascending
                                        $0.0.0.0.0.0.0.0.0.0.0.0.0.1,  // limit
                                        $0.0.0.0.0.0.0.0.0.0.0.0.1,  // event
                                        $0.0.0.0.0.0.0.0.0.0.0.1,  // list
                                        $0.0.0.0.0.0.0.0.0.0.1,  // attachment
                                        $0.0.0.0.0.0.0.0.0.1,  // from
                                        $0.0.0.0.0.0.0.0.1,  // messageId
                                        $0.0.0.0.0.0.0.1,  // subject
                                        $0.0.0.0.0.0.1,  // to
                                        $0.0.0.0.0.1,  // size
                                        $0.0.0.0.1,  // recipient
                                        $0.0.0.1,  // recipients
                                        $0.0.1,  // tags
                                        $0.1  // severity
                                    )
                                },
                                unapply: {
                                    // swift-format-ignore
                                    ((((((((((((((($0.0, $0.1), $0.2), $0.3), $0.4), $0.5), $0.6), $0.7), $0.8), $0.9), $0.10), $0.11), $0.12), $0.13), $0.14), $0.15)
                                }
                            )
                            .map(
                                .memberwise(
                                    Mailgun.Reporting.Events.List.Query.init,
                                    {
                                        (
                                            $0.begin, $0.end, $0.ascending, $0.limit, $0.event, $0.list,
                                            $0.attachment, $0.from, $0.messageId, $0.subject, $0.to,
                                            $0.size, $0.recipient, $0.recipients, $0.tags, $0.severity
                                        )
                                    }
                                )
                            )
                        ) {
                            URLRouting.Query {
                                Optionally {
                                    Field("begin") {
                                        Parse(.string.map(Date.UnixEpoch.conversion))
                                    }
                                }
                                Optionally {
                                    Field("end") {
                                        Parse(.string.map(Date.UnixEpoch.conversion))
                                    }
                                }
                                Optionally {
                                    Field("ascending") {
                                        Parse(
                                            .string.representing(
                                                Mailgun.Reporting.Events.List.Query.Ascending.self
                                            )
                                        )
                                    }
                                }
                                Optionally {
                                    Field("limit") { Int.parser() }
                                }
                                Optionally {
                                    Field("event") {
                                        Parse(.string.representing(Mailgun.Reporting.Events.Event.Variant.self))
                                    }
                                }
                                Optionally {
                                    Field("list") { Parse(.string) }
                                }
                                Optionally {
                                    Field("attachment") { Parse(.string) }
                                }
                                Optionally {
                                    Field("from") { Parse(.string.representing(EmailAddress.self)) }
                                }
                                Optionally {
                                    Field("message-id") { Parse(.string) }
                                }
                                Optionally {
                                    Field("subject") { Parse(.string) }
                                }

                                Optionally {
                                    Field("to") {
                                        Parse(.string.representing(EmailAddress.self))
                                    }
                                }
                                Optionally {
                                    Field("size") { Int.parser() }
                                }
                                Optionally {
                                    Field("recipient") {
                                        Parse(.string.representing(EmailAddress.self))
                                    }
                                }
                                Optionally {
                                    Field("recipients") {
                                        Parse(.string.map(recipientsConversion))
                                    }
                                }
                                Optionally {
                                    Field("tags") {
                                        Parse(.string.map(tagsConversion))
                                    }
                                }
                                Optionally {
                                    Field("severity") {
                                        Parse(
                                            .string.representing(
                                                Mailgun.Reporting.Events.List.Query.Severity.self
                                            )
                                        )
                                    }
                                }

                            }
                        }
                    }
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    public static var events: Path<PathBuilder.Component<String>> { Path {
        "events"
    } }
}
