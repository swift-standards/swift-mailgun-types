//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Reporting.Stats {
    @Witness
    public struct Client: Sendable {
        public var total:
            @Sendable (_ request: Mailgun.Reporting.Stats.Total.Request) async throws ->
                Mailgun.Reporting.Stats.StatsList
        public var filter:
            @Sendable (_ request: Mailgun.Reporting.Stats.Filter.Request) async throws ->
                Mailgun.Reporting.Stats.StatsList
        public var aggregateProviders:
            @Sendable () async throws -> Mailgun.Reporting.Stats.AggregatesProviders
        public var aggregateDevices:
            @Sendable () async throws -> Mailgun.Reporting.Stats.AggregatesDevices
        public var aggregateCountries:
            @Sendable () async throws -> Mailgun.Reporting.Stats.AggregatesCountries
    }
}
