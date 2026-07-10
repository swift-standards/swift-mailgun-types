//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Suppressions.Allowlist {
    @CasePathable
    @dynamicMemberLookup
    public enum API: Equatable, Sendable {
        case get(domain: Domain, value: String)
        case delete(domain: Domain, value: String)
        case list(domain: Domain, request: Mailgun.Suppressions.Allowlist.List.Request?)
        case create(domain: Domain, request: Mailgun.Suppressions.Allowlist.Create.Request)
        case deleteAll(domain: Domain)
        case importList(domain: Domain, request: Foundation.Data)
    }
}

extension Mailgun.Suppressions.Allowlist.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Suppressions.Allowlist.API> {
            OneOf {
                URLRouting.Route(.case(Mailgun.Suppressions.Allowlist.API.get)) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.whitelists
                    Path { Parse(.string) }
                }

                URLRouting.Route(.case(Mailgun.Suppressions.Allowlist.API.delete)) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.whitelists
                    Path { Parse(.string) }
                }

                URLRouting.Route(.case(Mailgun.Suppressions.Allowlist.API.list)) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.whitelists
                    Optionally {
                        Parse(.memberwise(Mailgun.Suppressions.Allowlist.List.Request.init)) {
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

                URLRouting.Route(.case(Mailgun.Suppressions.Allowlist.API.create)) {
                    Method.post
                    Headers {
                        Field("Content-Type") { "application/x-www-form-urlencoded" }
                    }
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.whitelists
                    Body(
                        .form(
                            Mailgun.Suppressions.Allowlist.Create.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.Suppressions.Allowlist.API.deleteAll)) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.whitelists
                }

                URLRouting.Route(.case(Mailgun.Suppressions.Allowlist.API.importList)) {
                    Method.post
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.whitelists
                    Path { "import" }
                    try! FileUpload.csv()
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    public static var whitelists: Path<PathBuilder.Component<String>> { Path {
        "whitelists"
    } }
}
