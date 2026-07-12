//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Suppressions.Allowlist {
    @Cases
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
                URLRouting.Route(
                    .convert(
                        apply: { (domain: $0.0, value: $0.1) },
                        unapply: { ($0.domain, $0.value) }
                    )
                    .map(.case(Mailgun.Suppressions.Allowlist.API.cases.get))
                ) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.whitelists
                    Path { Parse(.string) }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (domain: $0.0, value: $0.1) },
                        unapply: { ($0.domain, $0.value) }
                    )
                    .map(.case(Mailgun.Suppressions.Allowlist.API.cases.delete))
                ) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.whitelists
                    Path { Parse(.string) }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (domain: $0.0, request: $0.1) },
                        unapply: { ($0.domain, $0.request) }
                    )
                    .map(.case(Mailgun.Suppressions.Allowlist.API.cases.list))
                ) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.whitelists
                    Optionally {
                        Parse(
                            .convert(
                                apply: { ($0.0.0.0, $0.0.0.1, $0.0.1, $0.1) },
                                unapply: { ((($0.0, $0.1), $0.2), $0.3) }
                            )
                            .map(
                                .memberwise(
                                    Mailgun.Suppressions.Allowlist.List.Request.init,
                                    { ($0.address, $0.term, $0.limit, $0.page) }
                                )
                            )
                        ) {
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
                                    Field("limit") { Int.parser() }
                                }
                                Optionally {
                                    Field("page") { Parse(.string) }
                                }
                            }
                        }
                    }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (domain: $0.0, request: $0.1) },
                        unapply: { ($0.domain, $0.request) }
                    )
                    .map(.case(Mailgun.Suppressions.Allowlist.API.cases.create))
                ) {
                    Method.post
                    Headers {
                        Field("Content-Type") { "application/x-www-form-urlencoded" }
                    }
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.whitelists
                    URLRouting.Body(
                        .form(
                            Mailgun.Suppressions.Allowlist.Create.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.Suppressions.Allowlist.API.cases.deleteAll)) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.whitelists
                }

                URLRouting.Route(
                    .convert(
                        apply: { (domain: $0.0, request: $0.1) },
                        unapply: { ($0.domain, $0.request) }
                    )
                    .map(.case(Mailgun.Suppressions.Allowlist.API.cases.importList))
                ) {
                    Method.post
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.whitelists
                    Path { "import" }
                    try! FileUpload(fieldName: "file", filename: "import.csv", fileType: .csv)
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
