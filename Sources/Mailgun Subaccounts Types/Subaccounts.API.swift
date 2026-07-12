//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Subaccounts {
    @Cases
    public enum API: Equatable, Sendable {
        case get(subaccountId: String)
        case list(request: Mailgun.Subaccounts.List.Request?)
        case create(request: Mailgun.Subaccounts.Create.Request)
        case delete(subaccountId: String)  // Note: subaccountId goes in header, not path
        case disable(subaccountId: String, request: Mailgun.Subaccounts.Disable.Request?)
        case enable(subaccountId: String)
        case getCustomLimit(subaccountId: String)
        case updateCustomLimit(subaccountId: String, limit: Double)
        case deleteCustomLimit(subaccountId: String)
        case updateFeatures(
            subaccountId: String,
            request: Mailgun.Subaccounts.Features.Update.Request
        )
    }
}

extension Mailgun.Subaccounts.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Subaccounts.API> {
            OneOf {
                URLRouting.Route(.case(Mailgun.Subaccounts.API.cases.get)) {
                    Method.get
                    Path { "v5" }
                    Path.accounts
                    Path.subaccounts
                    Path { Parse(.string) }
                }

                URLRouting.Route(.case(Mailgun.Subaccounts.API.cases.list)) {
                    Method.get
                    Path { "v5" }
                    Path.accounts
                    Path.subaccounts
                    Optionally {
                        Parse(
                            .convert(
                                apply: {
                                    (
                                        $0.0.0.0.0.0, $0.0.0.0.0.1, $0.0.0.0.1, $0.0.0.1, $0.0.1, $0.1
                                    )
                                },
                                unapply: {
                                    ((((($0.0, $0.1), $0.2), $0.3), $0.4), $0.5)
                                }
                            )
                            .map(
                                .memberwise(
                                    Mailgun.Subaccounts.List.Request.init,
                                    { ($0.sort, $0.filter, $0.limit, $0.skip, $0.enabled, $0.closed) }
                                )
                            )
                        ) {
                            URLRouting.Query {
                                Optionally {
                                    Field("sort") {
                                        Parse(
                                            .string.representing(
                                                Mailgun.Subaccounts.List.Request.Sort.self
                                            )
                                        )
                                    }
                                }
                                Optionally {
                                    Field("filter") { Parse(.string) }
                                }
                                Optionally {
                                    Field("limit") { Int.parser() }
                                }
                                Optionally {
                                    Field("skip") { Int.parser() }
                                }
                                Optionally {
                                    Field("enabled") { Bool.parser() }
                                }
                                Optionally {
                                    Field("closed") { Bool.parser() }
                                }
                            }
                        }
                    }
                }

                URLRouting.Route(.case(Mailgun.Subaccounts.API.cases.create)) {
                    Method.post
                    Path { "v5" }
                    Path.accounts
                    Path.subaccounts
                    Parse(.memberwise(Mailgun.Subaccounts.Create.Request.init, { $0.name })) {
                        URLRouting.Query {
                            Field("name") { Parse(.string) }
                        }
                    }
                }

                URLRouting.Route(.case(Mailgun.Subaccounts.API.cases.delete)) {
                    Method.delete
                    Path { "v5" }
                    Path.accounts
                    Path.subaccounts
                    Headers {
                        Field("X-Mailgun-On-Behalf-Of", .string)
                    }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (subaccountId: $0.0, request: $0.1) },
                        unapply: { ($0.subaccountId, $0.request) }
                    )
                    .map(.case(Mailgun.Subaccounts.API.cases.disable))
                ) {
                    Method.post
                    Path { "v5" }
                    Path.accounts
                    Path.subaccounts
                    Path { Parse(.string) }
                    Path.disable
                    Optionally {
                        Parse(.memberwise(Mailgun.Subaccounts.Disable.Request.init, { ($0.reason, $0.note) })) {
                            URLRouting.Query {
                                Optionally {
                                    Field("reason") { Parse(.string) }
                                }
                                Optionally {
                                    Field("note") { Parse(.string) }
                                }
                            }
                        }
                    }
                }

                URLRouting.Route(.case(Mailgun.Subaccounts.API.cases.enable)) {
                    Method.post
                    Path { "v5" }
                    Path.accounts
                    Path.subaccounts
                    Path { Parse(.string) }
                    Path.enable
                }

                URLRouting.Route(.case(Mailgun.Subaccounts.API.cases.getCustomLimit)) {
                    Method.get
                    Path { "v5" }
                    Path.accounts
                    Path.subaccounts
                    Path { Parse(.string) }
                    Path.limit
                    Path.custom
                    Path.monthly
                }

                URLRouting.Route(
                    .convert(
                        apply: { (subaccountId: $0.0, limit: $0.1) },
                        unapply: { ($0.subaccountId, $0.limit) }
                    )
                    .map(.case(Mailgun.Subaccounts.API.cases.updateCustomLimit))
                ) {
                    Method.put
                    Path { "v5" }
                    Path.accounts
                    Path.subaccounts
                    Path { Parse(.string) }
                    Path.limit
                    Path.custom
                    Path.monthly
                    URLRouting.Query {
                        Field("limit") {
                            // No `Double.parser()` on the institute routing surface
                            // (and `URLRouting.Value.init` is internal); bridge via the
                            // same typed-throws witness pattern as the date conversions.
                            Parse(
                                .string.map(
                                    Parser.Conversion.Witness<Swift.String, Double, Parser.Conversion.Error>(
                                        apply: { (raw: Swift.String) throws(Parser.Conversion.Error) -> Double in
                                            guard let value = Double(raw) else {
                                                throw Parser.Conversion.Error.unrepresentable
                                            }
                                            return value
                                        },
                                        unapply: { (value: Double) -> Swift.String in
                                            Swift.String(value)
                                        }
                                    )
                                )
                            )
                        }
                    }
                }

                URLRouting.Route(.case(Mailgun.Subaccounts.API.cases.deleteCustomLimit)) {
                    Method.delete
                    Path { "v5" }
                    Path.accounts
                    Path.subaccounts
                    Path { Parse(.string) }
                    Path.limit
                    Path.custom
                    Path.monthly
                }

                URLRouting.Route(
                    .convert(
                        apply: { (subaccountId: $0.0, request: $0.1) },
                        unapply: { ($0.subaccountId, $0.request) }
                    )
                    .map(.case(Mailgun.Subaccounts.API.cases.updateFeatures))
                ) {
                    Method.put
                    Path { "v5" }
                    Path.accounts
                    Path.subaccounts
                    Path { Parse(.string) }
                    Path.features
                    URLRouting.Body(
                        .form(
                            Mailgun.Subaccounts.Features.Update.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    public static var accounts: Path<PathBuilder.Component<String>> { Path {
        "accounts"
    } }

    public static var subaccounts: Path<PathBuilder.Component<String>> { Path {
        "subaccounts"
    } }

    public static var disable: Path<PathBuilder.Component<String>> { Path {
        "disable"
    } }

    public static var enable: Path<PathBuilder.Component<String>> { Path {
        "enable"
    } }

    public static var limit: Path<PathBuilder.Component<String>> { Path {
        "limit"
    } }

    public static var custom: Path<PathBuilder.Component<String>> { Path {
        "custom"
    } }

    public static var monthly: Path<PathBuilder.Component<String>> { Path {
        "monthly"
    } }

    public static var features: Path<PathBuilder.Component<String>> { Path {
        "features"
    } }
}
