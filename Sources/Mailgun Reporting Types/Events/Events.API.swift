//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Foundation
import Mailgun_Types_Shared
import RFC_2822

extension Mailgun.Reporting.Events {
    @CasePathable
    @dynamicMemberLookup
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
                URLRouting.Route(.case(Mailgun.Reporting.Events.API.list)) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.events
                    Optionally {
                        Mailgun.Reporting.Events.List.Query.Parser()
                    }
                }
            }
        }
    }
}

extension Mailgun.Reporting.Events.List.Query {
    struct Parser: ParserPrinter, Sendable {
        public init() {}
        var body: some ParserPrinter<URLRequestData, Mailgun.Reporting.Events.List.Query> {
            URLRouting.Query {
                Parse(.memberwise(Mailgun.Reporting.Events.List.Query.init)) {
                    Optionally {
                        Field("begin") {
                            Date.UnixEpoch.Parser()
                        }
                    }
                    Optionally {
                        Field("end") {
                            Date.UnixEpoch.Parser()
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
                        Field("limit") { Digits() }
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
                        Field("size") { Digits() }
                    }
                    Optionally {
                        Field("recipient") {
                            Parse(.string.representing(EmailAddress.self))
                        }
                    }
                    Optionally {
                        Field("recipients") {
                            Many {
                                Prefix { $0 != "," }.map(.string.representing(EmailAddress.self))
                            } separator: {
                                ","
                            }
                        }
                    }
                    Optionally {
                        Field("tags") {
                            Many {
                                Prefix { $0 != "," }.map(.string)
                            } separator: {
                                ","
                            }
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

extension Path<PathBuilder.Component<String>> {
    public static var events: Path<PathBuilder.Component<String>> { Path {
        "events"
    } }
}
