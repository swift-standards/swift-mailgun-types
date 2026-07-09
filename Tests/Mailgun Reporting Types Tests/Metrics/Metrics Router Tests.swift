//
//  Metrics Router Tests.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 29/12/2024.
//

import Dependencies_Test_Support
import Testing

@testable import Mailgun_Reporting_Types

@Suite(
    "Metrics Router Tests"
)
struct MetricsRouterTests {

    @Test("Creates correct URL and JSON body for retrieving account metrics")
    func testGetAccountMetricsRequest() throws {
        let router: Mailgun.Reporting.Metrics.API.Router = .init()

        let request = Mailgun.Reporting.Metrics.GetAccountMetrics.Request(
            start: "2024-01-01",
            end: "2024-01-31",
            resolution: "day",
            duration: "1M",
            dimensions: ["campaign"],
            metrics: ["delivered_count"],
            filter: Mailgun.Reporting.Metrics.Filter(and: [
                Mailgun.Reporting.Metrics.FilterCondition(
                    attribute: "status",
                    comparator: "eq",
                    values: [
                        Mailgun.Reporting.Metrics.FilterValue(
                            label: "Delivered",
                            value: "delivered"
                        )
                    ]
                )
            ]),
            includeSubaccounts: true,
            includeAggregates: true
        )

        let api: Mailgun.Reporting.Metrics.API = .getAccountMetrics(request: request)

        let url = router.url(for: api)
        #expect(url.path == "/v1/analytics/metrics")

        let match: Mailgun.Reporting.Metrics.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.getAccountMetrics))
        #expect(match.getAccountMetrics?.start == "2024-01-01")
        #expect(match.getAccountMetrics?.end == "2024-01-31")
        #expect(match.getAccountMetrics?.resolution == "day")
        #expect(match.getAccountMetrics?.duration == "1M")
        #expect(match.getAccountMetrics?.dimensions == ["campaign"])
        #expect(match.getAccountMetrics?.metrics == ["delivered_count"])
        #expect(match.getAccountMetrics?.filter.and.count == 1)
        #expect(match.getAccountMetrics?.filter.and.first?.attribute == "status")
        #expect(match.getAccountMetrics?.filter.and.first?.comparator == "eq")
        #expect(match.getAccountMetrics?.includeSubaccounts == true)
        #expect(match.getAccountMetrics?.includeAggregates == true)
    }
}
