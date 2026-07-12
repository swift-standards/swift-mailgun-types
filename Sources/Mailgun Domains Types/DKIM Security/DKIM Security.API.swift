//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Domains.DKIM_Security {
    @Cases
    public enum API: Equatable, Sendable {
        case updateRotation(
            domain: Domain,
            request: Mailgun.Domains.DKIM_Security.Rotation.Update.Request
        )
        case rotateManually(domain: Domain)
    }
}

extension Mailgun.Domains.DKIM_Security.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Domains.DKIM_Security.API> {
            OneOf {
                URLRouting.Route(
                    .convert(
                        apply: { (domain: $0.0, request: $0.1) },
                        unapply: { ($0.domain, $0.request) }
                    )
                    .map(.case(Mailgun.Domains.DKIM_Security.API.cases.updateRotation))
                ) {
                    Method.put
                    Path { "v1" }
                    Path { "dkim_management" }
                    Path { "domains" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path { "rotation" }
                    URLRouting.Body(
                        .form(
                            Mailgun.Domains.DKIM_Security.Rotation.Update.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.Domains.DKIM_Security.API.cases.rotateManually)) {
                    Method.post
                    Path { "v1" }
                    Path { "dkim_management" }
                    Path { "domains" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path { "rotate" }
                }
            }
        }
    }
}
