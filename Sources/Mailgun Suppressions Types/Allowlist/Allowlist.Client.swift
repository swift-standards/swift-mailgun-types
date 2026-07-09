//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Suppressions.Allowlist {
    @Witness
    public struct Client: Sendable {
        public var get:
            @Sendable (_ value: String) async throws -> Mailgun.Suppressions.Allowlist.Record
        public var delete:
            @Sendable (_ value: String) async throws ->
                Mailgun.Suppressions.Allowlist.Delete.Response
        public var list:
            @Sendable (_ request: Mailgun.Suppressions.Allowlist.List.Request?) async throws ->
                Mailgun.Suppressions.Allowlist.List.Response
        public var create:
            @Sendable (_ request: Mailgun.Suppressions.Allowlist.Create.Request) async throws ->
                Mailgun.Suppressions.Allowlist.Create.Response
        public var deleteAll:
            @Sendable () async throws -> Mailgun.Suppressions.Allowlist.Delete.All.Response
        public var importList:
            @Sendable (_ request: Foundation.Data) async throws ->
                Mailgun.Suppressions.Allowlist.Import.Response
    }
}
