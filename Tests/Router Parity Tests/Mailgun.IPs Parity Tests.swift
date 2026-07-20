import Foundation
import Testing
import URL_Routing_Test_Support
@testable import Mailgun_IPs_Types

@Suite("Mailgun.IPs Router Parity")
struct IPsParityTests {
    let router = Mailgun.IPs.API.Router()

    var routes: [(name: String, route: Mailgun.IPs.API)] {
        get throws {
            [
                ("list", .list),
                ("get", .get(ip: "192.161.0.1")),
                ("listDomains", .listDomains(ip: "192.161.0.1")),
                (
                    "assignDomain",
                    .assignDomain(
                        ip: "192.161.0.1",
                        request: .init(domain: "parity.example.com")
                    )
                ),
                (
                    "unassignDomain",
                    .unassignDomain(ip: "192.161.0.1", domain: "parity.example.com")
                ),
                (
                    "assignIPBand",
                    .assignIPBand(
                        ip: "192.161.0.1",
                        request: .init(ipBand: "standard")
                    )
                ),
                ("requestNew", .requestNew(request: .init(count: 3))),
                ("getRequestedIPs", .getRequestedIPs),
                (
                    "deleteDomainIP",
                    .deleteDomainIP(
                        domain: try .init("parity.example.com"),
                        ip: "192.161.0.1"
                    )
                ),
                (
                    "deleteDomainPool",
                    .deleteDomainPool(
                        domain: try .init("parity.example.com"),
                        ip: "192.161.0.1"
                    )
                )
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(try Parity.corpus(of: routes, via: router), area: "IPs")
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router)
    }
}

@Suite("Mailgun.IPAddressWarmup Router Parity")
struct IPAddressWarmupParityTests {
    let router = Mailgun.IPAddressWarmup.API.Router()

    var routes: [(name: String, route: Mailgun.IPAddressWarmup.API)] {
        get throws {
            [
                ("list", .list),
                ("get", .get(ip: "192.161.0.1")),
                (
                    "create.full",
                    .create(
                        ip: "192.161.0.1",
                        request: .init(enabled: true, volumeDailyCapacity: 1000)
                    )
                ),
                (
                    "create.empty",
                    .create(ip: "192.161.0.1", request: .init())
                ),
                ("delete", .delete(ip: "192.161.0.1"))
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(try Parity.corpus(of: routes, via: router), area: "IPs.Warmup")
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router)
    }
}
