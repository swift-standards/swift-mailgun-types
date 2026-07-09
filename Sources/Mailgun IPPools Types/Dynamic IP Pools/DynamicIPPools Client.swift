//
//  DynamicIPPools Client.swift
//  swift-mailgun-types
//
//  Created by Assistant on 05/08/2025.
//

@_exported import Mailgun_Types_Shared

extension Mailgun.DynamicIPPools {
    @Witness
    public struct Client: Sendable {
        public var listHistory:
            @Sendable (_ request: Mailgun.DynamicIPPools.HistoryList.Request) async throws ->
                Mailgun.DynamicIPPools.HistoryList.Response
        public var removeOverride:
            @Sendable (_ domain: String) async throws ->
                Mailgun.DynamicIPPools.RemoveOverride.Response
    }
}
