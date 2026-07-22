//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Domains.Domains {
    @Cases
    public enum API: Equatable, Sendable {
        case list(request: Mailgun.Domains.Domains.List.Request?)
        case create(request: Mailgun.Domains.Domains.Create.Request)
        case get(domain: Domain)
        case update(domain: Domain, request: Mailgun.Domains.Domains.Update.Request)
        case delete(domain: Domain)
        case verify(domain: Domain)
    }
}

extension Mailgun.Domains.Domains.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Domains.Domains.API> {
            OneOf {
                URLRouting.Route(.case(Mailgun.Domains.Domains.API.cases.list)) {
                    Method.get
                    Path { "v4" }
                    Path { "domains" }
                    Optionally {
                        Parse(
                            .convert(
                                apply: { ($0.0.0.0, $0.0.0.1, $0.0.1, $0.1) },
                                unapply: { ((($0.0, $0.1), $0.2), $0.3) }
                            )
                            .map(
                                .memberwise(
                                    Mailgun.Domains.Domains.List.Request.init,
                                    { ($0.authority, $0.state, $0.limit, $0.skip) }
                                )
                            )
                        ) {
                            URLRouting.Query {
                                Optionally {
                                    Field("authority") { Parse(.string) }
                                }
                                Optionally {
                                    Field("state") {
                                        Parse(
                                            .string.representing(Mailgun.Domains.Domains.State.self)
                                        )
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

                URLRouting.Route(.case(Mailgun.Domains.Domains.API.cases.create)) {
                    Method.post
                    Path { "v4" }
                    Path { "domains" }
                    URLRouting.Body(coding:
                        .form(
                            Mailgun.Domains.Domains.Create.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.Domains.Domains.API.cases.get)) {
                    Method.get
                    Path { "v4" }
                    Path { "domains" }
                    Path { Parse(.string.representing(Domain.self)) }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (domain: $0.0, request: $0.1) },
                        unapply: { ($0.domain, $0.request) }
                    )
                    .map(.case(Mailgun.Domains.Domains.API.cases.update))
                ) {
                    Method.put
                    Path { "v4" }
                    Path { "domains" }
                    Path { Parse(.string.representing(Domain.self)) }
                    URLRouting.Body(coding:
                        .form(
                            Mailgun.Domains.Domains.Update.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.Domains.Domains.API.cases.delete)) {
                    Method.delete
                    Path { "v4" }
                    Path { "domains" }
                    Path { Parse(.string.representing(Domain.self)) }
                }

                URLRouting.Route(.case(Mailgun.Domains.Domains.API.cases.verify)) {
                    Method.put
                    Path { "v4" }
                    Path { "domains" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path { "verify" }
                }
            }
        }
    }
}
