import Mailgun_Types_Shared

extension Mailgun.Suppressions.Bounces {
    @CasePathable
    @dynamicMemberLookup
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
                URLRouting.Route(.case(Mailgun.Suppressions.Bounces.API.importList)) {
                    Method.post
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.bounces
                    Path { "import" }
                    try! FileUpload.csv()
                }

                URLRouting.Route(.case(Mailgun.Suppressions.Bounces.API.get)) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.bounces
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }

                URLRouting.Route(.case(Mailgun.Suppressions.Bounces.API.delete)) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.bounces
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }

                URLRouting.Route(.case(Mailgun.Suppressions.Bounces.API.list)) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.bounces
                    Optionally {
                        Parse(.memberwise(Mailgun.Suppressions.Bounces.List.Request.init)) {
                            URLRouting.Query {
                                Optionally {
                                    Field("limit") { Digits() }
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

                URLRouting.Route(.case(Mailgun.Suppressions.Bounces.API.create)) {
                    Method.post
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.bounces
                    Body(
                        .form(
                            Mailgun.Suppressions.Bounces.Create.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.Suppressions.Bounces.API.deleteAll)) {
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
