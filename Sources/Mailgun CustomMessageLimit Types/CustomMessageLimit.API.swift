//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.CustomMessageLimit {
    @CasePathable
    @dynamicMemberLookup
    public enum API: Equatable, Sendable {
        case getMonthly
        case setMonthly(request: Mailgun.CustomMessageLimit.Monthly.Set.Request)
        case deleteMonthly
        case enableAccount
    }
}

extension Mailgun.CustomMessageLimit.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.CustomMessageLimit.API> {
            OneOf {
                URLRouting.Route(.case(Mailgun.CustomMessageLimit.API.getMonthly)) {
                    Method.get
                    Path { "v5" }
                    Path.accounts
                    Path.limit
                    Path.custom
                    Path.monthly
                }

                URLRouting.Route(.case(Mailgun.CustomMessageLimit.API.setMonthly)) {
                    Method.put
                    Path { "v5" }
                    Path.accounts
                    Path.limit
                    Path.custom
                    Path.monthly
                    Parse(.memberwise(Mailgun.CustomMessageLimit.Monthly.Set.Request.init)) {
                        URLRouting.Query {
                            Field("limit") { Digits() }
                        }
                    }
                }

                URLRouting.Route(.case(Mailgun.CustomMessageLimit.API.deleteMonthly)) {
                    Method.delete
                    Path { "v5" }
                    Path.accounts
                    Path.limit
                    Path.custom
                    Path.monthly
                }

                URLRouting.Route(.case(Mailgun.CustomMessageLimit.API.enableAccount)) {
                    Method.put
                    Path { "v5" }
                    Path.accounts
                    Path.limit
                    Path.custom
                    Path.enable
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    public static var accounts: Path<PathBuilder.Component<String>> { Path {
        "accounts"
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

    public static var enable: Path<PathBuilder.Component<String>> { Path {
        "enable"
    } }
}
