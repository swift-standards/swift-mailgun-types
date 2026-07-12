//
//  Mailgun.Reporting.API.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Reporting {
    @Cases
    public enum API: Equatable, Sendable {
        case metrics(Metrics.API)
        case stats(Stats.API)
        case events(Events.API)
        case tags(Tags.API)
        case logs(Logs.API)
    }
}

extension Mailgun.Reporting.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Reporting.API> {
            OneOf {
                URLRouting.Route(.case(Mailgun.Reporting.API.cases.metrics)) {
                    Mailgun.Reporting.Metrics.API.Router()
                }
                URLRouting.Route(.case(Mailgun.Reporting.API.cases.stats)) {
                    Mailgun.Reporting.Stats.API.Router()
                }
                URLRouting.Route(.case(Mailgun.Reporting.API.cases.events)) {
                    Mailgun.Reporting.Events.API.Router()
                }
                URLRouting.Route(.case(Mailgun.Reporting.API.cases.tags)) {
                    Mailgun.Reporting.Tags.API.Router()
                }
                URLRouting.Route(.case(Mailgun.Reporting.API.cases.logs)) {
                    Mailgun.Reporting.Logs.API.Router()
                }
            }
        }
    }
}
