//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

@_exported import Mailgun_Types_Shared

extension Mailgun.IPPools {
    @Witness
    public struct Client: Sendable {
        public var list: @Sendable () async throws -> Mailgun.IPPools.List.Response
        public var create:
            @Sendable (_ request: Mailgun.IPPools.Create.Request) async throws ->
                Mailgun.IPPools.Create.Response
        public var get: @Sendable (_ poolId: String) async throws -> Mailgun.IPPools.IPPool
        public var update:
            @Sendable (_ poolId: String, _ request: Mailgun.IPPools.Update.Request) async throws ->
                Mailgun.IPPools.Update.Response
        public var delete:
            @Sendable (_ poolId: String, _ request: Mailgun.IPPools.Delete.Request?) async throws ->
                Mailgun.IPPools.Delete.Response
        public var listDomains:
            @Sendable (_ poolId: String) async throws -> Mailgun.IPPools.DomainsList.Response
    }
}
