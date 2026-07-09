//
//  IPs Router Tests.swift
//  swift-mailgun-types
//
//  Created by Assistant on 05/08/2025.
//

import Dependencies_Test_Support
import Domain
import Testing

@testable import Mailgun_IPs_Types

@Suite("IPs Router Tests")
struct IPsRouterTests {
    @Test("Creates correct URL for listing IPs")
    func testListIPsURL() throws {
        let router: Mailgun.IPs.API.Router = .init()

        let api: Mailgun.IPs.API = .list

        let url = router.url(for: api)
        #expect(url.path == "/v3/ips")

        let match: Mailgun.IPs.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.list))
    }
}
