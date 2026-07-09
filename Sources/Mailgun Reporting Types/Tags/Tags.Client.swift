//
//  Tags.Client.swift
//  swift-mailgun
//
//  Created by Claude on 31/12/2024.
//

import Dependencies
import Mailgun_Types_Shared

extension Mailgun.Reporting.Tags {
    @Witness
    public struct Client: Sendable {
        public var list:
            @Sendable (_ request: Mailgun.Reporting.Tags.List.Request?) async throws ->
                Mailgun.Reporting.Tags.List.Response
        public var get:
            @Sendable (_ tag: String) async throws -> Mailgun.Reporting.Tags.Get.Response
        public var update:
            @Sendable (_ tag: String, _ request: Mailgun.Reporting.Tags.Update.Request) async throws
                ->
                Mailgun.Reporting.Tags.Update.Response
        public var delete:
            @Sendable (_ tag: String) async throws -> Mailgun.Reporting.Tags.Delete.Response
        public var stats:
            @Sendable (_ tag: String, _ request: Mailgun.Reporting.Tags.Stats.Request) async throws
                ->
                Mailgun.Reporting.Tags.Stats.Response
        public var aggregates:
            @Sendable (_ tag: String, _ request: Mailgun.Reporting.Tags.Aggregates.Request)
                async throws
                -> Mailgun.Reporting.Tags.Aggregates.Response
        public var limits: @Sendable () async throws -> Mailgun.Reporting.Tags.Limits.Response
    }
}
