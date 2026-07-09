//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Webhooks {
    @Witness
    public struct Client: Sendable {
        public var list: @Sendable () async throws -> Mailgun.Webhooks.List.Response
        public var get:
            @Sendable (_ webhookName: WebhookType) async throws -> Mailgun.Webhooks.Get.Response
        public var create:
            @Sendable (_ request: Create.Request) async throws -> Mailgun.Webhooks.Create.Response
        public var update:
            @Sendable (_ webhookName: WebhookType, _ request: Update.Request) async throws ->
                Mailgun.Webhooks.Update.Response
        public var delete:
            @Sendable (_ webhookName: WebhookType) async throws -> Mailgun.Webhooks.Delete.Response
    }
}
