//
//  Domain Keys Router Tests.swift
//  swift-mailgun-types
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Dependencies_Test_Support
import Domain
import Testing

@testable import Mailgun_Domains_Types

@Suite("Domain Keys Router Tests")
struct DomainKeysRouterTests {
    @Test("Creates correct URL for listing keys")
    func testListKeysURL() throws {
        let router: Mailgun.Domains.DomainKeys.API.Router = .init()

        let api: Mailgun.Domains.DomainKeys.API = .list(request: nil)

        let url = router.url(for: api)
        #expect(url.path == "/v1/dkim/keys")

        let match: Mailgun.Domains.DomainKeys.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.list))
    }
}
