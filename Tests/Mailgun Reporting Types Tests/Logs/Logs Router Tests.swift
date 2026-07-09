//
//  Logs.Router.Tests.swift
//  swift-mailgun-types
//
//  Created by Coen ten Thije Boonkkamp on 31/12/2024.
//

import Dependencies_Test_Support
import Testing

@testable import Mailgun_Reporting_Types

@Suite(
    "Logs Router Tests"
)
struct LogsRouterTests {

    @Test("Creates correct URL for analytics endpoint")
    func testAnalyticsURL() throws {
        let router: Mailgun.Reporting.Logs.API.Router = .init()

        let request = Mailgun.Reporting.Logs.Analytics.Request(
            action: "delivered",
            groupBy: "domain",
            startDate: Date(timeIntervalSince1970: 1_640_995_200),  // 2022-01-01
            endDate: Date(timeIntervalSince1970: 1_641_081_600),  // 2022-01-02
            filter: .init(
                and: [
                    .init(field: "domain", operator: .equals, value: .string("example.com")),
                    .init(field: "status", operator: .equals, value: .string("success")),
                ]
            ),
            include: [.actions, .total],
            page: .init(size: 100, number: 1, sort: "timestamp")
        )

        let api: Mailgun.Reporting.Logs.API = .analytics(request: request)

        let url = router.url(for: api)
        #expect(url.path == "/v1/analytics/logs")

        let match: Mailgun.Reporting.Logs.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.analytics))
        #expect(match.analytics?.action == "delivered")
        #expect(match.analytics?.filter?.and?.count == 2)
        #expect(match.analytics?.filter?.or?.count == nil)
        #expect(match.analytics?.filter?.and?.first?.field == "domain")
        #expect(match.analytics?.filter?.and?.first?.operator == .equals)
        if case .string(let value) = match.analytics?.filter?.and?.first?.value {
            #expect(value == "example.com")
        }
    }
}
