//
//  IPAddressWarmup Client.swift
//  swift-mailgun-types
//
//  Created by Assistant on 05/08/2025.
//

import Dependencies
import Mailgun_Types_Shared

extension Mailgun.IPAddressWarmup {
    @Witness
    public struct Client: Sendable {
        public var list: @Sendable () async throws -> Mailgun.IPAddressWarmup.List.Response
        public var get: @Sendable (_ ip: String) async throws -> Mailgun.IPAddressWarmup.IPWarmup
        public var create:
            @Sendable (_ ip: String, _ request: Mailgun.IPAddressWarmup.Create.Request) async throws
                ->
                Mailgun.IPAddressWarmup.Create.Response
        public var delete:
            @Sendable (_ ip: String) async throws -> Mailgun.IPAddressWarmup.Delete.Response
    }
}
