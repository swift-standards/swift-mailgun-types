//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Users {
    @Cases
    public enum API: Equatable, Sendable {
        case list(request: Mailgun.Users.List.Request?)
        case get(userId: String)
        case me
        case addToOrganization(userId: String, orgId: String)
        case removeFromOrganization(userId: String, orgId: String)
    }
}

extension Mailgun.Users.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Users.API> {
            OneOf {
                // PUT /v5/users/{user_id}/org/{org_id}
                URLRouting.Route(
                    .convert(
                        apply: { (userId: $0.0, orgId: $0.1) },
                        unapply: { ($0.userId, $0.orgId) }
                    )
                    .map(.case(Mailgun.Users.API.cases.addToOrganization))
                ) {
                    Method.put
                    Path { "v5" }
                    Path.users
                    Path { Parse(.string) }
                    Path.org
                    Path { Parse(.string) }
                }

                // DELETE /v5/users/{user_id}/org/{org_id}
                URLRouting.Route(
                    .convert(
                        apply: { (userId: $0.0, orgId: $0.1) },
                        unapply: { ($0.userId, $0.orgId) }
                    )
                    .map(.case(Mailgun.Users.API.cases.removeFromOrganization))
                ) {
                    Method.delete
                    Path { "v5" }
                    Path.users
                    Path { Parse(.string) }
                    Path.org
                    Path { Parse(.string) }
                }

                // GET /v5/users/me
                URLRouting.Route(.case(Mailgun.Users.API.cases.me)) {
                    Method.get
                    Path { "v5" }
                    Path.users
                    Path.me
                }

                // GET /v5/users/{user_id}
                URLRouting.Route(.case(Mailgun.Users.API.cases.get)) {
                    Method.get
                    Path { "v5" }
                    Path.users
                    Path { Parse(.string) }
                }

                // GET /v5/users
                URLRouting.Route(.case(Mailgun.Users.API.cases.list)) {
                    Method.get
                    Path { "v5" }
                    Path.users
                    Optionally {
                        Parse(
                            .convert(
                                apply: { ($0.0.0, $0.0.1, $0.1) },
                                unapply: { (($0.0, $0.1), $0.2) }
                            )
                            .map(
                                .memberwise(
                                    Mailgun.Users.List.Request.init,
                                    { ($0.role, $0.limit, $0.skip) }
                                )
                            )
                        ) {
                            URLRouting.Query {
                                Optionally {
                                    Field("role") {
                                        Parse(.string.representing(Mailgun.Users.Role.self))
                                    }
                                }
                                Optionally {
                                    Field("limit") { Int.parser() }
                                }
                                Optionally {
                                    Field("skip") { Int.parser() }
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
    public static var users: Path<PathBuilder.Component<String>> { Path {
        "users"
    } }

    public static var me: Path<PathBuilder.Component<String>> { Path {
        "me"
    } }

    public static var org: Path<PathBuilder.Component<String>> { Path {
        "org"
    } }
}
