import Foundation
import Testing
import URL_Routing_Test_Support
@testable import Mailgun_CustomMessageLimit_Types

@Suite("Mailgun.CustomMessageLimit Router Parity")
struct CustomMessageLimitParityTests {
    let router = Mailgun.CustomMessageLimit.API.Router()

    var routes: [(name: String, route: Mailgun.CustomMessageLimit.API)] {
        get throws {
            [
                ("getMonthly", .getMonthly),
                ("setMonthly", .setMonthly(request: .init(limit: 50000))),
                ("deleteMonthly", .deleteMonthly),
                ("enableAccount", .enableAccount)
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(
            try Parity.corpus(of: routes, via: router),
            area: "CustomMessageLimit"
        )
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router)
    }
}
