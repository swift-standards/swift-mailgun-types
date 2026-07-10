//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Users {
    @CasePathable
    @dynamicMemberLookup
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
                URLRouting.Route(.case(Mailgun.Users.API.addToOrganization)) {
                    Method.put
                    Path { "v5" }
                    Path.users
                    Path { Parse(.string) }
                    Path.org
                    Path { Parse(.string) }
                }

                // DELETE /v5/users/{user_id}/org/{org_id}
                URLRouting.Route(.case(Mailgun.Users.API.removeFromOrganization)) {
                    Method.delete
                    Path { "v5" }
                    Path.users
                    Path { Parse(.string) }
                    Path.org
                    Path { Parse(.string) }
                }

                // GET /v5/users/me
                URLRouting.Route(.case(Mailgun.Users.API.me)) {
                    Method.get
                    Path { "v5" }
                    Path.users
                    Path.me
                }

                // GET /v5/users/{user_id}
                URLRouting.Route(.case(Mailgun.Users.API.get)) {
                    Method.get
                    Path { "v5" }
                    Path.users
                    Path { Parse(.string) }
                }

                // GET /v5/users
                URLRouting.Route(.case(Mailgun.Users.API.list)) {
                    Method.get
                    Path { "v5" }
                    Path.users
                    Optionally {
                        Parse(.memberwise(Mailgun.Users.List.Request.init)) {
                            URLRouting.Query {
                                Optionally {
                                    Field("role") {
                                        Parse(.string.representing(Mailgun.Users.Role.self))
                                    }
                                }
                                Optionally {
                                    Field("limit") { Digits() }
                                }
                                Optionally {
                                    Field("skip") { Digits() }
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
