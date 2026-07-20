import Foundation
import Testing
import URL_Routing_Test_Support
@testable import Mailgun_Keys_Types

@Suite("Mailgun.Keys Router Parity")
struct KeysParityTests {
    let router = Mailgun.Keys.API.Router()

    var routes: [(name: String, route: Mailgun.Keys.API)] {
        get throws {
            [
                ("list", .list),
                (
                    "create",
                    .create(
                        request: .init(
                            description: "Parity fixture key",
                            role: "admin",
                            kind: "user"
                        )
                    )
                ),
                ("delete", .delete(keyId: "parity-key-id")),
                (
                    "addPublicKey",
                    .addPublicKey(
                        request: .init(publicKey: "pubkey-parity-fixture-0123456789")
                    )
                )
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(try Parity.corpus(of: routes, via: router), area: "Keys")
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router)
    }
}
