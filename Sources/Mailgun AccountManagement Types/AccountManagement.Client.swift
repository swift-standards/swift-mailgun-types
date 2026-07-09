//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Mailgun_Types_Shared

extension Mailgun.AccountManagement {
    @Witness
    public struct Client: Sendable {
        public var updateAccount:
            @Sendable (_ request: Mailgun.AccountManagement.Update.Request) async throws ->
                Mailgun.AccountManagement.Update.Response
        public var getHttpSigningKey:
            @Sendable () async throws -> Mailgun.AccountManagement.HttpSigningKey.Get.Response
        public var regenerateHttpSigningKey:
            @Sendable () async throws ->
                Mailgun.AccountManagement.HttpSigningKey.Regenerate.Response
        public var getSandboxAuthRecipients:
            @Sendable () async throws ->
                Mailgun.AccountManagement.Sandbox.Auth.Recipients.List.Response
        public var addSandboxAuthRecipient:
            @Sendable (_ request: Mailgun.AccountManagement.Sandbox.Auth.Recipients.Add.Request)
                async throws -> Mailgun.AccountManagement.Sandbox.Auth.Recipients.Add.Response
        public var deleteSandboxAuthRecipient:
            @Sendable (_ email: EmailAddress) async throws ->
                Mailgun.AccountManagement.Sandbox.Auth.Recipients.Delete.Response
        public var resendActivationEmail:
            @Sendable () async throws -> Mailgun.AccountManagement.ResendActivationEmail.Response
        public var getSAMLOrganization:
            @Sendable () async throws -> Mailgun.AccountManagement.SAML.Organization.Get.Response
        public var addSAMLOrganization:
            @Sendable (_ request: Mailgun.AccountManagement.SAML.Organization.Add.Request)
                async throws ->
                Mailgun.AccountManagement.SAML.Organization.Add.Response
    }
}
