//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Suppressions.Unsubscribe {
    @CasePathable
    @dynamicMemberLookup
    public enum API: Equatable, Sendable {
        case importList(domain: Domain, request: Foundation.Data)
        case get(domain: Domain, address: EmailAddress)
        case delete(domain: Domain, address: EmailAddress)
        case list(domain: Domain, request: Mailgun.Suppressions.Unsubscribe.List.Request?)
        case create(domain: Domain, request: Mailgun.Suppressions.Unsubscribe.Create.Request)
        case deleteAll(domain: Domain)
    }
}

extension Mailgun.Suppressions.Unsubscribe.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Suppressions.Unsubscribe.API> {
            OneOf {
                // POST /v3/{domainID}/unsubscribes/import
                URLRouting.Route(.case(Mailgun.Suppressions.Unsubscribe.API.importList)) {
                    Method.post
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.unsubscribes
                    Path { "import" }
                    try! FileUpload.csv()
                }

                // DELETE /v3/{domainID}/unsubscribes/{address}
                URLRouting.Route(.case(Mailgun.Suppressions.Unsubscribe.API.delete)) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.unsubscribes
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }

                // DELETE /v3/{domainID}/unsubscribes
                URLRouting.Route(.case(Mailgun.Suppressions.Unsubscribe.API.deleteAll)) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.unsubscribes
                }

                // GET /v3/{domainID}/unsubscribes/{address}
                URLRouting.Route(.case(Mailgun.Suppressions.Unsubscribe.API.get)) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.unsubscribes
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }

                // GET /v3/{domainID}/unsubscribes
                URLRouting.Route(.case(Mailgun.Suppressions.Unsubscribe.API.list)) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.unsubscribes
                    Optionally {
                        Parse(.memberwise(Mailgun.Suppressions.Unsubscribe.List.Request.init)) {
                            URLRouting.Query {
                                Optionally {
                                    Field("address") {
                                        Parse(.string.representing(EmailAddress.self))
                                    }
                                }
                                Optionally {
                                    Field("term") { Parse(.string) }
                                }
                                Optionally {
                                    Field("limit") { Digits() }
                                }
                                Optionally {
                                    Field("page") { Parse(.string) }
                                }
                            }
                        }
                    }
                }

                // POST /v3/{domainID}/unsubscribes
                URLRouting.Route(.case(Mailgun.Suppressions.Unsubscribe.API.create)) {
                    Method.post
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.unsubscribes
                    Body(
                        .form(
                            Mailgun.Suppressions.Unsubscribe.Create.Request.self,
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
    public static var unsubscribes: Path<PathBuilder.Component<String>> { Path {
        "unsubscribes"
    } }
}
