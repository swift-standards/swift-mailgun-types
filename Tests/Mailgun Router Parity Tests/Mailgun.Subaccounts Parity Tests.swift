import Foundation
import Testing
import URL_Routing_Test_Support
@testable import Mailgun_Subaccounts_Types

@Suite("Mailgun.Subaccounts Router Parity")
struct SubaccountsParityTests {
    let router = Mailgun.Subaccounts.API.Router()

    var routes: [(name: String, route: Mailgun.Subaccounts.API)] {
        get throws {
            [
                ("get", .get(subaccountId: "parity-subaccount-id")),
                (
                    "list",
                    .list(
                        request: .init(
                            sort: .asc,
                            filter: "parity-filter",
                            limit: 10,
                            skip: 2,
                            enabled: true,
                            closed: false
                        )
                    )
                ),
                ("list-nil", .list(request: nil)),
                ("create", .create(request: .init(name: "Parity Subaccount"))),
                ("delete", .delete(subaccountId: "parity-subaccount-id")),
                (
                    "disable",
                    .disable(
                        subaccountId: "parity-subaccount-id",
                        request: .init(reason: "abuse", note: "parity fixture note")
                    )
                ),
                ("disable-nil", .disable(subaccountId: "parity-subaccount-id", request: nil)),
                ("enable", .enable(subaccountId: "parity-subaccount-id")),
                ("getCustomLimit", .getCustomLimit(subaccountId: "parity-subaccount-id")),
                ("updateCustomLimit", .updateCustomLimit(subaccountId: "parity-subaccount-id", limit: 50000.0)),
                ("deleteCustomLimit", .deleteCustomLimit(subaccountId: "parity-subaccount-id")),
                (
                    "updateFeatures",
                    .updateFeatures(
                        subaccountId: "parity-subaccount-id",
                        request: .init(
                            emailPreview: .init(enabled: true),
                            inboxPlacement: .init(enabled: false),
                            sending: .init(enabled: true),
                            validations: .init(enabled: false),
                            validationsBulk: .init(enabled: true)
                        )
                    )
                )
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(try Parity.corpus(of: routes, via: router), area: "Subaccounts")
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router, excluding: ["disable-nil", "list-nil"])
    }
}
