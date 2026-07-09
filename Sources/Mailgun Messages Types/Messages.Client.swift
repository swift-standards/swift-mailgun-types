//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Messages {
    @Witness
    public struct Client: Sendable {
        public var send:
            @Sendable (_ request: Mailgun.Messages.Send.Request) async throws ->
                Mailgun.Messages.Send.Response
        public var sendMime:
            @Sendable (_ request: Mailgun.Messages.Send.Mime.Request) async throws ->
                Mailgun.Messages.Send.Response
        public var retrieve:
            @Sendable (_ storageKey: String) async throws -> Mailgun.Messages.StoredMessage
        public var queueStatus: @Sendable () async throws -> Mailgun.Messages.Queue.Status
        public var deleteAll: @Sendable () async throws -> Mailgun.Messages.Delete.Response
    }
}
