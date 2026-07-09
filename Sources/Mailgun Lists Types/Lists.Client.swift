//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Lists {
    @Witness
    public struct Client: Sendable {
        public var create:
            @Sendable (_ request: Mailgun.Lists.List.Create.Request) async throws ->
                Mailgun.Lists.List.Create.Response
        public var list:
            @Sendable (_ request: Mailgun.Lists.List.Request) async throws ->
                Mailgun.Lists.List.Response
        public var members:
            @Sendable (_ listAddress: EmailAddress, _ request: Mailgun.Lists.List.Members.Request)
                async throws -> Mailgun.Lists.List.Members.Response
        public var addMember:
            @Sendable (_ listAddress: EmailAddress, _ request: Mailgun.Lists.Member.Add.Request)
                async throws -> Mailgun.Lists.Member.Add.Response
        public var bulkAdd:
            @Sendable (
                _ listAddress: EmailAddress, _ members: [Mailgun.Lists.Member.Bulk], _ upsert: Bool?
            ) async throws -> Mailgun.Lists.Member.Bulk.Response
        public var bulkAddCSV:
            @Sendable (
                _ listAddress: EmailAddress, _ csvData: Foundation.Data, _ subscribed: Bool?,
                _ upsert: Bool?
            ) async throws -> Mailgun.Lists.Member.Bulk.Response
        public var getMember:
            @Sendable (_ listAddress: EmailAddress, _ memberAddress: EmailAddress) async throws ->
                Mailgun.Lists.Member
        public var updateMember:
            @Sendable (
                _ listAddress: EmailAddress, _ memberAddress: EmailAddress,
                _ request: Mailgun.Lists.Member.Update.Request
            ) async throws -> Mailgun.Lists.Member.Update.Response
        public var deleteMember:
            @Sendable (_ listAddress: EmailAddress, _ memberAddress: EmailAddress) async throws ->
                Mailgun.Lists.Member.Delete.Response
        public var update:
            @Sendable (_ listAddress: EmailAddress, _ request: Mailgun.Lists.List.Update.Request)
                async throws -> Mailgun.Lists.List.Update.Response
        public var delete:
            @Sendable (_ listAddress: EmailAddress) async throws ->
                Mailgun.Lists.List.Delete.Response
        public var get:
            @Sendable (_ listAddress: EmailAddress) async throws -> Mailgun.Lists.List.Get.Response
        public var pages:
            @Sendable (_ limit: Int?) async throws -> Mailgun.Lists.List.Pages.Response
        public var memberPages:
            @Sendable (
                _ listAddress: EmailAddress, _ request: Mailgun.Lists.List.Members.Pages.Request
            )
                async throws -> Mailgun.Lists.List.Members.Pages.Response
    }
}

extension Mailgun.Lists.Client {
    public func pages() async throws -> Mailgun.Lists.List.Pages.Response {
        return try await self.pages(limit: nil)
    }
}
