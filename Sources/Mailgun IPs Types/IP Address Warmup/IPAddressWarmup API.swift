//
//  IPAddressWarmup API.swift
//  swift-mailgun-types
//
//  Created by Assistant on 05/08/2025.
//

import Mailgun_Types_Shared

extension Mailgun.IPAddressWarmup {
    @Cases
    public enum API: Equatable, Sendable {
        case list
        case get(ip: String)
        case create(ip: String, request: Mailgun.IPAddressWarmup.Create.Request)
        case delete(ip: String)
    }
}

extension Mailgun.IPAddressWarmup.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.IPAddressWarmup.API> {
            OneOf {
                URLRouting.Route(.case(Mailgun.IPAddressWarmup.API.cases.list)) {
                    Method.get
                    Path { "v3" }
                    Path.ipWarmups
                }

                URLRouting.Route(.case(Mailgun.IPAddressWarmup.API.cases.get)) {
                    Method.get
                    Path { "v3" }
                    Path.ipWarmups
                    Path { Parse(.string) }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (ip: $0.0, request: $0.1) },
                        unapply: { ($0.ip, $0.request) }
                    )
                    .map(.case(Mailgun.IPAddressWarmup.API.cases.create))
                ) {
                    Method.post
                    Path { "v3" }
                    Path.ipWarmups
                    Path { Parse(.string) }
                    URLRouting.Body(
                        .form(
                            Mailgun.IPAddressWarmup.Create.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.IPAddressWarmup.API.cases.delete)) {
                    Method.delete
                    Path { "v3" }
                    Path.ipWarmups
                    Path { Parse(.string) }
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    public static var ipWarmups: Path<PathBuilder.Component<String>> { Path {
        "ip_warmups"
    } }
}
