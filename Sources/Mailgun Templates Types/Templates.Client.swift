//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.Templates {
    @Witness
    public struct Client: Sendable {
        public var list:
            @Sendable (_ request: Mailgun.Templates.List.Request?) async throws ->
                Mailgun.Templates.List.Response
        public var create:
            @Sendable (_ request: Mailgun.Templates.Create.Request) async throws ->
                Mailgun.Templates.Create.Response
        public var deleteAll: @Sendable () async throws -> Mailgun.Templates.DeleteAll.Response
        public var versions:
            @Sendable (_ templateName: String, _ request: Mailgun.Templates.Versions.Request?)
                async throws -> Mailgun.Templates.Versions.Response
        public var createVersion:
            @Sendable (_ templateName: String, _ request: Mailgun.Templates.Version.Create.Request)
                async throws -> Mailgun.Templates.Version.Create.Response
        public var get:
            @Sendable (_ templateName: String, _ request: Mailgun.Templates.Get.Request?)
                async throws ->
                Mailgun.Templates.Get.Response
        public var update:
            @Sendable (_ templateName: String, _ request: Mailgun.Templates.Update.Request)
                async throws
                -> Mailgun.Templates.Update.Response
        public var delete:
            @Sendable (_ templateName: String) async throws -> Mailgun.Templates.Delete.Response
        public var getVersion:
            @Sendable (_ templateName: String, _ versionName: String) async throws ->
                Mailgun.Templates.Version.Get.Response
        public var updateVersion:
            @Sendable (
                _ templateName: String, _ versionName: String,
                _ request: Mailgun.Templates.Version.Update.Request
            ) async throws -> Mailgun.Templates.Version.Update.Response
        public var deleteVersion:
            @Sendable (_ templateName: String, _ versionName: String) async throws ->
                Mailgun.Templates.Version.Delete.Response
        public var copyVersion:
            @Sendable (
                _ templateName: String, _ versionName: String, _ newVersionName: String,
                _ request: Mailgun.Templates.Version.Copy.Request?
            ) async throws -> Mailgun.Templates.Version.Copy.Response
    }
}
