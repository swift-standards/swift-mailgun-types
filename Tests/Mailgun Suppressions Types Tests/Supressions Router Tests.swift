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
    "Suppressions Router Tests"
)
struct SuppressionsRouterTests {

    @Test("Routes bounce requests correctly")
    func testBouncesRouting() throws {
        let router: Mailgun.Suppressions.API.Router = .init()

        let listRequest = Mailgun.Suppressions.Bounces.List.Request(limit: 25)
        let bouncesAPI = Mailgun.Suppressions.Bounces.API.list(
            domain: try .init("test.domain.com"),
            request: listRequest
        )
        let api: Mailgun.Suppressions.API = .bounces(bouncesAPI)

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/bounces")

        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryDict = Dictionary(
            uniqueKeysWithValues: (components?.queryItems ?? []).map { ($0.name, $0.value) }
        )
        #expect(queryDict["limit"] == "25")

        let match: Mailgun.Suppressions.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.bounces))
        let expected1 = try Domain("test.domain.com")
        #expect(
            Mailgun.Suppressions.API.cases.bounces.extract(match)
                .flatMap { Mailgun.Suppressions.Bounces.API.cases.list.extract($0) }?
                .domain == expected1
        )
    }
}
