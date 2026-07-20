import Foundation
import Testing
import URL_Routing_Test_Support
@testable import Mailgun_IPPools_Types

@Suite("Mailgun.IPPools Router Parity")
struct IPPoolsParityTests {
    let router = Mailgun.IPPools.API.Router()

    var routes: [(name: String, route: Mailgun.IPPools.API)] {
        get throws {
            [
                ("list", .list),
                (
                    "create",
                    .create(
                        request: .init(
                            name: "parity-pool",
                            description: "Parity fixture pool",
                            ips: ["192.161.0.1", "192.161.0.2"]
                        )
                    )
                ),
                ("get", .get(poolId: "parity-pool-id")),
                (
                    "update",
                    .update(
                        poolId: "parity-pool-id",
                        request: .init(
                            name: "parity-pool-renamed",
                            description: "Updated parity fixture pool",
                            addIps: ["192.161.0.3"],
                            removeIps: ["192.161.0.1"]
                        )
                    )
                ),
                (
                    "delete.query",
                    .delete(
                        poolId: "parity-pool-id",
                        request: .init(ip: "192.161.0.1", poolId: "replacement-pool-id")
                    )
                ),
                ("delete.bare", .delete(poolId: "parity-pool-id", request: nil)),
                ("listDomains", .listDomains(poolId: "parity-pool-id"))
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(try Parity.corpus(of: routes, via: router), area: "IPPools")
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router, excluding: ["delete.bare"])
    }
}

@Suite("Mailgun.DynamicIPPools Router Parity")
struct DynamicIPPoolsParityTests {
    let router = Mailgun.DynamicIPPools.API.Router()

    var routes: [(name: String, route: Mailgun.DynamicIPPools.API)] {
        get throws {
            [
                (
                    "listHistory.full",
                    .listHistory(
                        request: .init(
                            limit: 25,
                            includeSubaccounts: true,
                            domain: "parity.example.com",
                            before: "cursor-before",
                            after: "cursor-after",
                            movedTo: "pool-b",
                            movedFrom: "pool-a"
                        )
                    )
                ),
                ("listHistory.empty", .listHistory(request: .init())),
                ("removeOverride", .removeOverride(domain: "parity.example.com"))
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(
            try Parity.corpus(of: routes, via: router),
            area: "IPPools.Dynamic"
        )
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router)
    }
}
