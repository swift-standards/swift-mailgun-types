//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.IPAllowlist {
    @Witness
    public struct Client: Sendable {
        public var list: @Sendable () async throws -> Mailgun.IPAllowlist.ListResponse
        public var update:
            @Sendable (_ request: Mailgun.IPAllowlist.UpdateRequest) async throws ->
                Mailgun.IPAllowlist.SuccessResponse
        public var add:
            @Sendable (_ request: Mailgun.IPAllowlist.AddRequest) async throws ->
                Mailgun.IPAllowlist.SuccessResponse
        public var delete:
            @Sendable (_ request: Mailgun.IPAllowlist.DeleteRequest) async throws ->
                Mailgun.IPAllowlist.SuccessResponse
    }
}
