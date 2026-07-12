//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Dependencies_Test_Support
import Domain_Standard
import Testing

@testable import Mailgun_Webhooks_Types

@Suite("Mailgun Router Webhooks URL Tests")
struct WebhooksRouterTests {

    @Test("Creates correct URL for listing webhooks")
    func testListWebhooksURL() throws {
        let router: Mailgun.Webhooks.API.Router = .init()

        let api: Mailgun.Webhooks.API = .list(domain: try .init("test.domain.com"))

        let url = router.url(for: api)
        #expect(url.path == "/v3/domains/test.domain.com/webhooks")

        let match: Mailgun.Webhooks.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.list))
        let expected1 = try Domain("test.domain.com")
        #expect(Mailgun.Webhooks.API.cases.list.extract(match) == expected1)
    }
}
