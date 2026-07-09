//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Routes {
    @Witness
    public struct Client: Sendable {
        public var create:
            @Sendable (_ request: Mailgun.Routes.Create.Request) async throws ->
                Mailgun.Routes.Create.Response
        public var list:
            @Sendable (_ limit: Int?, _ skip: Int?) async throws -> Mailgun.Routes.List.Response
        public var get: @Sendable (_ id: String) async throws -> Mailgun.Routes.Get.Response
        public var update:
            @Sendable (_ id: String, _ request: Mailgun.Routes.Update.Request) async throws ->
                Mailgun.Routes.Update.Response
        public var delete: @Sendable (_ id: String) async throws -> Mailgun.Routes.Delete.Response
        public var match:
            @Sendable (_ address: String) async throws -> Mailgun.Routes.Match.Response
    }
}
