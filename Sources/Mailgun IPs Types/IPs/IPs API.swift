//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.IPs {
    @CasePathable
    @dynamicMemberLookup
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
                URLRouting.Route(.case(Mailgun.IPs.API.list)) {
                    Method.get
                    Path { "v3" }
                    Path.ips
                }

                URLRouting.Route(.case(Mailgun.IPs.API.get)) {
                    Method.get
                    Path { "v3" }
                    Path.ips
                    Path { Parse(.string) }
                }

                URLRouting.Route(.case(Mailgun.IPs.API.listDomains)) {
                    Method.get
                    Path { "v3" }
                    Path.ips
                    Path { Parse(.string) }
                    Path { "domains" }
                }

                URLRouting.Route(.case(Mailgun.IPs.API.assignDomain)) {
                    Method.post
                    Path { "v3" }
                    Path.ips
                    Path { Parse(.string) }
                    Path { "domains" }
                    Body(
                        .form(
                            Mailgun.IPs.AssignDomain.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.IPs.API.unassignDomain)) {
                    Method.delete
                    Path { "v3" }
                    Path.ips
                    Path { Parse(.string) }
                    Path { "domains" }
                    Path { Parse(.string) }
                }

                URLRouting.Route(.case(Mailgun.IPs.API.assignIPBand)) {
                    Method.post
                    Path { "v3" }
                    Path.ips
                    Path { Parse(.string) }
                    Path.ipBand
                    Body(
                        .form(Mailgun.IPs.IPBand.Request.self, decoder: .mailgun, encoder: .mailgun)
                    )
                }

                URLRouting.Route(.case(Mailgun.IPs.API.requestNew)) {
                    Method.post
                    Path { "v3" }
                    Path.ips
                    Path { "request" }
                    Path { "new" }
                    Body(
                        .form(
                            Mailgun.IPs.RequestNew.Request.self,
                            decoder: .mailgun,
                            encoder: .mailgun
                        )
                    )
                }

                URLRouting.Route(.case(Mailgun.IPs.API.getRequestedIPs)) {
                    Method.get
                    Path { "v3" }
                    Path.ips
                    Path { "request" }
                    Path { "new" }
                }

                URLRouting.Route(.case(Mailgun.IPs.API.deleteDomainIP)) {
                    Method.delete
                    Path { "v3" }
                    Path { "domains" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.ips
                    Path { Parse(.string) }
                }

                URLRouting.Route(.case(Mailgun.IPs.API.deleteDomainPool)) {
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
