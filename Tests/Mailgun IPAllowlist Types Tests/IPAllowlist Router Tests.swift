//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies_Test_Support
import Testing

@testable import Mailgun_IPAllowlist_Types

@Suite(
    "IPAllowlist Router Tests"
)
struct IPAllowlistRouterTests {

    @Test("Creates correct URL for listing IP allowlist")
    func testListIPAllowlistURL() throws {
        let router: Mailgun.IPAllowlist.API.Router = .init()

        let api: Mailgun.IPAllowlist.API = .list

        let url = router.url(for: api)
        #expect(url.path == "/v2/ip_allowlist")

        let match: Mailgun.IPAllowlist.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.list))
        // Success - case matches
    }
}
