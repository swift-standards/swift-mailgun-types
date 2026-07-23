//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Dependencies_Test_Support
import URL_Routing_Foundation_Integration
import Domain_Standard
import EmailAddress
import Testing

@testable import Mailgun_Suppressions_Types

@Suite(
    "Unsubscribe Router Tests"
)
struct UnsubscribeRouterTests {

    @Test("Creates correct URL for importing unsubscribe list")
    func testImportUnsubscribeURL() throws {
        let router: Mailgun.Suppressions.Unsubscribe.API.Router = .init()

        let testData = Data("test".utf8)
        let api: Mailgun.Suppressions.Unsubscribe.API = .importList(
            domain: try .init("test.domain.com"),
            request: .init(file: testData)
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/unsubscribes/import")

        // Note: Import endpoints use multipart form data which doesn't support round-trip testing
        // due to the complex nature of multipart boundary generation and Data encoding
    }

    @Test("Creates correct URL for getting specific unsubscribe")
    func testGetUnsubscribeURL() throws {
        let router: Mailgun.Suppressions.Unsubscribe.API.Router = .init()

        let api: Mailgun.Suppressions.Unsubscribe.API = .get(
            domain: try .init("test.domain.com"),
            address: try .init("test@example.com")
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/unsubscribes/test@example.com")

        let match: Mailgun.Suppressions.Unsubscribe.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.get))
        let expected1 = try Domain("test.domain.com")
        #expect(Mailgun.Suppressions.Unsubscribe.API.cases.get.extract(match)?.domain == expected1)
    }
}
