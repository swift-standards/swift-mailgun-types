//
//  DKIM Security Router Tests.swift
//  swift-mailgun-types
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Dependencies_Test_Support
import Domain
import Testing

@testable import Mailgun_Domains_Types

@Suite("DKIM Security Router Tests")
struct DKIMSecurityRouterTests {
    @Test("Creates correct URL for updating rotation")
    func testUpdateRotationURL() throws {
        let router: Mailgun.Domains.DKIM_Security.API.Router = .init()
        let domain = try Domain("example.com")
        let request = Mailgun.Domains.DKIM_Security.Rotation.Update.Request(rotationEnabled: true)

        let api: Mailgun.Domains.DKIM_Security.API = .updateRotation(
            domain: domain,
            request: request
        )

        let url = router.url(for: api)
        #expect(url.path == "/v1/dkim_management/domains/example.com/rotation")

        let match: Mailgun.Domains.DKIM_Security.API = try router.match(
            request: try router.request(for: api)
        )

        #expect(match.is(\.updateRotation))
        #expect(match.updateRotation?.domain == domain)
    }
}
