import Foundation
import Testing
import URL_Routing_Test_Support
@testable import Mailgun_Lists_Types

@Suite("Mailgun.Lists Router Parity")
struct ListsParityTests {
    let router = Mailgun.Lists.API.Router()

    var routes: [(name: String, route: Mailgun.Lists.API)] {
        get throws {
            [
                (
                    "create",
                    .create(
                        request: .init(
                            address: try .init("developers@parity.example.com"),
                            name: "Developers",
                            description: "Parity corpus list",
                            accessLevel: .members,
                            replyPreference: .list
                        )
                    )
                ),
                (
                    "list",
                    .list(request: .init(limit: 25, skip: 5, address: try .init("developers@parity.example.com")))
                ),
                (
                    "list-empty",
                    .list(request: .init())
                ),
                (
                    "members",
                    .members(
                        listAddress: try .init("developers@parity.example.com"),
                        request: .init(
                            address: try .init("member@parity.example.com"),
                            subscribed: true,
                            limit: 10,
                            skip: 2
                        )
                    )
                ),
                (
                    "addMember",
                    .addMember(
                        listAddress: try .init("developers@parity.example.com"),
                        request: .init(
                            address: try .init("new@parity.example.com"),
                            name: "New Member",
                            // Single-entry vars keeps form field order deterministic.
                            vars: ["role": "developer"],
                            subscribed: true,
                            upsert: false
                        )
                    )
                ),
                (
                    "bulkAdd",
                    .bulkAdd(
                        listAddress: try .init("developers@parity.example.com"),
                        members: [
                            .init(
                                address: try .init("bulk1@parity.example.com"),
                                name: "Bulk One",
                                vars: ["seat": "1"],
                                subscribed: true
                            ),
                            .init(
                                address: try .init("bulk2@parity.example.com"),
                                name: "Bulk Two",
                                subscribed: false
                            )
                        ],
                        upsert: true
                    )
                ),
                (
                    "bulkAddCSV",
                    .bulkAddCSV(
                        listAddress: try .init("developers@parity.example.com"),
                        request: Foundation.Data("address,name\ncsv@parity.example.com,CSV Member\n".utf8),
                        subscribed: true,
                        upsert: false
                    )
                ),
                (
                    "getMember",
                    .getMember(
                        listAddress: try .init("developers@parity.example.com"),
                        memberAddress: try .init("member@parity.example.com")
                    )
                ),
                (
                    "updateMember",
                    .updateMember(
                        listAddress: try .init("developers@parity.example.com"),
                        memberAddress: try .init("member@parity.example.com"),
                        request: .init(
                            address: try .init("renamed@parity.example.com"),
                            name: "Renamed Member",
                            vars: ["role": "maintainer"],
                            subscribed: false
                        )
                    )
                ),
                (
                    "deleteMember",
                    .deleteMember(
                        listAddress: try .init("developers@parity.example.com"),
                        memberAddress: try .init("member@parity.example.com")
                    )
                ),
                (
                    "update",
                    .update(
                        listAddress: try .init("developers@parity.example.com"),
                        request: .init(
                            address: try .init("renamed-list@parity.example.com"),
                            description: "Updated parity list",
                            name: "Renamed List",
                            accessLevel: .readonly,
                            replyPreference: .sender,
                            listId: "parity-list-id"
                        )
                    )
                ),
                ("delete", .delete(listAddress: try .init("developers@parity.example.com"))),
                ("get", .get(listAddress: try .init("developers@parity.example.com"))),
                ("pages", .pages(limit: 50)),
                ("pages-empty", .pages(limit: nil)),
                (
                    "memberPages",
                    .memberPages(
                        listAddress: try .init("developers@parity.example.com"),
                        request: .init(
                            subscribed: true,
                            limit: 20,
                            address: try .init("member@parity.example.com"),
                            page: .next
                        )
                    )
                )
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(try Parity.corpus(of: routes, via: router), area: "Lists")
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router, excluding: ["bulkAdd", "update"])
    }
}
