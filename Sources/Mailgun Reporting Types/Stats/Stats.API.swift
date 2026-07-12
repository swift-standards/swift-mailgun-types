//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Reporting.Stats {
    @Cases
    public enum API: Equatable, Sendable {
        case total(request: Mailgun.Reporting.Stats.Total.Request)
        case filter(request: Mailgun.Reporting.Stats.Filter.Request)
        case aggregateProviders(domain: Domain)
        case aggregateDevices(domain: Domain)
        case aggregateCountries(domain: Domain)
    }
}

extension Mailgun.Reporting.Stats.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Reporting.Stats.API> {
            OneOf {
                URLRouting.Route(.case(Mailgun.Reporting.Stats.API.cases.total)) {
                    Method.get
                    Path { "v3" }
                    Path.stats
                    Path.total
                    Parse(
                        .convert(
                            apply: { ($0.0.0.0.0, $0.0.0.0.1, $0.0.0.1, $0.0.1, $0.1) },
                            unapply: { (((($0.0, $0.1), $0.2), $0.3), $0.4) }
                        )
                        .map(
                            .memberwise(
                                Mailgun.Reporting.Stats.Total.Request.init,
                                { ($0.event, $0.start, $0.end, $0.resolution, $0.duration) }
                            )
                        )
                    ) {
                        URLRouting.Query {
                            Field("event") { Parse(.string) }
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
                        }
                    }
                }

                URLRouting.Route(.case(Mailgun.Reporting.Stats.API.cases.filter)) {
                    Method.get
                    Path { "v3" }
                    Path.stats
                    Path { "filter" }
                    Parse(
                        .convert(
                            apply: { (
                                $0.0.0.0.0.0.0,
                                $0.0.0.0.0.0.1,
                                $0.0.0.0.0.1,
                                $0.0.0.0.1,
                                $0.0.0.1,
                                $0.0.1,
                                $0.1
                            ) },
                            unapply: { (((((($0.0, $0.1), $0.2), $0.3), $0.4), $0.5), $0.6) }
                        )
                        .map(
                            .memberwise(
                                Mailgun.Reporting.Stats.Filter.Request.init,
                                { ($0.event, $0.start, $0.end, $0.resolution, $0.duration, $0.filter, $0.group) }
                            )
                        )
                    ) {
                        URLRouting.Query {
                            Field("event") { Parse(.string) }
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
                                Field("filter") { Parse(.string) }
                            }
                            Optionally {
                                Field("group") { Parse(.string) }
                            }
                        }
                    }
                }

                URLRouting.Route(.case(Mailgun.Reporting.Stats.API.cases.aggregateProviders)) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.aggregates
                    Path.providers
                }

                URLRouting.Route(.case(Mailgun.Reporting.Stats.API.cases.aggregateDevices)) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.aggregates
                    Path.devices
                }

                URLRouting.Route(.case(Mailgun.Reporting.Stats.API.cases.aggregateCountries)) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.aggregates
                    Path.countries
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    public static var stats: Path<PathBuilder.Component<String>> { Path {
        "stats"
    } }

    public static var total: Path<PathBuilder.Component<String>> { Path {
        "total"
    } }

    public static var filter: Path<PathBuilder.Component<String>> { Path {
        "filter"
    } }

    public static var aggregates: Path<PathBuilder.Component<String>> { Path {
        "aggregates"
    } }

    public static var providers: Path<PathBuilder.Component<String>> { Path {
        "providers"
    } }

    public static var devices: Path<PathBuilder.Component<String>> { Path {
        "devices"
    } }

    public static var countries: Path<PathBuilder.Component<String>> { Path {
        "countries"
    } }
}
