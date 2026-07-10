//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Routes {
    @CasePathable
    @dynamicMemberLookup
    public enum API: Equatable, Sendable {
        case create(request: Mailgun.Routes.Create.Request)
        case list(limit: Int? = nil, skip: Int? = nil)
        case get(id: String)
        case update(id: String, request: Mailgun.Routes.Update.Request)
        case delete(id: String)
        case match(address: String)
    }
}

extension Mailgun.Routes.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Routes.API> {
            OneOf {
                URLRouting.Route(.case(Mailgun.Routes.API.create)) {
                    Method.post
                    Path { "v3" }
                    Path.routes
                    Body(
                        .form(
                            Mailgun.Routes.Create.Request.self,
                            decoder: .mailgunRoutes,
                            encoder: .mailgunRoutes
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.Routes.API.update)) {
                    Method.put
                    Path { "v3" }
                    Path.routes
                    Path { Parse(.string) }
                    Body(.multipart(Mailgun.Routes.Update.Request.self))
                }

                URLRouting.Route(.case(Mailgun.Routes.API.delete)) {
                    Method.delete
                    Path { "v3" }
                    Path.routes
                    Path { Parse(.string) }
                }

                URLRouting.Route(.case(Mailgun.Routes.API.get)) {
                    Method.get
                    Path { "v3" }
                    Path.routes
                    Path { Parse(.string) }
                }

                URLRouting.Route(.case(Mailgun.Routes.API.list)) {
                    Method.get
                    Path { "v3" }
                    Path.routes
                    Query {
                        Optionally {
                            Field("limit") { Digits() }
                        }
                        Optionally {
                            Field("skip") { Digits() }
                        }
                    }
                }

                URLRouting.Route(.case(Mailgun.Routes.API.match)) {
                    Method.get
                    Path { "v3" }
                    Path.routes
                    Path { "match" }
                    Query {
                        Field("address") { Parse(.string) }
                    }
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    public static var routes: Path<PathBuilder.Component<String>> { Path {
        "routes"
    } }

    public static var match: Path<PathBuilder.Component<String>> { Path {
        "match"
    } }
}
