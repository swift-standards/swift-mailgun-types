//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Domains.DomainKeys {
    @Cases
    public enum API: Equatable, Sendable {
        case list(request: Mailgun.Domains.DomainKeys.List.Request?)
        case create(request: Mailgun.Domains.DomainKeys.Create.Request)
        case delete(request: Mailgun.Domains.DomainKeys.Delete.Request)
        case activate(authorityName: String, selector: String)
        case listDomainKeys(authorityName: String)
        case deactivate(authorityName: String, selector: String)
        case setDkimAuthority(
            domainName: String,
            request: Mailgun.Domains.DomainKeys.SetDkimAuthority.Request
        )
        case setDkimSelector(
            domainName: String,
            request: Mailgun.Domains.DomainKeys.SetDkimSelector.Request
        )
    }
}

extension Mailgun.Domains.DomainKeys.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Domains.DomainKeys.API> {
            OneOf {
                URLRouting.Route(.case(Mailgun.Domains.DomainKeys.API.cases.list)) {
                    Method.get
                    Path { "v1" }
                    Path { "dkim" }
                    Path { "keys" }
                    Optionally {
                        Parse(
                            .convert(
                                apply: { ($0.0.0.0, $0.0.0.1, $0.0.1, $0.1) },
                                unapply: { ((($0.0, $0.1), $0.2), $0.3) }
                            )
                            .map(
                                .memberwise(
                                    Mailgun.Domains.DomainKeys.List.Request.init,
                                    { ($0.page, $0.limit, $0.signingDomain, $0.selector) }
                                )
                            )
                        ) {
                            URLRouting.Query {
                                Optionally {
                                    Field("page") { Parse(.string) }
                                }
                                Optionally {
                                    Field("limit") { Int.parser() }
                                }
                                Optionally {
                                    Field("signing_domain") { Parse(.string) }
                                }
                                Optionally {
                                    Field("selector") { Parse(.string) }
                                }
                            }
                        }
                    }
                }

                URLRouting.Route(.case(Mailgun.Domains.DomainKeys.API.cases.create)) {
                    Method.post
                    Path { "v1" }
                    Path { "dkim" }
                    Path { "keys" }
                    URLRouting.Body(coding:
                        .form(
                            Mailgun.Domains.DomainKeys.Create.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.Domains.DomainKeys.API.cases.delete)) {
                    Method.delete
                    Path { "v1" }
                    Path { "dkim" }
                    Path { "keys" }
                    URLRouting.Body(coding:
                        .form(
                            Mailgun.Domains.DomainKeys.Delete.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(
                    .convert(
                        apply: { (authorityName: $0.0, selector: $0.1) },
                        unapply: { ($0.authorityName, $0.selector) }
                    )
                    .map(.case(Mailgun.Domains.DomainKeys.API.cases.activate))
                ) {
                    Method.put
                    Path { "v4" }
                    Path { "domains" }
                    Path { Parse(.string) }
                    Path { "keys" }
                    Path { Parse(.string) }
                    Path { "activate" }
                }

                URLRouting.Route(.case(Mailgun.Domains.DomainKeys.API.cases.listDomainKeys)) {
                    Method.get
                    Path { "v4" }
                    Path { "domains" }
                    Path { Parse(.string) }
                    Path { "keys" }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (authorityName: $0.0, selector: $0.1) },
                        unapply: { ($0.authorityName, $0.selector) }
                    )
                    .map(.case(Mailgun.Domains.DomainKeys.API.cases.deactivate))
                ) {
                    Method.put
                    Path { "v4" }
                    Path { "domains" }
                    Path { Parse(.string) }
                    Path { "keys" }
                    Path { Parse(.string) }
                    Path { "deactivate" }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (domainName: $0.0, request: $0.1) },
                        unapply: { ($0.domainName, $0.request) }
                    )
                    .map(.case(Mailgun.Domains.DomainKeys.API.cases.setDkimAuthority))
                ) {
                    Method.put
                    Path { "v3" }
                    Path { "domains" }
                    Path { Parse(.string) }
                    Path { "dkim_authority" }
                    URLRouting.Body(coding:
                        .form(
                            Mailgun.Domains.DomainKeys.SetDkimAuthority.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(
                    .convert(
                        apply: { (domainName: $0.0, request: $0.1) },
                        unapply: { ($0.domainName, $0.request) }
                    )
                    .map(.case(Mailgun.Domains.DomainKeys.API.cases.setDkimSelector))
                ) {
                    Method.put
                    Path { "v3" }
                    Path { "domains" }
                    Path { Parse(.string) }
                    Path { "dkim_selector" }
                    URLRouting.Body(coding:
                        .form(
                            Mailgun.Domains.DomainKeys.SetDkimSelector.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }
            }
        }
    }
}
