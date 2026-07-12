//
//  DynamicIPPools API.swift
//  swift-mailgun-types
//
//  Created by Assistant on 05/08/2025.
//

import Mailgun_Types_Shared

extension Mailgun.DynamicIPPools {
    @Cases
    public enum API: Equatable, Sendable {
        case listHistory(request: Mailgun.DynamicIPPools.HistoryList.Request)
        case removeOverride(domain: String)
    }
}

extension Mailgun.DynamicIPPools.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.DynamicIPPools.API> {
            OneOf {
                URLRouting.Route(.case(Mailgun.DynamicIPPools.API.cases.listHistory)) {
                    Method.get
                    Path { "v1" }
                    Path.dynamicPools
                    Path.history
                    Parse(
                        .convert(
                            apply: { ($0.0.0.0.0.0.0, $0.0.0.0.0.0.1, $0.0.0.0.0.1, $0.0.0.0.1, $0.0.0.1, $0.0.1, $0.1) },
                            unapply: { (((((($0.0, $0.1), $0.2), $0.3), $0.4), $0.5), $0.6) }
                        )
                        .map(
                            .memberwise(
                                Mailgun.DynamicIPPools.HistoryList.Request.init,
                                { ($0.limit, $0.includeSubaccounts, $0.domain, $0.before, $0.after, $0.movedTo, $0.movedFrom) }
                            )
                        )
                    ) {
                        URLRouting.Query {
                            Optionally {
                                Field("Limit") { Int.parser() }
                            }
                            Optionally {
                                Field("include_subaccounts") { Bool.parser() }
                            }
                            Optionally {
                                Field("domain") { Parse(.string) }
                            }
                            Optionally {
                                Field("before") { Parse(.string) }
                            }
                            Optionally {
                                Field("after") { Parse(.string) }
                            }
                            Optionally {
                                Field("moved_to") { Parse(.string) }
                            }
                            Optionally {
                                Field("moved_from") { Parse(.string) }
                            }
                        }
                    }
                }

                URLRouting.Route(.case(Mailgun.DynamicIPPools.API.cases.removeOverride)) {
                    Method.delete
                    Path { "v1" }
                    Path.dynamicPools
                    Path.domains
                    Path { Parse(.string) }
                    Path.override
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    public static var dynamicPools: Path<PathBuilder.Component<String>> { Path {
        "dynamic_pools"
    } }

    public static var history: Path<PathBuilder.Component<String>> { Path {
        "history"
    } }

    public static var override: Path<PathBuilder.Component<String>> { Path {
        "override"
    } }
}
