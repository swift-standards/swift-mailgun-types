//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Subaccounts {
    @CasePathable
    @dynamicMemberLookup
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
                URLRouting.Route(.case(Mailgun.Subaccounts.API.get)) {
                    Method.get
                    Path { "v5" }
                    Path.accounts
                    Path.subaccounts
                    Path { Parse(.string) }
                }

                URLRouting.Route(.case(Mailgun.Subaccounts.API.list)) {
                    Method.get
                    Path { "v5" }
                    Path.accounts
                    Path.subaccounts
                    Optionally {
                        Parse(.memberwise(Mailgun.Subaccounts.List.Request.init)) {
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
                                    Field("limit") { Digits() }
                                }
                                Optionally {
                                    Field("skip") { Digits() }
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

                URLRouting.Route(.case(Mailgun.Subaccounts.API.create)) {
                    Method.post
                    Path { "v5" }
                    Path.accounts
                    Path.subaccounts
                    Parse(.memberwise(Mailgun.Subaccounts.Create.Request.init)) {
                        URLRouting.Query {
                            Field("name") { Parse(.string) }
                        }
                    }
                }

                URLRouting.Route(.case(Mailgun.Subaccounts.API.delete)) {
                    Method.delete
                    Path { "v5" }
                    Path.accounts
                    Path.subaccounts
                    Headers {
                        Field("X-Mailgun-On-Behalf-Of", .string)
                    }
                }

                URLRouting.Route(.case(Mailgun.Subaccounts.API.disable)) {
                    Method.post
                    Path { "v5" }
                    Path.accounts
                    Path.subaccounts
                    Path { Parse(.string) }
                    Path.disable
                    Optionally {
                        Parse(.memberwise(Mailgun.Subaccounts.Disable.Request.init)) {
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

                URLRouting.Route(.case(Mailgun.Subaccounts.API.enable)) {
                    Method.post
                    Path { "v5" }
                    Path.accounts
                    Path.subaccounts
                    Path { Parse(.string) }
                    Path.enable
                }

                URLRouting.Route(.case(Mailgun.Subaccounts.API.getCustomLimit)) {
                    Method.get
                    Path { "v5" }
                    Path.accounts
                    Path.subaccounts
                    Path { Parse(.string) }
                    Path.limit
                    Path.custom
                    Path.monthly
                }

                URLRouting.Route(.case(Mailgun.Subaccounts.API.updateCustomLimit)) {
                    Method.put
                    Path { "v5" }
                    Path.accounts
                    Path.subaccounts
                    Path { Parse(.string) }
                    Path.limit
                    Path.custom
                    Path.monthly
                    URLRouting.Query {
                        Field("limit") { Double.parser() }
                    }
                }

                URLRouting.Route(.case(Mailgun.Subaccounts.API.deleteCustomLimit)) {
                    Method.delete
                    Path { "v5" }
                    Path.accounts
                    Path.subaccounts
                    Path { Parse(.string) }
                    Path.limit
                    Path.custom
                    Path.monthly
                }

                URLRouting.Route(.case(Mailgun.Subaccounts.API.updateFeatures)) {
                    Method.put
                    Path { "v5" }
                    Path.accounts
                    Path.subaccounts
                    Path { Parse(.string) }
                    Path.features
                    Body(
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
