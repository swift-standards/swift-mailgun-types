//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Keys {
    @CasePathable
    @dynamicMemberLookup
    public enum API: Equatable, Sendable {
        case list
        case create(request: Mailgun.Keys.Create.Request)
        case delete(keyId: String)
        case addPublicKey(request: Mailgun.Keys.PublicKey.Request)
    }
}

extension Mailgun.Keys.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Keys.API> {
            OneOf {
                URLRouting.Route(.case(Mailgun.Keys.API.list)) {
                    Method.get
                    Path { "v1" }
                    Path.keys
                }

                URLRouting.Route(.case(Mailgun.Keys.API.create)) {
                    Method.post
                    Path { "v1" }
                    Path.keys
                    Body(
                        .form(
                            Mailgun.Keys.Create.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.Keys.API.delete)) {
                    Method.delete
                    Path { "v1" }
                    Path.keys
                    Path { Parse(.string) }
                }

                URLRouting.Route(.case(Mailgun.Keys.API.addPublicKey)) {
                    Method.post
                    Path { "v1" }
                    Path.keys
                    Path.`public`
                    Body(
                        .form(
                            Mailgun.Keys.PublicKey.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    public static var keys: Path<PathBuilder.Component<String>> { Path {
        "keys"
    } }

    public static var `public`: Path<PathBuilder.Component<String>> { Path {
        "public"
    } }
}
