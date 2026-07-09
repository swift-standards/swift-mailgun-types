//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies_Test_Support
import Testing

@testable import Mailgun_Reporting_Types

@Suite("Reporting Router Tests")
struct ReportingRouterTests {

    @Test("Creates correct URL for metrics API route")
    func testMetricsRouteURL() throws {
        let router: Mailgun.Reporting.API.Router = .init()

        let metricsRequest = Mailgun.Reporting.Metrics.GetAccountMetrics.Request(
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

        let api: Mailgun.Reporting.API = .metrics(.getAccountMetrics(request: metricsRequest))

        let url = router.url(for: api)
        #expect(url.path == "/v1/analytics/metrics")

        let match: Mailgun.Reporting.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.metrics))
        // Since match.metrics returns Mailgun.Reporting.Metrics.API, we can't directly test its properties here
        // This test is primarily checking that the router maps to the metrics case correctly
    }
}
