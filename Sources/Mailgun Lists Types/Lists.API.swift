//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Lists {
    @Cases
    public enum API: Equatable, Sendable {
        case create(request: Mailgun.Lists.List.Create.Request)
        case list(request: Mailgun.Lists.List.Request)
        case members(listAddress: EmailAddress, request: Mailgun.Lists.List.Members.Request)
        case addMember(listAddress: EmailAddress, request: Mailgun.Lists.Member.Add.Request)
        case bulkAdd(listAddress: EmailAddress, members: [Mailgun.Lists.Member.Bulk], upsert: Bool?)
        case bulkAddCSV(
            listAddress: EmailAddress,
            request: Foundation.Data,
            subscribed: Bool?,
            upsert: Bool?
        )
        case getMember(listAddress: EmailAddress, memberAddress: EmailAddress)
        case updateMember(
            listAddress: EmailAddress,
            memberAddress: EmailAddress,
            request: Mailgun.Lists.Member.Update.Request
        )
        case deleteMember(listAddress: EmailAddress, memberAddress: EmailAddress)
        case update(listAddress: EmailAddress, request: Mailgun.Lists.List.Update.Request)
        case delete(listAddress: EmailAddress)
        case get(listAddress: EmailAddress)
        case pages(limit: Int?)
        case memberPages(
            listAddress: EmailAddress,
            request: Mailgun.Lists.List.Members.Pages.Request
        )
    }
}

extension Mailgun.Lists.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Lists.API> {
            OneOf {
                URLRouting.Route(.case(Mailgun.Lists.API.cases.create)) {
                    Method.post
                    Path { "v3" }
                    Path.lists
                    URLRouting.Body(
                        .form(
                            Mailgun.Lists.List.Create.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.Lists.API.cases.list)) {
                    Method.get
                    Path { "v3" }
                    Path.lists
                    Parse(
                        .convert(
                            apply: { ($0.0.0, $0.0.1, $0.1) },
                            unapply: { (($0.0, $0.1), $0.2) }
                        )
                        .map(
                            .memberwise(
                                Mailgun.Lists.List.Request.init,
                                { ($0.limit, $0.skip, $0.address) }
                            )
                        )
                    ) {
                        URLRouting.Query {
                            Optionally {
                                Field("limit") { Int.parser() }
                            }
                            Optionally {
                                Field("skip") { Int.parser() }
                            }
                            Optionally {
                                Field("address") { Parse(.string.representing(EmailAddress.self)) }
                            }
                        }
                    }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (listAddress: $0.0, request: $0.1) },
                        unapply: { ($0.listAddress, $0.request) }
                    )
                    .map(.case(Mailgun.Lists.API.cases.members))
                ) {
                    Method.get
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path.members
                    Parse(
                        .convert(
                            apply: { ($0.0.0.0, $0.0.0.1, $0.0.1, $0.1) },
                            unapply: { ((($0.0, $0.1), $0.2), $0.3) }
                        )
                        .map(
                            .memberwise(
                                Mailgun.Lists.List.Members.Request.init,
                                { ($0.address, $0.subscribed, $0.limit, $0.skip) }
                            )
                        )
                    ) {
                        URLRouting.Query {
                            Optionally {
                                Field("address") { Parse(.string.representing(EmailAddress.self)) }
                            }
                            Optionally {
                                Field("subscribed") { Bool.parser() }
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

                URLRouting.Route(
                    .convert(
                        apply: { (listAddress: $0.0, request: $0.1) },
                        unapply: { ($0.listAddress, $0.request) }
                    )
                    .map(.case(Mailgun.Lists.API.cases.addMember))
                ) {
                    Method.post
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path.members
                    URLRouting.Body(
                        .form(
                            Mailgun.Lists.Member.Add.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(
                    .convert(
                        apply: { (listAddress: $0.0.0, members: $0.0.1, upsert: $0.1) },
                        unapply: { (($0.listAddress, $0.members), $0.upsert) }
                    )
                    .map(.case(Mailgun.Lists.API.cases.bulkAdd))
                ) {
                    Method.post
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path { "members.json" }
                    URLRouting.Body(
                        .form(
                            [Mailgun.Lists.Member.Bulk].self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                    URLRouting.Query {
                        Optionally {
                            Field("upsert") { Bool.parser() }
                        }
                    }
                }

                URLRouting.Route(
                    .convert(
                        apply: {
                            (
                                listAddress: $0.0.0.0,
                                request: $0.0.0.1,
                                subscribed: $0.0.1,
                                upsert: $0.1
                            )
                        },
                        unapply: { ((($0.listAddress, $0.request), $0.subscribed), $0.upsert) }
                    )
                    .map(.case(Mailgun.Lists.API.cases.bulkAddCSV))
                ) {
                    Method.post
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path { "members.csv" }
                    Path {
                        // The vended `.data` conversion is `[UInt8] ⇆ Data`; a path
                        // component is `Substring`, so bridge via `.string` + a UTF-8
                        // witness (equivalent to the retired pointfree `.data`).
                        Parse(
                            .string.map(
                                Parser.Conversion.Witness<Swift.String, Foundation.Data, Never>(
                                    apply: { (raw: Swift.String) -> Foundation.Data in
                                        Foundation.Data(raw.utf8)
                                    },
                                    unapply: { (data: Foundation.Data) -> Swift.String in
                                        Swift.String(decoding: data, as: UTF8.self)
                                    }
                                )
                            )
                        )
                    }
                    URLRouting.Query {
                        Optionally {
                            Field("subscribed") { Bool.parser() }
                        }
                    }
                    URLRouting.Query {
                        Optionally {
                            Field("upsert") { Bool.parser() }
                        }
                    }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (listAddress: $0.0.0, memberAddress: $0.0.1, request: $0.1) },
                        unapply: { (($0.listAddress, $0.memberAddress), $0.request) }
                    )
                    .map(.case(Mailgun.Lists.API.cases.updateMember))
                ) {
                    Method.put
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path.members
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    URLRouting.Body(
                        RFC_2046.Multipart.Conversion(
                            Mailgun.Lists.Member.Update.Request.self,
                            arrayEncodingStrategy: .brackets,
                            boundary: RFC_2046.Boundary(__unchecked: (), rawValue: "----MailgunFormBoundary")
                        )
                    )
                }

                URLRouting.Route(
                    .convert(
                        apply: { (listAddress: $0.0, memberAddress: $0.1) },
                        unapply: { ($0.listAddress, $0.memberAddress) }
                    )
                    .map(.case(Mailgun.Lists.API.cases.deleteMember))
                ) {
                    Method.delete
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path.members
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (listAddress: $0.0, memberAddress: $0.1) },
                        unapply: { ($0.listAddress, $0.memberAddress) }
                    )
                    .map(.case(Mailgun.Lists.API.cases.getMember))
                ) {
                    Method.get
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path.members
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (listAddress: $0.0, request: $0.1) },
                        unapply: { ($0.listAddress, $0.request) }
                    )
                    .map(.case(Mailgun.Lists.API.cases.update))
                ) {
                    Method.put
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    URLRouting.Body(
                        RFC_2046.Multipart.Conversion(
                            Mailgun.Lists.List.Update.Request.self,
                            arrayEncodingStrategy: .brackets,
                            boundary: RFC_2046.Boundary(__unchecked: (), rawValue: "----MailgunFormBoundary")
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.Lists.API.cases.delete)) {
                    Method.delete
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }

                URLRouting.Route(.case(Mailgun.Lists.API.cases.get)) {
                    Method.get
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }

                URLRouting.Route(.case(Mailgun.Lists.API.cases.pages)) {
                    Method.get
                    Path { "v3" }
                    Path.lists
                    Path.pages
                    URLRouting.Query {
                        Optionally {
                            Field("limit") { Int.parser() }
                        }
                    }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (listAddress: $0.0, request: $0.1) },
                        unapply: { ($0.listAddress, $0.request) }
                    )
                    .map(.case(Mailgun.Lists.API.cases.memberPages))
                ) {
                    Method.get
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path.members
                    Path.pages
                    Parse(
                        .convert(
                            apply: { ($0.0.0.0, $0.0.0.1, $0.0.1, $0.1) },
                            unapply: { ((($0.0, $0.1), $0.2), $0.3) }
                        )
                        .map(
                            .memberwise(
                                Mailgun.Lists.List.Members.Pages.Request.init,
                                { ($0.subscribed, $0.limit, $0.address, $0.page) }
                            )
                        )
                    ) {
                        URLRouting.Query {
                            Optionally {
                                Field("subscribed") { Bool.parser() }
                            }
                            Optionally {
                                Field("limit") { Int.parser() }
                            }
                            Optionally {
                                Field("address") { Parse(.string.representing(EmailAddress.self)) }
                            }
                            Optionally {
                                Field("page") {
                                    Parse(.string).map(
                                        .representing(Mailgun.Lists.PageDirection.self)
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {

    public static var lists: Path<PathBuilder.Component<String>> { Path {
        "lists"
    } }

    public static var members: Path<PathBuilder.Component<String>> { Path {
        "members"
    } }

    package static var pages: Path<PathBuilder.Component<String>> { Path { "pages" } }
}
