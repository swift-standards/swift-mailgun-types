//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Reporting.Metrics {
    @Cases
    public enum API: Equatable, Sendable {
        case getAccountMetrics(request: GetAccountMetrics.Request)
        case getAccountUsageMetrics(request: GetAccountUsageMetrics.Request)
    }
}

extension Mailgun.Reporting.Metrics.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Reporting.Metrics.API> {
            OneOf {
                URLRouting.Route(.case(Mailgun.Reporting.Metrics.API.cases.getAccountMetrics)) {
                    Method.post
                    Path { "v1" }
                    Path.analytics
                    Path.metrics
                    URLRouting.Body(coding: .json(Mailgun.Reporting.Metrics.GetAccountMetrics.Request.self))
                }

                URLRouting.Route(.case(Mailgun.Reporting.Metrics.API.cases.getAccountUsageMetrics)) {
                    Method.post
                    Path { "v1" }
                    Path.analytics
                    Path.usage
                    Path.metrics
                    URLRouting.Body(coding: .json(Mailgun.Reporting.Metrics.GetAccountUsageMetrics.Request.self))
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    public static var analytics: Path<PathBuilder.Component<String>> { Path {
        "analytics"
    } }

    public static var metrics: Path<PathBuilder.Component<String>> { Path {
        "metrics"
    } }

    public static var usage: Path<PathBuilder.Component<String>> { Path {
        "usage"
    } }
}
