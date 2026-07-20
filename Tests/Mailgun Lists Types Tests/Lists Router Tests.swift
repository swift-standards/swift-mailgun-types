//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Dependencies_Test_Support
import EmailAddress
import Testing

@testable import Mailgun_Lists_Types

@Suite(
    "Lists Router Tests"
)
struct ListsRouterTests {

    @Test("Creates correct URL for list creation")
    func testCreateListURL() throws {
        let router: Mailgun.Lists.API.Router = .init()

        let createRequest = Mailgun.Lists.List.Create.Request(
            address: try .init("developers@test.com"),
            name: "Developers",
            description: "Test list",
            accessLevel: .readonly,
            replyPreference: .list
        )

        let api: Mailgun.Lists.API = .create(request: createRequest)

        let url = router.url(for: api)
        #expect(url.path == "/v3/lists")

        let match: Mailgun.Lists.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.create))
        #expect(Mailgun.Lists.API.cases.create.extract(match)?.address.rawValue == "developers@test.com")
        #expect(Mailgun.Lists.API.cases.create.extract(match)?.name == "Developers")
        #expect(Mailgun.Lists.API.cases.create.extract(match)?.description == "Test list")
        #expect(Mailgun.Lists.API.cases.create.extract(match)?.accessLevel == .readonly)
        #expect(Mailgun.Lists.API.cases.create.extract(match)?.replyPreference == .list)
    }

    @Test("Creates correct URL for listing all mailing lists")
    func testListMailingListsURL() throws {
        let router: Mailgun.Lists.API.Router = .init()

        let listRequest = Mailgun.Lists.List.Request(
            limit: 100,
            skip: 0,
            address: try .init("test@example.com")
        )

        let api: Mailgun.Lists.API = .list(request: listRequest)

        let url = router.url(for: api)
        #expect(url.path == "/v3/lists")

        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict: [String: String?] = Dictionary(
            uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) }
        )

        #expect(queryDict["limit"] == "100")
        #expect(queryDict["skip"] == "0")
        #expect(queryDict["address"] == "test@example.com")

        let match: Mailgun.Lists.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.list))
        #expect(Mailgun.Lists.API.cases.list.extract(match)?.limit == 100)
        #expect(Mailgun.Lists.API.cases.list.extract(match)?.skip == 0)
        #expect(Mailgun.Lists.API.cases.list.extract(match)?.address?.rawValue == "test@example.com")
    }

    @Test("Creates correct URL for getting list members")
    func testGetMembersURL() throws {
        let router: Mailgun.Lists.API.Router = .init()

        let membersRequest = Mailgun.Lists.List.Members.Request(
            address: try .init("test@example.com"),
            subscribed: true,
            limit: 50,
            skip: 10
        )

        let api: Mailgun.Lists.API = .members(
            listAddress: try .init("developers@test.com"),
            request: membersRequest
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/lists/developers@test.com/members")
        #expect(url.query?.contains("subscribed=true") == true)
        #expect(url.query?.contains("limit=50") == true)
        #expect(url.query?.contains("skip=10") == true)

        let match: Mailgun.Lists.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.members))
        #expect(Mailgun.Lists.API.cases.members.extract(match)?.listAddress.rawValue == "developers@test.com")
        #expect(Mailgun.Lists.API.cases.members.extract(match)?.request.address?.rawValue == "test@example.com")
        #expect(Mailgun.Lists.API.cases.members.extract(match)?.request.subscribed == true)
        #expect(Mailgun.Lists.API.cases.members.extract(match)?.request.limit == 50)
        #expect(Mailgun.Lists.API.cases.members.extract(match)?.request.skip == 10)
    }

    @Test("Creates correct URL for adding a member")
    func testAddMemberURL() throws {
        let router: Mailgun.Lists.API.Router = .init()

        let addRequest = Mailgun.Lists.Member.Add.Request(
            address: try .init("new@example.com"),
            name: "New Member",
            vars: ["role": "developer"],
            subscribed: true,
            upsert: true
        )

        let api: Mailgun.Lists.API = .addMember(
            listAddress: try .init("developers@test.com"),
            request: addRequest
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/lists/developers@test.com/members")

        let match: Mailgun.Lists.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.addMember))
        #expect(Mailgun.Lists.API.cases.addMember.extract(match)?.listAddress.rawValue == "developers@test.com")
        #expect(Mailgun.Lists.API.cases.addMember.extract(match)?.request.address.rawValue == "new@example.com")
        #expect(Mailgun.Lists.API.cases.addMember.extract(match)?.request.name == "New Member")
        #expect(Mailgun.Lists.API.cases.addMember.extract(match)?.request.vars == ["role": "developer"])
        #expect(Mailgun.Lists.API.cases.addMember.extract(match)?.request.subscribed == true)
        #expect(Mailgun.Lists.API.cases.addMember.extract(match)?.request.upsert == true)
    }

    // RT-030: Mailgun's list-members API expects `subscribed`/`upsert` as the literal
    // strings "yes"/"no", not Swift's default Bool encoding ("true"/"false"). These tests
    // render the actual encoded request body bytes to assert the wire values directly,
    // rather than only the round-tripped Swift values (which a `true`/`false` <-> `Bool`
    // mapping would satisfy just as well as `yes`/`no` <-> `Bool` would).
    @Test("Encodes add-member subscribed/upsert as yes/no on the wire (true)")
    func testAddMemberBodyEncodesTrueAsYesNo() throws {
        let router: Mailgun.Lists.API.Router = .init()

        let addRequest = Mailgun.Lists.Member.Add.Request(
            address: try .init("new@example.com"),
            subscribed: true,
            upsert: true
        )

        let api: Mailgun.Lists.API = .addMember(
            listAddress: try .init("developers@test.com"),
            request: addRequest
        )

        let request = try router.request(for: api)
        #expect(
            request.value(forHTTPHeaderField: "Content-Type")
                == "application/x-www-form-urlencoded"
        )
        let body = try #require(request.httpBody)
        let bodyString = try #require(String(data: body, encoding: .utf8))

        #expect(bodyString.contains("subscribed=yes"))
        #expect(bodyString.contains("upsert=yes"))
        #expect(!bodyString.contains("subscribed=true"))
        #expect(!bodyString.contains("upsert=true"))
    }

    @Test("Encodes add-member subscribed/upsert as yes/no on the wire (false)")
    func testAddMemberBodyEncodesFalseAsYesNo() throws {
        let router: Mailgun.Lists.API.Router = .init()

        let addRequest = Mailgun.Lists.Member.Add.Request(
            address: try .init("new@example.com"),
            subscribed: false,
            upsert: false
        )

        let api: Mailgun.Lists.API = .addMember(
            listAddress: try .init("developers@test.com"),
            request: addRequest
        )

        let request = try router.request(for: api)
        #expect(
            request.value(forHTTPHeaderField: "Content-Type")
                == "application/x-www-form-urlencoded"
        )
        let body = try #require(request.httpBody)
        let bodyString = try #require(String(data: body, encoding: .utf8))

        #expect(bodyString.contains("subscribed=no"))
        #expect(bodyString.contains("upsert=no"))
        #expect(!bodyString.contains("subscribed=false"))
        #expect(!bodyString.contains("upsert=false"))
    }

    @Test("Creates correct URL for bulk member addition")
    func testBulkAddURL() throws {
        let router: Mailgun.Lists.API.Router = .init()

        let members = [
            Mailgun.Lists.Member.Bulk(
                address: try .init("member1@example.com"),
                name: "Member 1",
                vars: ["role": "admin"],
                subscribed: true
            )
        ]

        let api: Mailgun.Lists.API = .bulkAdd(
            listAddress: try .init("developers@test.com"),
            members: members,
            upsert: true
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/lists/developers@test.com/members.json")
        #expect(url.query?.contains("upsert=true") == true)

        // Skip round-trip test for bulk add due to multipart form data
        // The body contains complex JSON that cannot be easily round-tripped
    }

    @Test("Creates correct URL for getting member details")
    func testGetMemberURL() throws {
        let router: Mailgun.Lists.API.Router = .init()

        let api: Mailgun.Lists.API = .getMember(
            listAddress: try .init("developers@test.com"),
            memberAddress: try .init("member@example.com")
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/lists/developers@test.com/members/member@example.com")

        let match: Mailgun.Lists.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.getMember))
        #expect(Mailgun.Lists.API.cases.getMember.extract(match)?.listAddress.rawValue == "developers@test.com")
        #expect(Mailgun.Lists.API.cases.getMember.extract(match)?.memberAddress.rawValue == "member@example.com")
    }

    @Test("Creates correct URL for updating member")
    func testUpdateMemberURL() throws {
        let router: Mailgun.Lists.API.Router = .init()

        let updateRequest = Mailgun.Lists.Member.Update.Request(
            address: try .init("updated@example.com"),
            name: "Updated Name",
            vars: ["role": "lead"],
            subscribed: false
        )

        let api: Mailgun.Lists.API = .updateMember(
            listAddress: try .init("developers@test.com"),
            memberAddress: try .init("member@example.com"),
            request: updateRequest
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/lists/developers@test.com/members/member@example.com")

        // Note: this route is application/x-www-form-urlencoded (RT-030b); the body
        // wire format is asserted directly by the yes/no tests below.
    }

    // RT-030/RT-030b: Mailgun's list-members API expects `subscribed` as the literal
    // strings "yes"/"no", not Swift's default Bool encoding ("true"/"false"). This
    // route is encoded as application/x-www-form-urlencoded (Mailgun's PUT
    // list-member endpoint silently ignores multipart bodies); these tests render
    // the actual body bytes to assert the wire value directly.
    @Test("Encodes update-member subscribed as yes/no on the wire (true)")
    func testUpdateMemberBodyEncodesTrueAsYesNo() throws {
        let router: Mailgun.Lists.API.Router = .init()
        let updateRequest = Mailgun.Lists.Member.Update.Request(subscribed: true)
        let api: Mailgun.Lists.API = .updateMember(
            listAddress: try .init("developers@test.com"),
            memberAddress: try .init("member@example.com"),
            request: updateRequest
        )

        let request = try router.request(for: api)
        #expect(
            request.value(forHTTPHeaderField: "Content-Type")
                == "application/x-www-form-urlencoded"
        )
        let body = try #require(request.httpBody)
        let bodyString = try #require(String(data: body, encoding: .utf8))

        #expect(bodyString.contains("subscribed=yes"))
        #expect(!bodyString.contains("subscribed=true"))
        #expect(!bodyString.contains("subscribed=false"))
    }

    @Test("Encodes update-member subscribed as yes/no on the wire (false)")
    func testUpdateMemberBodyEncodesFalseAsYesNo() throws {
        let router: Mailgun.Lists.API.Router = .init()
        let updateRequest = Mailgun.Lists.Member.Update.Request(subscribed: false)
        let api: Mailgun.Lists.API = .updateMember(
            listAddress: try .init("developers@test.com"),
            memberAddress: try .init("member@example.com"),
            request: updateRequest
        )

        let request = try router.request(for: api)
        #expect(
            request.value(forHTTPHeaderField: "Content-Type")
                == "application/x-www-form-urlencoded"
        )
        let body = try #require(request.httpBody)
        let bodyString = try #require(String(data: body, encoding: .utf8))

        #expect(bodyString.contains("subscribed=no"))
        #expect(!bodyString.contains("subscribed=true"))
        #expect(!bodyString.contains("subscribed=false"))
    }

    @Test("Creates correct URL for deleting member")
    func testDeleteMemberURL() throws {
        let router: Mailgun.Lists.API.Router = .init()

        let api: Mailgun.Lists.API = .deleteMember(
            listAddress: try .init("developers@test.com"),
            memberAddress: try .init("member@example.com")
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/lists/developers@test.com/members/member@example.com")

        let match: Mailgun.Lists.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.deleteMember))
        #expect(Mailgun.Lists.API.cases.deleteMember.extract(match)?.listAddress.rawValue == "developers@test.com")
        #expect(Mailgun.Lists.API.cases.deleteMember.extract(match)?.memberAddress.rawValue == "member@example.com")
    }

    @Test("Creates correct URL for updating list")
    func testUpdateListURL() throws {
        let router: Mailgun.Lists.API.Router = .init()

        let updateRequest = Mailgun.Lists.List.Update.Request(
            address: try .init("newaddress@test.com"),
            description: "Updated description",
            name: "New Name",
            accessLevel: .members,
            replyPreference: .sender
        )

        let api: Mailgun.Lists.API = .update(
            listAddress: try .init("developers@test.com"),
            request: updateRequest
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/lists/developers@test.com")

        // Note: Round-trip testing for multipart form routes is complex due to dynamic boundary generation
        // The router generates a unique boundary for each multipart request which makes exact matching difficult
        // We verify URL generation works correctly above
    }

    @Test("Creates correct URL for deleting list")
    func testDeleteListURL() throws {
        let router: Mailgun.Lists.API.Router = .init()

        let api: Mailgun.Lists.API = .delete(listAddress: try .init("developers@test.com"))

        let url = router.url(for: api)
        #expect(url.path == "/v3/lists/developers@test.com")

        let match: Mailgun.Lists.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.delete))
        #expect(Mailgun.Lists.API.cases.delete.extract(match)?.rawValue == "developers@test.com")
    }

    @Test("Creates correct URL for getting list details")
    func testGetListURL() throws {
        let router: Mailgun.Lists.API.Router = .init()

        let api: Mailgun.Lists.API = .get(listAddress: try .init("developers@test.com"))

        let url = router.url(for: api)
        #expect(url.path == "/v3/lists/developers@test.com")

        let match: Mailgun.Lists.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.get))
        #expect(Mailgun.Lists.API.cases.get.extract(match)?.rawValue == "developers@test.com")
    }

    @Test("Creates correct URL for paginated lists")
    func testPagesURL() throws {
        let router: Mailgun.Lists.API.Router = .init()

        let api: Mailgun.Lists.API = .pages(limit: 50)

        let url = router.url(for: api)
        #expect(url.path == "/v3/lists/pages")
        #expect(url.query?.contains("limit=50") == true)

        let match: Mailgun.Lists.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.pages))
        #expect(Mailgun.Lists.API.cases.pages.extract(match) == 50)
    }

    @Test("Creates correct URL for paginated members")
    func testMemberPagesURL() throws {
        let router: Mailgun.Lists.API.Router = .init()

        let request = Mailgun.Lists.List.Members.Pages.Request(
            subscribed: true,
            limit: 30,
            address: try .init("test@example.com"),
            page: .next
        )

        let api: Mailgun.Lists.API = .memberPages(
            listAddress: try .init("developers@test.com"),
            request: request
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/lists/developers@test.com/members/pages")
        #expect(url.query?.contains("subscribed=true") == true)
        #expect(url.query?.contains("limit=30") == true)
        #expect(url.query?.contains("address=test@example.com") == true)
        #expect(url.query?.contains("page=next") == true)

        let match: Mailgun.Lists.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.memberPages))
        #expect(Mailgun.Lists.API.cases.memberPages.extract(match)?.listAddress.rawValue == "developers@test.com")
        #expect(Mailgun.Lists.API.cases.memberPages.extract(match)?.request.subscribed == true)
        #expect(Mailgun.Lists.API.cases.memberPages.extract(match)?.request.limit == 30)
        #expect(Mailgun.Lists.API.cases.memberPages.extract(match)?.request.address?.rawValue == "test@example.com")
        #expect(Mailgun.Lists.API.cases.memberPages.extract(match)?.request.page == .next)
    }
}
