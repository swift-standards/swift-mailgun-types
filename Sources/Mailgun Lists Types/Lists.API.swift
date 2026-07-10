//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Lists {
    @CasePathable
    @dynamicMemberLookup
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
                URLRouting.Route(.case(Mailgun.Lists.API.create)) {
                    Method.post
                    Path { "v3" }
                    Path.lists
                    Body(
                        .form(
                            Mailgun.Lists.List.Create.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.Lists.API.list)) {
                    Method.get
                    Path { "v3" }
                    Path.lists
                    Parse(.memberwise(Mailgun.Lists.List.Request.init)) {
                        URLRouting.Query {
                            Optionally {
                                Field("limit") { Digits() }
                            }
                            Optionally {
                                Field("skip") { Digits() }
                            }
                            Optionally {
                                Field("address") { Parse(.string.representing(EmailAddress.self)) }
                            }
                        }
                    }
                }

                URLRouting.Route(.case(Mailgun.Lists.API.members)) {
                    Method.get
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path.members
                    Parse(.memberwise(Mailgun.Lists.List.Members.Request.init)) {
                        URLRouting.Query {
                            Optionally {
                                Field("address") { Parse(.string.representing(EmailAddress.self)) }
                            }
                            Optionally {
                                Field("subscribed") { Bool.parser() }
                            }
                            Optionally {
                                Field("limit") { Digits() }
                            }
                            Optionally {
                                Field("skip") { Digits() }
                            }
                        }
                    }
                }

                URLRouting.Route(.case(Mailgun.Lists.API.addMember)) {
                    Method.post
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path.members
                    Body(
                        .form(
                            Mailgun.Lists.Member.Add.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.Lists.API.bulkAdd)) {
                    Method.post
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path { "members.json" }
                    Body(
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

                URLRouting.Route(.case(Mailgun.Lists.API.bulkAddCSV)) {
                    Method.post
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path { "members.csv" }
                    Path { Parse(.data) }
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

                URLRouting.Route(.case(Mailgun.Lists.API.updateMember)) {
                    Method.put
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path.members
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Multipart(
                        Mailgun.Lists.Member.Update.Request.self,
                        arrayEncodingStrategy: .brackets
                    )
                }

                URLRouting.Route(.case(Mailgun.Lists.API.deleteMember)) {
                    Method.delete
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path.members
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }

                URLRouting.Route(.case(Mailgun.Lists.API.getMember)) {
                    Method.get
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path.members
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }

                URLRouting.Route(.case(Mailgun.Lists.API.update)) {
                    Method.put
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Multipart(
                        Mailgun.Lists.List.Update.Request.self,
                        arrayEncodingStrategy: .brackets
                    )
                }

                URLRouting.Route(.case(Mailgun.Lists.API.delete)) {
                    Method.delete
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }

                URLRouting.Route(.case(Mailgun.Lists.API.get)) {
                    Method.get
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }

                URLRouting.Route(.case(Mailgun.Lists.API.pages)) {
                    Method.get
                    Path { "v3" }
                    Path.lists
                    Path.pages
                    URLRouting.Query {
                        Optionally {
                            Field("limit") { Digits() }
                        }
                    }
                }

                URLRouting.Route(.case(Mailgun.Lists.API.memberPages)) {
                    Method.get
                    Path { "v3" }
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path.members
                    Path.pages
                    Parse(.memberwise(Mailgun.Lists.List.Members.Pages.Request.init)) {
                        URLRouting.Query {
                            Optionally {
                                Field("subscribed") { Bool.parser() }
                            }
                            Optionally {
                                Field("limit") { Digits() }
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
