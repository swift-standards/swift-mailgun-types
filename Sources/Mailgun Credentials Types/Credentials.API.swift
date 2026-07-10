//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Credentials {
    @CasePathable
    @dynamicMemberLookup
    public enum API: Equatable, Sendable {
        case list(domain: Domain, request: Mailgun.Credentials.List.Request?)
        case create(domain: Domain, request: Mailgun.Credentials.Create.Request)
        case deleteAll(domain: Domain)
        case update(domain: Domain, login: String, request: Mailgun.Credentials.Update.Request)
        case delete(domain: Domain, login: String)
        case updateMailbox(
            domain: Domain,
            login: String,
            request: Mailgun.Credentials.Mailbox.Update.Request
        )
    }
}

extension Mailgun.Credentials.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Credentials.API> {
            OneOf {
                URLRouting.Route(.case(Mailgun.Credentials.API.list)) {
                    Method.get
                    Path { "v3" }
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.credentials
                    Optionally {
                        Parse(.memberwise(Mailgun.Credentials.List.Request.init)) {
                            URLRouting.Query {
                                Optionally {
                                    Field("skip") { Digits() }
                                }
                                Optionally {
                                    Field("limit") { Digits() }
                                }
                            }
                        }
                    }
                }

                URLRouting.Route(.case(Mailgun.Credentials.API.create)) {
                    Method.post
                    Path { "v3" }
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.credentials
                    Body(
                        .form(
                            Mailgun.Credentials.Create.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.Credentials.API.deleteAll)) {
                    Method.delete
                    Path { "v3" }
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.credentials
                }

                URLRouting.Route(.case(Mailgun.Credentials.API.update)) {
                    Method.put
                    Path { "v3" }
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.credentials
                    Path { Parse(.string) }
                    Body(
                        .form(
                            Mailgun.Credentials.Update.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.Credentials.API.delete)) {
                    Method.delete
                    Path { "v3" }
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.credentials
                    Path { Parse(.string) }
                }

                URLRouting.Route(.case(Mailgun.Credentials.API.updateMailbox)) {
                    Method.put
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.mailboxes
                    Path { Parse(.string) }
                    Body(
                        .form(
                            Mailgun.Credentials.Mailbox.Update.Request.self,
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
    public static var credentials: Path<PathBuilder.Component<String>> { Path {
        "credentials"
    } }

    public static var mailboxes: Path<PathBuilder.Component<String>> { Path {
        "mailboxes"
    } }

    public static var domains: Path<PathBuilder.Component<String>> { Path {
        "domains"
    } }
}
