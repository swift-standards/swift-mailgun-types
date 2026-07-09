//
//  Stats Router Tests.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 29/12/2024.
//

import Dependencies_Test_Support
import Testing

@testable import Mailgun_Reporting_Types

@Suite(
    "Stats Router Tests"
)
struct StatsRouterTests {

    @Test("Creates correct URL for retrieving total stats")
    func testGetTotalStatsURL() throws {
        let router: Mailgun.Reporting.Stats.API.Router = .init()

        let request = Mailgun.Reporting.Stats.Total.Request(
            event: "delivered",
            start: "2024-01-01",
            end: "2024-01-31",
            resolution: "day",
            duration: "1M"
        )

        let api: Mailgun.Reporting.Stats.API = .total(request: request)

        let url = router.url(for: api)
        #expect(url.path == "/v3/stats/total")

        let match: Mailgun.Reporting.Stats.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.total))
        #expect(match.total?.event == "delivered")
    }
}
