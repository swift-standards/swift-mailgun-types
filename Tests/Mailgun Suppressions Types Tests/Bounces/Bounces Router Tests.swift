//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Dependencies_Test_Support
import Domain_Standard
import EmailAddress
import Testing

@testable import Mailgun_Suppressions_Types

@Suite(
    "Bounces Router Tests"
)
struct BouncesRouterTests {

    @Test("Creates correct URL for importing bounce list")
    func testImportBouncesURL() throws {
        let router: Mailgun.Suppressions.Bounces.API.Router = .init()

        let testData = Data("test".utf8)
        let api: Mailgun.Suppressions.Bounces.API = .importList(
            domain: try .init("test.domain.com"),
            request: testData
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/bounces/import")

        // Note: Import endpoints use multipart form data which doesn't support round-trip testing
        // due to the complex nature of multipart boundary generation and Data encoding
    }

    @Test("Creates correct URL for getting specific bounce")
    func testGetBounceURL() throws {
        let router: Mailgun.Suppressions.Bounces.API.Router = .init()

        let api: Mailgun.Suppressions.Bounces.API = .get(
            domain: try .init("test.domain.com"),
            address: try .init("test@example.com")
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/bounces/test@example.com")

        let match: Mailgun.Suppressions.Bounces.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.get))
        let expected1 = try Domain("test.domain.com")
        #expect(match.get?.domain == expected1)
        let expected2 = try EmailAddress("test@example.com")
        #expect(match.get?.address == expected2)
    }

    @Test("Creates correct URL for deleting specific bounce")
    func testDeleteBounceURL() throws {
        let router: Mailgun.Suppressions.Bounces.API.Router = .init()

        let api: Mailgun.Suppressions.Bounces.API = .delete(
            domain: try .init("test.domain.com"),
            address: try .init("test@example.com")
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/bounces/test@example.com")

        let match: Mailgun.Suppressions.Bounces.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.delete))
        let expected3 = try Domain("test.domain.com")
        #expect(match.delete?.domain == expected3)
        let expected4 = try EmailAddress("test@example.com")
        #expect(match.delete?.address == expected4)
    }

    @Test("Creates correct URL for listing bounces with query parameters")
    func testListBouncesURL() throws {
        let router: Mailgun.Suppressions.Bounces.API.Router = .init()

        let request = Mailgun.Suppressions.Bounces.List.Request(
            limit: 25,
            page: "next",
            term: "test"
        )

        let api: Mailgun.Suppressions.Bounces.API = .list(
            domain: try .init("test.domain.com"),
            request: request
        )

        let url = router.url(for: api)
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict: [String: String?] = Dictionary(
            uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) }
        )

        #expect(url.path == "/v3/test.domain.com/bounces")
        #expect(queryDict["limit"] == "25")
        #expect(queryDict["page"] == "next")
        #expect(queryDict["term"] == "test")

        let match: Mailgun.Suppressions.Bounces.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.list))
        let expected5 = try Domain("test.domain.com")
        #expect(match.list?.domain == expected5)
        #expect(match.list?.request?.limit == 25)
        #expect(match.list?.request?.page == "next")
        #expect(match.list?.request?.term == "test")
    }

    @Test("Creates correct URL for creating bounce")
    func testCreateBounceURL() throws {
        let router: Mailgun.Suppressions.Bounces.API.Router = .init()

        let request = Mailgun.Suppressions.Bounces.Create.Request(
            address: try .init("test@example.com"),
            code: "550",
            error: "Test error",
            createdAt: "2024-12-27"
        )

        let api: Mailgun.Suppressions.Bounces.API = .create(
            domain: try .init("test.domain.com"),
            request: request
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/bounces")

        let match: Mailgun.Suppressions.Bounces.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.create))
        let expected6 = try Domain("test.domain.com")
        #expect(match.create?.domain == expected6)
        let expected7 = try EmailAddress("test@example.com")
        #expect(match.create?.request.address == expected7)
        #expect(match.create?.request.code == "550")
        #expect(match.create?.request.error == "Test error")
        #expect(match.create?.request.createdAt == "2024-12-27")
    }

    @Test("Creates correct URL for deleting all bounces")
    func testDeleteAllBouncesURL() throws {
        let router: Mailgun.Suppressions.Bounces.API.Router = .init()

        let api: Mailgun.Suppressions.Bounces.API = .deleteAll(domain: try .init("test.domain.com"))

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/bounces")

        let match: Mailgun.Suppressions.Bounces.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.deleteAll))
        let expected8 = try Domain("test.domain.com")
        #expect(match.deleteAll == expected8)
    }
}
