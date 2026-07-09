//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies_Test_Support
import Testing

@testable import Mailgun_AccountManagement_Types

@Suite(
    "AccountManagement Router Tests"
)
struct AccountManagementRouterTests {

    @Test("Creates correct URL for updating account")
    func testUpdateAccountURL() throws {
        let router: Mailgun.AccountManagement.API.Router = .init()

        let request = Mailgun.AccountManagement.Update.Request(
            name: "Test Account",
            inactiveSessionTimeout: 3600,
            absoluteSessionTimeout: 86400,
            logoutRedirectUrl: "https://example.com/logout"
        )

        let api: Mailgun.AccountManagement.API = .updateAccount(request: request)

        let url = router.url(for: api)
        #expect(url.path == "/v5/accounts")

        let match: Mailgun.AccountManagement.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.updateAccount))
        #expect(match.updateAccount?.name == "Test Account")
        #expect(match.updateAccount?.inactiveSessionTimeout == 3600)
        #expect(match.updateAccount?.absoluteSessionTimeout == 86400)
        #expect(match.updateAccount?.logoutRedirectUrl == "https://example.com/logout")
    }

    @Test("Creates correct URL for getting HTTP signing key")
    func testGetHttpSigningKeyURL() throws {
        let router: Mailgun.AccountManagement.API.Router = .init()

        let api: Mailgun.AccountManagement.API = .getHttpSigningKey

        let url = router.url(for: api)
        #expect(url.path == "/v5/accounts/http_signing_key")

        let match: Mailgun.AccountManagement.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.getHttpSigningKey))
    }

    @Test("Creates correct URL for regenerating HTTP signing key")
    func testRegenerateHttpSigningKeyURL() throws {
        let router: Mailgun.AccountManagement.API.Router = .init()

        let api: Mailgun.AccountManagement.API = .regenerateHttpSigningKey

        let url = router.url(for: api)
        #expect(url.path == "/v5/accounts/http_signing_key")

        let match: Mailgun.AccountManagement.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.regenerateHttpSigningKey))
    }

    @Test("Creates correct URL for getting sandbox auth recipients")
    func testGetSandboxAuthRecipientsURL() throws {
        let router: Mailgun.AccountManagement.API.Router = .init()

        let api: Mailgun.AccountManagement.API = .getSandboxAuthRecipients

        let url = router.url(for: api)
        #expect(url.path == "/v5/sandbox/auth_recipients")

        let match: Mailgun.AccountManagement.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.getSandboxAuthRecipients))
    }

    @Test("Creates correct URL for adding sandbox auth recipient")
    func testAddSandboxAuthRecipientURL() throws {
        let router: Mailgun.AccountManagement.API.Router = .init()

        let request = Mailgun.AccountManagement.Sandbox.Auth.Recipients.Add.Request(
            email: try .init("test@example.com")
        )
        let api: Mailgun.AccountManagement.API = .addSandboxAuthRecipient(request: request)

        let url = router.url(for: api)
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict: [String: String?] = Dictionary(
            uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) }
        )

        #expect(url.path == "/v5/sandbox/auth_recipients")
        #expect(queryDict["email"] == "test@example.com")

        let match: Mailgun.AccountManagement.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.addSandboxAuthRecipient))
        #expect(match.addSandboxAuthRecipient?.email.rawValue == "test@example.com")
    }

    @Test("Creates correct URL for deleting sandbox auth recipient")
    func testDeleteSandboxAuthRecipientURL() throws {
        let router: Mailgun.AccountManagement.API.Router = .init()

        let email = try EmailAddress("test@example.com")
        let api: Mailgun.AccountManagement.API = .deleteSandboxAuthRecipient(email: email)

        let url = router.url(for: api)
        #expect(url.path == "/v5/sandbox/auth_recipients/test@example.com")

        let match: Mailgun.AccountManagement.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.deleteSandboxAuthRecipient))

        if case .deleteSandboxAuthRecipient(let matchedEmail) = match {
            #expect(matchedEmail == email)
        } else {
            Issue.record("Expected deleteSandboxAuthRecipient case")
        }
    }

    @Test("Creates correct URL for resending activation email")
    func testResendActivationEmailURL() throws {
        let router: Mailgun.AccountManagement.API.Router = .init()

        let api: Mailgun.AccountManagement.API = .resendActivationEmail

        let url = router.url(for: api)
        #expect(url.path == "/v5/accounts/resend_activation_email")

        let match: Mailgun.AccountManagement.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.resendActivationEmail))
    }

    @Test("Creates correct URL for getting SAML organization")
    func testGetSAMLOrganizationURL() throws {
        let router: Mailgun.AccountManagement.API.Router = .init()

        let api: Mailgun.AccountManagement.API = .getSAMLOrganization

        let url = router.url(for: api)
        #expect(url.path == "/v5/accounts/saml_org")

        let match: Mailgun.AccountManagement.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.getSAMLOrganization))
    }

    @Test("Creates correct URL for adding SAML organization")
    func testAddSAMLOrganizationURL() throws {
        let router: Mailgun.AccountManagement.API.Router = .init()

        let request = Mailgun.AccountManagement.SAML.Organization.Add.Request(
            userId: "test-user-123",
            domain: "example.com"
        )

        let api: Mailgun.AccountManagement.API = .addSAMLOrganization(request: request)

        let url = router.url(for: api)
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict: [String: String?] = Dictionary(
            uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) }
        )

        #expect(url.path == "/v5/accounts/saml_org")
        #expect(queryDict["user_id"] == "test-user-123")
        #expect(queryDict["domain"] == "example.com")

        let match: Mailgun.AccountManagement.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.addSAMLOrganization))
        #expect(match.addSAMLOrganization?.userId == "test-user-123")
        #expect(match.addSAMLOrganization?.domain == "example.com")
    }

    @Test("Verifies all endpoints use v5 API version")
    func testAllEndpointsUseV5() throws {
        let router: Mailgun.AccountManagement.API.Router = .init()

        let updateUrl = router.url(for: .updateAccount(request: .init()))
        let httpKeyUrl = router.url(for: .getHttpSigningKey)
        let regenerateUrl = router.url(for: .regenerateHttpSigningKey)
        let sandboxListUrl = router.url(for: .getSandboxAuthRecipients)
        let sandboxAddUrl = router.url(
            for: .addSandboxAuthRecipient(request: .init(email: try .init("test@example.com")))
        )
        let sandboxDeleteUrl = router.url(
            for: .deleteSandboxAuthRecipient(email: try .init("test@example.com"))
        )
        let resendUrl = router.url(for: .resendActivationEmail)
        let samlGetUrl = router.url(for: .getSAMLOrganization)
        let samlCreateUrl = router.url(for: .addSAMLOrganization(request: .init(userId: "test")))

        #expect(updateUrl.path.hasPrefix("/v5/"))
        #expect(httpKeyUrl.path.hasPrefix("/v5/"))
        #expect(regenerateUrl.path.hasPrefix("/v5/"))
        #expect(sandboxListUrl.path.hasPrefix("/v5/"))
        #expect(sandboxAddUrl.path.hasPrefix("/v5/"))
        #expect(sandboxDeleteUrl.path.hasPrefix("/v5/"))
        #expect(resendUrl.path.hasPrefix("/v5/"))
        #expect(samlGetUrl.path.hasPrefix("/v5/"))
        #expect(samlCreateUrl.path.hasPrefix("/v5/"))
    }
}
