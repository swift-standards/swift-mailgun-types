//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.IPs {
    @Cases
    public enum API: Equatable, Sendable {
        case list
        case get(ip: String)
        case listDomains(ip: String)
        case assignDomain(ip: String, request: Mailgun.IPs.AssignDomain.Request)
        case unassignDomain(ip: String, domain: String)
        case assignIPBand(ip: String, request: Mailgun.IPs.IPBand.Request)
        case requestNew(request: Mailgun.IPs.RequestNew.Request)
        case getRequestedIPs
        case deleteDomainIP(domain: Domain, ip: String)
        case deleteDomainPool(domain: Domain, ip: String)
    }
}

extension Mailgun.IPs.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.IPs.API> {
            OneOf {
                URLRouting.Route(.case(Mailgun.IPs.API.cases.list)) {
                    Method.get
                    Path { "v3" }
                    Path.ips
                }

                URLRouting.Route(.case(Mailgun.IPs.API.cases.get)) {
                    Method.get
                    Path { "v3" }
                    Path.ips
                    Path { Parse(.string) }
                }

                URLRouting.Route(.case(Mailgun.IPs.API.cases.listDomains)) {
                    Method.get
                    Path { "v3" }
                    Path.ips
                    Path { Parse(.string) }
                    Path { "domains" }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (ip: $0.0, request: $0.1) },
                        unapply: { ($0.ip, $0.request) }
                    )
                    .map(.case(Mailgun.IPs.API.cases.assignDomain))
                ) {
                    Method.post
                    Path { "v3" }
                    Path.ips
                    Path { Parse(.string) }
                    Path { "domains" }
                    URLRouting.Body(coding:
                        .form(
                            Mailgun.IPs.AssignDomain.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(
                    .convert(
                        apply: { (ip: $0.0, domain: $0.1) },
                        unapply: { ($0.ip, $0.domain) }
                    )
                    .map(.case(Mailgun.IPs.API.cases.unassignDomain))
                ) {
                    Method.delete
                    Path { "v3" }
                    Path.ips
                    Path { Parse(.string) }
                    Path { "domains" }
                    Path { Parse(.string) }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (ip: $0.0, request: $0.1) },
                        unapply: { ($0.ip, $0.request) }
                    )
                    .map(.case(Mailgun.IPs.API.cases.assignIPBand))
                ) {
                    Method.post
                    Path { "v3" }
                    Path.ips
                    Path { Parse(.string) }
                    Path.ipBand
                    URLRouting.Body(coding:
                        .form(Mailgun.IPs.IPBand.Request.self, decoder: .mailgun, encoder: .mailgun)
                    )
                }

                URLRouting.Route(.case(Mailgun.IPs.API.cases.requestNew)) {
                    Method.post
                    Path { "v3" }
                    Path.ips
                    Path { "request" }
                    Path { "new" }
                    URLRouting.Body(coding:
                        .form(
                            Mailgun.IPs.RequestNew.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.IPs.API.cases.getRequestedIPs)) {
                    Method.get
                    Path { "v3" }
                    Path.ips
                    Path { "request" }
                    Path { "new" }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (domain: $0.0, ip: $0.1) },
                        unapply: { ($0.domain, $0.ip) }
                    )
                    .map(.case(Mailgun.IPs.API.cases.deleteDomainIP))
                ) {
                    Method.delete
                    Path { "v3" }
                    Path { "domains" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.ips
                    Path { Parse(.string) }
                }

                URLRouting.Route(
                    .convert(
                        apply: { (domain: $0.0, ip: $0.1) },
                        unapply: { ($0.domain, $0.ip) }
                    )
                    .map(.case(Mailgun.IPs.API.cases.deleteDomainPool))
                ) {
                    Method.delete
                    Path { "v3" }
                    Path { "domains" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path { "pool" }
                    Path { Parse(.string) }
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    public static var ips: Path<PathBuilder.Component<String>> { Path {
        "ips"
    } }

    public static var ipBand: Path<PathBuilder.Component<String>> { Path {
        "ip_band"
    } }
}
