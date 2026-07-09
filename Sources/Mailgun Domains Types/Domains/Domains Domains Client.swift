//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Mailgun_Types_Shared

extension Mailgun.Domains.Domains {
    @Witness
    public struct Client: Sendable {
        public var list:
            @Sendable (_ request: Mailgun.Domains.Domains.List.Request?) async throws ->
                Mailgun.Domains.Domains.List.Response
        public var create:
            @Sendable (_ request: Mailgun.Domains.Domains.Create.Request) async throws ->
                Mailgun.Domains.Domains.Create.Response
        public var get:
            @Sendable (_ domain: Domain) async throws ->
                Mailgun.Domains.Domains.Get.Response
        public var update:
            @Sendable (
                _ domain: Domain, _ request: Mailgun.Domains.Domains.Update.Request
            ) async throws -> Mailgun.Domains.Domains.Update.Response
        public var delete:
            @Sendable (_ domain: Domain) async throws ->
                Mailgun.Domains.Domains.Delete.Response
        public var verify:
            @Sendable (_ domain: Domain) async throws ->
                Mailgun.Domains.Domains.Verify.Response
    }
}
