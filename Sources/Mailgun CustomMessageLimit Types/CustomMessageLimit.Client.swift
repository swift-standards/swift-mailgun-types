//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.CustomMessageLimit {
    @Witness
    public struct Client: Sendable {
        public var getMonthlyLimit:
            @Sendable () async throws -> Mailgun.CustomMessageLimit.Monthly.Get.Response
        public var setMonthlyLimit:
            @Sendable (_ request: Mailgun.CustomMessageLimit.Monthly.Set.Request) async throws ->
                Mailgun.CustomMessageLimit.Monthly.Set.Response
        public var deleteMonthlyLimit:
            @Sendable () async throws -> Mailgun.CustomMessageLimit.Monthly.Delete.Response
        public var enableAccount:
            @Sendable () async throws -> Mailgun.CustomMessageLimit.EnableAccount.Response
    }
}
