// Complaints.API.swift
import Mailgun_Types_Shared
import URLFormCoding

extension Mailgun.Suppressions.Complaints {
    @CasePathable
    @dynamicMemberLookup
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
                URLRouting.Route(.case(Mailgun.Suppressions.Complaints.API.importList)) {
                    Method.post
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.complaints
                    Path { "import" }
                    Body(.multipart(Mailgun.Suppressions.Complaints.Import.Request.self))
                }

                URLRouting.Route(.case(Mailgun.Suppressions.Complaints.API.get)) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.complaints
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }

                URLRouting.Route(.case(Mailgun.Suppressions.Complaints.API.delete)) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.complaints
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }

                URLRouting.Route(.case(Mailgun.Suppressions.Complaints.API.list)) {
                    Method.get
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.complaints
                    Optionally {
                        Parse(.memberwise(Mailgun.Suppressions.Complaints.List.Request.init)) {
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

                URLRouting.Route(.case(Mailgun.Suppressions.Complaints.API.create)) {
                    Method.post
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.complaints
                    Body(
                        .form(
                            Mailgun.Suppressions.Complaints.Create.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.Suppressions.Complaints.API.deleteAll)) {
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
