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
        #expect(Mailgun.Reporting.Metrics.API.cases.getAccountMetrics.extract(match)?.start == "2024-01-01")
        #expect(Mailgun.Reporting.Metrics.API.cases.getAccountMetrics.extract(match)?.end == "2024-01-31")
        #expect(Mailgun.Reporting.Metrics.API.cases.getAccountMetrics.extract(match)?.resolution == "day")
        #expect(Mailgun.Reporting.Metrics.API.cases.getAccountMetrics.extract(match)?.duration == "1M")
        #expect(Mailgun.Reporting.Metrics.API.cases.getAccountMetrics.extract(match)?.dimensions == ["campaign"])
        #expect(Mailgun.Reporting.Metrics.API.cases.getAccountMetrics.extract(match)?.metrics == ["delivered_count"])
        #expect(Mailgun.Reporting.Metrics.API.cases.getAccountMetrics.extract(match)?.filter.and.count == 1)
        #expect(Mailgun.Reporting.Metrics.API.cases.getAccountMetrics.extract(match)?.filter.and.first?.attribute == "status")
        #expect(Mailgun.Reporting.Metrics.API.cases.getAccountMetrics.extract(match)?.filter.and.first?.comparator == "eq")
        #expect(Mailgun.Reporting.Metrics.API.cases.getAccountMetrics.extract(match)?.includeSubaccounts == true)
        #expect(Mailgun.Reporting.Metrics.API.cases.getAccountMetrics.extract(match)?.includeAggregates == true)
    }
}
