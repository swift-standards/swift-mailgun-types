// Complaints.API.swift
import Mailgun_Types_Shared
import URLFormCoding

extension Mailgun.Suppressions.Complaints {
    @Cases
    public enum API: Equatable, Sendable {
        case importList(domain: Domain, request: Mailgun.Suppressions.Complaints.Import.Request)
        case get(domain: Domain, address: EmailAddress)
        case delete(domain: Domain, address: EmailAddress)
        case list(domain: Domain, request: Mailgun.Suppressions.Complaints.List.Request?)
        case create(domain: Domain, request: Mailgun.Suppressions.Complaints.Create.Request)
        case deleteAll(domain: Domain)
    }
}

extension Mailgun.Suppressions.Complaints.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Suppressions.Complaints.API> {
            OneOf {
                URLRouting.Route(
                    .convert(
                        apply: { (domain: $0.0, request: $0.1) },
                        unapply: { ($0.domain, $0.request) }
                    )
                    .map(.case(Mailgun.Suppressions.Complaints.API.cases.importList))
                ) {
                    Method.post
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.complaints
                    Path { "import" }
                    URLRouting.Body(
                        RFC_2046.Multipart.Conversion(
                            Mailgun.Suppressions.Complaints.Import.Request.self,
                            boundary: RFC_2046.Boundary(__unchecked: (), rawValue: "----MailgunFormBoundary")
                        )
                    )
                }

                URLRouting.Route(
                    .convert(
                        apply: { (domain: $0.0, address: $0.1) },
                        unapply: { ($0.domain, $0.address) }
                    )
                    .map(.case(Mailgun.Suppressions.Complaints.API.cases.get))
                ) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.complaints
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (domain: $0.0, address: $0.1) },
                        unapply: { ($0.domain, $0.address) }
                    )
                    .map(.case(Mailgun.Suppressions.Complaints.API.cases.delete))
                ) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.complaints
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (domain: $0.0, request: $0.1) },
                        unapply: { ($0.domain, $0.request) }
                    )
                    .map(.case(Mailgun.Suppressions.Complaints.API.cases.list))
                ) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.complaints
                    Optionally {
                        Parse(
                            .convert(
                                apply: { ($0.0.0.0, $0.0.0.1, $0.0.1, $0.1) },
                                unapply: { ((($0.0, $0.1), $0.2), $0.3) }
                            )
                            .map(
                                .memberwise(
                                    Mailgun.Suppressions.Complaints.List.Request.init,
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
                    .map(.case(Mailgun.Suppressions.Complaints.API.cases.create))
                ) {
                    Method.post
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.complaints
                    URLRouting.Body(
                        .form(
                            Mailgun.Suppressions.Complaints.Create.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.Suppressions.Complaints.API.cases.deleteAll)) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.complaints
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    public static var complaints: Path<PathBuilder.Component<String>> { Path {
        "complaints"
    } }
}
