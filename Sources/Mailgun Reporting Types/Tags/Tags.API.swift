//
//  Tags.API.swift
//  swift-mailgun
//
//  Created by Claude on 31/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Reporting.Tags {
    @Cases
    public enum API: Equatable, Sendable {
        case list(domain: Domain, request: Mailgun.Reporting.Tags.List.Request?)
        case get(domain: Domain, tag: String)
        case update(domain: Domain, tag: String, request: Mailgun.Reporting.Tags.Update.Request)
        case delete(domain: Domain, tag: String)
        case stats(domain: Domain, tag: String, request: Mailgun.Reporting.Tags.Stats.Request)
        case aggregates(
            domain: Domain,
            tag: String,
            request: Mailgun.Reporting.Tags.Aggregates.Request
        )
        case limits(domain: Domain)
    }
}

extension Mailgun.Reporting.Tags.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Reporting.Tags.API> {
            OneOf {
                // List tags
                Route(
                    .convert(
                        apply: { (domain: $0.0, request: $0.1) },
                        unapply: { ($0.domain, $0.request) }
                    )
                    .map(.case(Mailgun.Reporting.Tags.API.cases.list))
                ) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.tags
                    Optionally {
                        Parse(.memberwise(Mailgun.Reporting.Tags.List.Request.init, { ($0.page, $0.limit) })) {
                            Query {
                                Optionally {
                                    Field("page") { Parse(.string) }
                                }
                                Optionally {
                                    Field("limit") { Int.parser() }
                                }
                            }
                        }
                    }
                }

                // Get a tag
                Route(
                    .convert(
                        apply: { (domain: $0.0, tag: $0.1) },
                        unapply: { ($0.domain, $0.tag) }
                    )
                    .map(.case(Mailgun.Reporting.Tags.API.cases.get))
                ) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.tag
                    Query {
                        Field("tag") { Parse(.string) }
                    }
                }

                // Update tag description
                Route(
                    .convert(
                        apply: { (domain: $0.0.0, tag: $0.0.1, request: $0.1) },
                        unapply: { (($0.domain, $0.tag), $0.request) }
                    )
                    .map(.case(Mailgun.Reporting.Tags.API.cases.update))
                ) {
                    Method.put
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.tag
                    Query {
                        Field("tag") { Parse(.string) }
                    }
                    Parse(.memberwise(Mailgun.Reporting.Tags.Update.Request.init, { $0.description })) {
                        Query {
                            Field("description") { Parse(.string) }
                        }
                    }
                }

                // Delete tag
                Route(
                    .convert(
                        apply: { (domain: $0.0, tag: $0.1) },
                        unapply: { ($0.domain, $0.tag) }
                    )
                    .map(.case(Mailgun.Reporting.Tags.API.cases.delete))
                ) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.tag
                    Query {
                        Field("tag") { Parse(.string) }
                    }
                }

                // Get tag stats
                Route(
                    .convert(
                        apply: { (domain: $0.0.0, tag: $0.0.1, request: $0.1) },
                        unapply: { (($0.domain, $0.tag), $0.request) }
                    )
                    .map(.case(Mailgun.Reporting.Tags.API.cases.stats))
                ) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.tag
                    Path.stats
                    Query {
                        Field("tag") { Parse(.string) }
                    }
                    Parse(
                        .convert(
                            apply: { (
                                $0.0.0.0.0.0.0.0,
                                $0.0.0.0.0.0.0.1,
                                $0.0.0.0.0.0.1,
                                $0.0.0.0.0.1,
                                $0.0.0.0.1,
                                $0.0.0.1,
                                $0.0.1,
                                $0.1
                            ) },
                            unapply: { ((((((($0.0, $0.1), $0.2), $0.3), $0.4), $0.5), $0.6), $0.7) }
                        )
                        .map(
                            .memberwise(
                                Mailgun.Reporting.Tags.Stats.Request.init,
                                { ($0.event, $0.start, $0.end, $0.resolution, $0.duration, $0.provider, $0.device, $0.country) }
                            )
                        )
                    ) {
                        Query {
                            Field("event") {
                                // Comma-separated list ⇆ [String]; replaces the retired
                                // `Many { Parse(.string) }` engine spelling (not vended
                                // on the institute routing surface).
                                Parse(
                                    .string.map(
                                        Parser.Conversion.Witness<String, [String], Never>(
                                            apply: { (raw: String) -> [String] in
                                                raw.split(separator: ",").map(String.init)
                                            },
                                            unapply: { (events: [String]) -> String in
                                                events.joined(separator: ",")
                                            }
                                        )
                                    )
                                )
                            }
                            Optionally {
                                Field("start") { Parse(.string) }
                            }
                            Optionally {
                                Field("end") { Parse(.string) }
                            }
                            Optionally {
                                Field("resolution") { Parse(.string) }
                            }
                            Optionally {
                                Field("duration") { Parse(.string) }
                            }
                            Optionally {
                                Field("provider") { Parse(.string) }
                            }
                            Optionally {
                                Field("device") { Parse(.string) }
                            }
                            Optionally {
                                Field("country") { Parse(.string) }
                            }
                        }
                    }
                }

                // Get tag aggregates
                Route(
                    .convert(
                        apply: { (domain: $0.0.0, tag: $0.0.1, request: $0.1) },
                        unapply: { (($0.domain, $0.tag), $0.request) }
                    )
                    .map(.case(Mailgun.Reporting.Tags.API.cases.aggregates))
                ) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.tag
                    Path.stats
                    Path.aggregates
                    Query {
                        Field("tag") { Parse(.string) }
                    }
                    Parse(.memberwise(Mailgun.Reporting.Tags.Aggregates.Request.init, { $0.type })) {
                        Query {
                            Field("type") { Parse(.string) }
                        }
                    }
                }

                // Get tag limits
                Route(.case(Mailgun.Reporting.Tags.API.cases.limits)) {
                    Method.get
                    Path { "v3" }
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.limits
                    Path.tag
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    public static var tags: Path<PathBuilder.Component<String>> { Path {
        "tags"
    } }

    public static var tag: Path<PathBuilder.Component<String>> { Path {
        "tag"
    } }

    public static var domains: Path<PathBuilder.Component<String>> { Path {
        "domains"
    } }

    public static var limits: Path<PathBuilder.Component<String>> { Path {
        "limits"
    } }
}
