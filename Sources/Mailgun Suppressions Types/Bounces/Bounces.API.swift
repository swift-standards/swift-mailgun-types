import Mailgun_Types_Shared

extension Mailgun.Suppressions.Bounces {
    @Cases
    public enum API: Equatable, Sendable {
        case importList(domain: Domain, request: Foundation.Data)
        case get(domain: Domain, address: EmailAddress)
        case delete(domain: Domain, address: EmailAddress)
        case list(domain: Domain, request: Mailgun.Suppressions.Bounces.List.Request?)
        case create(domain: Domain, request: Mailgun.Suppressions.Bounces.Create.Request)
        case deleteAll(domain: Domain)
    }
}

extension Mailgun.Suppressions.Bounces.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Suppressions.Bounces.API> {
            OneOf {
                URLRouting.Route(
                    .convert(
                        apply: { (domain: $0.0, request: $0.1) },
                        unapply: { ($0.domain, $0.request) }
                    )
                    .map(.case(Mailgun.Suppressions.Bounces.API.cases.importList))
                ) {
                    Method.post
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.bounces
                    Path { "import" }
                    try! FileUpload(fieldName: "file", filename: "import.csv", fileType: .csv)
                }

                URLRouting.Route(
                    .convert(
                        apply: { (domain: $0.0, address: $0.1) },
                        unapply: { ($0.domain, $0.address) }
                    )
                    .map(.case(Mailgun.Suppressions.Bounces.API.cases.get))
                ) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.bounces
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (domain: $0.0, address: $0.1) },
                        unapply: { ($0.domain, $0.address) }
                    )
                    .map(.case(Mailgun.Suppressions.Bounces.API.cases.delete))
                ) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.bounces
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (domain: $0.0, request: $0.1) },
                        unapply: { ($0.domain, $0.request) }
                    )
                    .map(.case(Mailgun.Suppressions.Bounces.API.cases.list))
                ) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.bounces
                    Optionally {
                        Parse(
                            .convert(
                                apply: { ($0.0.0, $0.0.1, $0.1) },
                                unapply: { (($0.0, $0.1), $0.2) }
                            )
                            .map(
                                .memberwise(
                                    Mailgun.Suppressions.Bounces.List.Request.init,
                                    { ($0.limit, $0.page, $0.term) }
                                )
                            )
                        ) {
                            URLRouting.Query {
                                Optionally {
                                    Field("limit") { Int.parser() }
                                }
                                Optionally {
                                    Field("page") { Parse(.string) }
                                }
                                Optionally {
                                    Field("term") { Parse(.string) }
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
                    .map(.case(Mailgun.Suppressions.Bounces.API.cases.create))
                ) {
                    Method.post
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.bounces
                    URLRouting.Body(coding:
                        .form(
                            Mailgun.Suppressions.Bounces.Create.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.Suppressions.Bounces.API.cases.deleteAll)) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.bounces
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    public static var bounces: Path<PathBuilder.Component<String>> { Path {
        "bounces"
    } }
}
