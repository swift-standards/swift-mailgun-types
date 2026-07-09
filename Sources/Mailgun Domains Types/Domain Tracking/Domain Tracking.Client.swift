//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Mailgun_Types_Shared

extension Mailgun.Domains.Domains.Tracking {
    @Witness
    public struct Client: Sendable {
        public var get:
            @Sendable (_ domain: Domain) async throws ->
                Mailgun.Domains.Domains.Tracking.Get.Response
        public var updateClick:
            @Sendable (
                _ domain: Domain,
                _ request: Mailgun.Domains.Domains.Tracking.UpdateClick.Request
            ) async throws -> Mailgun.Domains.Domains.Tracking.UpdateClick.Response
        public var updateOpen:
            @Sendable (
                _ domain: Domain,
                _ request: Mailgun.Domains.Domains.Tracking.UpdateOpen.Request
            ) async throws -> Mailgun.Domains.Domains.Tracking.UpdateOpen.Response
        public var updateUnsubscribe:
            @Sendable (
                _ domain: Domain,
                _ request: Mailgun.Domains.Domains.Tracking.UpdateUnsubscribe.Request
            ) async throws -> Mailgun.Domains.Domains.Tracking.UpdateUnsubscribe.Response
    }
}
