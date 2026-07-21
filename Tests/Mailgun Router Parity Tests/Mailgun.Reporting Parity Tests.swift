import Foundation
import Testing
import URL_Routing_Test_Support
@testable import Mailgun_Reporting_Types

@Suite("Mailgun.Reporting.Metrics Router Parity")
struct ReportingMetricsParityTests {
    let router = Mailgun.Reporting.Metrics.API.Router()

    var routes: [(name: String, route: Mailgun.Reporting.Metrics.API)] {
        get throws {
            let filter = Mailgun.Reporting.Metrics.Filter(
                and: [
                    .init(
                        attribute: "domain",
                        comparator: "=",
                        values: [.init(label: "parity.example.com", value: "parity.example.com")]
                    )
                ]
            )
            return [
                (
                    "getAccountMetrics",
                    .getAccountMetrics(
                        request: .init(
                            start: "Mon, 13 Nov 2023 00:00:00 +0000",
                            end: "Tue, 14 Nov 2023 00:00:00 +0000",
                            resolution: "day",
                            duration: "1d",
                            dimensions: ["domain"],
                            metrics: ["accepted_count", "delivered_count"],
                            filter: filter,
                            includeSubaccounts: true,
                            includeAggregates: false
                        )
                    )
                ),
                (
                    "getAccountUsageMetrics",
                    .getAccountUsageMetrics(
                        request: .init(
                            start: "Mon, 13 Nov 2023 00:00:00 +0000",
                            end: "Tue, 14 Nov 2023 00:00:00 +0000",
                            resolution: "day",
                            duration: "1d",
                            dimensions: ["subaccount"],
                            metrics: ["email_validation_count"],
                            filter: filter,
                            includeSubaccounts: false,
                            includeAggregates: true
                        )
                    )
                )
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(
            try Parity.corpus(of: routes, via: router),
            area: "Reporting.Metrics"
        )
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router)
    }
}

@Suite("Mailgun.Reporting.Tags Router Parity")
struct ReportingTagsParityTests {
    let router = Mailgun.Reporting.Tags.API.Router()

    var routes: [(name: String, route: Mailgun.Reporting.Tags.API)] {
        get throws {
            [
                (
                    "list.query",
                    .list(
                        domain: try .init("parity.example.com"),
                        request: .init(page: "next-page-token", limit: 25)
                    )
                ),
                (
                    "list.bare",
                    .list(domain: try .init("parity.example.com"), request: nil)
                ),
                (
                    "get",
                    .get(domain: try .init("parity.example.com"), tag: "newsletter")
                ),
                (
                    "update",
                    .update(
                        domain: try .init("parity.example.com"),
                        tag: "newsletter",
                        request: .init(description: "Parity fixture tag")
                    )
                ),
                (
                    "delete",
                    .delete(domain: try .init("parity.example.com"), tag: "newsletter")
                ),
                (
                    "stats",
                    .stats(
                        domain: try .init("parity.example.com"),
                        tag: "newsletter",
                        request: .init(
                            event: ["accepted", "delivered"],
                            start: "Mon, 13 Nov 2023 00:00:00 +0000",
                            end: "Tue, 14 Nov 2023 00:00:00 +0000",
                            resolution: "day",
                            duration: "1d",
                            provider: "gmail.com",
                            device: "desktop",
                            country: "nl"
                        )
                    )
                ),
                (
                    "aggregates",
                    .aggregates(
                        domain: try .init("parity.example.com"),
                        tag: "newsletter",
                        request: .init(type: "providers")
                    )
                ),
                ("limits", .limits(domain: try .init("parity.example.com")))
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(
            try Parity.corpus(of: routes, via: router),
            area: "Reporting.Tags"
        )
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router, excluding: ["list.bare"])
    }
}

@Suite("Mailgun.Reporting.Logs Router Parity")
struct ReportingLogsParityTests {
    let router = Mailgun.Reporting.Logs.API.Router()

    var routes: [(name: String, route: Mailgun.Reporting.Logs.API)] {
        get throws {
            [
                (
                    "analytics.full",
                    .analytics(
                        request: .init(
                            action: "delivered",
                            groupBy: "domain",
                            startDate: Date(timeIntervalSince1970: 1_700_000_000),
                            endDate: Date(timeIntervalSince1970: 1_700_086_400),
                            filter: .init(
                                and: [
                                    .init(
                                        field: "domain",
                                        operator: .equals,
                                        value: .string("parity.example.com")
                                    )
                                ],
                                or: [
                                    .init(
                                        field: "severity",
                                        operator: .notEquals,
                                        value: .string("temporary")
                                    )
                                ]
                            ),
                            include: [.actions, .total],
                            page: .init(size: 50, number: 1, sort: "timestamp:desc")
                        )
                    )
                ),
                ("analytics.empty", .analytics(request: .init()))
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(
            try Parity.corpus(of: routes, via: router),
            area: "Reporting.Logs"
        )
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router)
    }
}

@Suite("Mailgun.Reporting.Events Router Parity")
struct ReportingEventsParityTests {
    let router = Mailgun.Reporting.Events.API.Router()

    var routes: [(name: String, route: Mailgun.Reporting.Events.API)] {
        get throws {
            [
                (
                    "list.full",
                    .list(
                        domain: try .init("parity.example.com"),
                        query: .init(
                            begin: Date(timeIntervalSince1970: 1_700_000_000),
                            end: Date(timeIntervalSince1970: 1_700_086_400),
                            ascending: .yes,
                            limit: 100,
                            event: .delivered,
                            list: "subscribers@parity.example.com",
                            attachment: "report.pdf",
                            from: try EmailAddress("sender@parity.example.com"),
                            messageId: "20231113000000.1.PARITYFIXTURE@parity.example.com",
                            subject: "Parity fixture subject",
                            to: try EmailAddress("to@parity.example.com"),
                            size: 2048,
                            recipient: try EmailAddress("recipient@parity.example.com"),
                            recipients: [
                                try EmailAddress("first@parity.example.com"),
                                try EmailAddress("second@parity.example.com")
                            ],
                            tags: ["newsletter", "onboarding"],
                            severity: .permanent
                        )
                    )
                ),
                (
                    "list.bare",
                    .list(domain: try .init("parity.example.com"), query: nil)
                )
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(
            try Parity.corpus(of: routes, via: router),
            area: "Reporting.Events"
        )
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router, excluding: ["list.bare"])
    }
}

@Suite("Mailgun.Reporting.Stats Router Parity")
struct ReportingStatsParityTests {
    let router = Mailgun.Reporting.Stats.API.Router()

    var routes: [(name: String, route: Mailgun.Reporting.Stats.API)] {
        get throws {
            [
                (
                    "total",
                    .total(
                        request: .init(
                            event: "delivered",
                            start: "Mon, 13 Nov 2023 00:00:00 +0000",
                            end: "Tue, 14 Nov 2023 00:00:00 +0000",
                            resolution: "day",
                            duration: "1d"
                        )
                    )
                ),
                (
                    "total.minimal",
                    .total(request: .init(event: "accepted"))
                ),
                (
                    "filter",
                    .filter(
                        request: .init(
                            event: "delivered",
                            start: "Mon, 13 Nov 2023 00:00:00 +0000",
                            end: "Tue, 14 Nov 2023 00:00:00 +0000",
                            resolution: "day",
                            duration: "1d",
                            filter: "domain=parity.example.com",
                            group: "domain"
                        )
                    )
                ),
                (
                    "aggregateProviders",
                    .aggregateProviders(domain: try .init("parity.example.com"))
                ),
                (
                    "aggregateDevices",
                    .aggregateDevices(domain: try .init("parity.example.com"))
                ),
                (
                    "aggregateCountries",
                    .aggregateCountries(domain: try .init("parity.example.com"))
                )
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(
            try Parity.corpus(of: routes, via: router),
            area: "Reporting.Stats"
        )
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router)
    }
}
