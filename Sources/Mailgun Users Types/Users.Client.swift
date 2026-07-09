//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Users {
    @Witness
    public struct Client: Sendable {
        public var list:
            @Sendable (_ request: Mailgun.Users.List.Request?) async throws ->
                Mailgun.Users.List.Response
        public var get: @Sendable (_ userId: String) async throws -> Mailgun.Users.Get.Response
        public var me: @Sendable () async throws -> Mailgun.Users.Me.Response
        public var addToOrganization:
            @Sendable (_ userId: String, _ orgId: String) async throws ->
                Mailgun.Users.Organization.Add.Response
        public var removeFromOrganization:
            @Sendable (_ userId: String, _ orgId: String) async throws ->
                Mailgun.Users.Organization.Remove.Response
    }
}
