//
//  Tags.Router.Tests.swift
//  swift-mailgun
//
//  Created by Claude on 31/12/2024.
//

import Dependencies_Test_Support
import Testing

@testable import Mailgun_Reporting_Types

@Suite(
    "Tags Router Tests"
)
struct TagsRouterTests {

    @Test("Creates correct URL for listing tags")
    func testListTagsURL() throws {
        let router: Mailgun.Reporting.Tags.API.Router = .init()

        let request = Mailgun.Reporting.Tags.List.Request(
            page: "first",
            limit: 100
        )

        let api: Mailgun.Reporting.Tags.API = .list(domain: try .init("test.com"), request: request)

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.com/tags")

        let match: Mailgun.Reporting.Tags.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.list))
        let expected1 = try Domain("test.com")
        #expect(Mailgun.Reporting.Tags.API.cases.list.extract(match)?.domain == expected1)
    }
}
