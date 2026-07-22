//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Routes {
    @Cases
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
                URLRouting.Route(.case(Mailgun.Routes.API.cases.create)) {
                    Method.post
                    Path { "v3" }
                    Path.routes
                    URLRouting.Body(coding:
                        .form(
                            Mailgun.Routes.Create.Request.self,
                            decoder: .mailgunRoutes,
                            encoder: .mailgunRoutes
                        )
                    )
                }

                URLRouting.Route(
                    .convert(
                        apply: { (id: $0.0, request: $0.1) },
                        unapply: { ($0.id, $0.request) }
                    )
                    .map(.case(Mailgun.Routes.API.cases.update))
                ) {
                    Method.put
                    Path { "v3" }
                    Path.routes
                    Path { Parse(.string) }
                    URLRouting.Body(coding:
                        RFC_2046.Multipart.Conversion(
                            Mailgun.Routes.Update.Request.self,
                            boundary: RFC_2046.Boundary(__unchecked: (), rawValue: "----MailgunFormBoundary")
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.Routes.API.cases.delete)) {
                    Method.delete
                    Path { "v3" }
                    Path.routes
                    Path { Parse(.string) }
                }

                URLRouting.Route(.case(Mailgun.Routes.API.cases.get)) {
                    Method.get
                    Path { "v3" }
                    Path.routes
                    Path { Parse(.string) }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (limit: $0.0, skip: $0.1) },
                        unapply: { ($0.limit, $0.skip) }
                    )
                    .map(.case(Mailgun.Routes.API.cases.list))
                ) {
                    Method.get
                    Path { "v3" }
                    Path.routes
                    Query {
                        Optionally {
                            Field("limit") { Int.parser() }
                        }
                        Optionally {
                            Field("skip") { Int.parser() }
                        }
                    }
                }

                URLRouting.Route(.case(Mailgun.Routes.API.cases.match)) {
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
