//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies_Test_Support
import URL_Routing_Foundation_Integration
import Domain_Standard
import Testing

@testable import Mailgun_Credentials_Types

@Suite(
    "Credentials Router Tests"
)
struct CredentialsRouterTests {

    @Test("Creates correct URL for listing credentials")
    func testListCredentialsURL() throws {
        let router: Mailgun.Credentials.API.Router = .init()

        let api: Mailgun.Credentials.API = .list(
            domain: try .init("test.domain.com"),
            request: nil
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/domains/test.domain.com/credentials")

        let match: Mailgun.Credentials.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.list))
        let expected1 = try Domain("test.domain.com")
        #expect(Mailgun.Credentials.API.cases.list.extract(match)?.domain == expected1)
        // Request without parameters creates an empty request object
        #expect(Mailgun.Credentials.API.cases.list.extract(match)?.request?.skip == nil)
        #expect(Mailgun.Credentials.API.cases.list.extract(match)?.request?.limit == nil)
    }

    @Test("Creates correct URL for listing credentials with pagination")
    func testListCredentialsWithPaginationURL() throws {
        let router: Mailgun.Credentials.API.Router = .init()

        let request = Mailgun.Credentials.List.Request(skip: 10, limit: 50)
        let api: Mailgun.Credentials.API = .list(
            domain: try .init("test.domain.com"),
            request: request
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/domains/test.domain.com/credentials")
        #expect(url.query?.contains("skip=10") == true)
        #expect(url.query?.contains("limit=50") == true)

        let match: Mailgun.Credentials.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.list))
        let expected2 = try Domain("test.domain.com")
        #expect(Mailgun.Credentials.API.cases.list.extract(match)?.domain == expected2)
        #expect(Mailgun.Credentials.API.cases.list.extract(match)?.request?.skip == 10)
        #expect(Mailgun.Credentials.API.cases.list.extract(match)?.request?.limit == 50)
    }

    @Test("Creates correct URL for creating credentials")
    func testCreateCredentialsURL() throws {
        let router: Mailgun.Credentials.API.Router = .init()

        let request = Mailgun.Credentials.Create.Request(
            login: "user@test.domain.com",
            password: "securePassword123"
        )

        let api: Mailgun.Credentials.API = .create(
            domain: try .init("test.domain.com"),
            request: request
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/domains/test.domain.com/credentials")

        let match: Mailgun.Credentials.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.create))
        let expected3 = try Domain("test.domain.com")
        #expect(Mailgun.Credentials.API.cases.create.extract(match)?.domain == expected3)
        #expect(Mailgun.Credentials.API.cases.create.extract(match)?.request.login == "user@test.domain.com")
        #expect(Mailgun.Credentials.API.cases.create.extract(match)?.request.password == "securePassword123")
    }

    @Test("Creates correct URL for deleting all credentials")
    func testDeleteAllCredentialsURL() throws {
        let router: Mailgun.Credentials.API.Router = .init()

        let api: Mailgun.Credentials.API = .deleteAll(
            domain: try .init("test.domain.com")
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/domains/test.domain.com/credentials")

        let match: Mailgun.Credentials.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.deleteAll))
        let expected4 = try Domain("test.domain.com")
        #expect(Mailgun.Credentials.API.cases.deleteAll.extract(match) == expected4)
    }

    @Test("Creates correct URL for updating credentials")
    func testUpdateCredentialsURL() throws {
        let router: Mailgun.Credentials.API.Router = .init()

        let request = Mailgun.Credentials.Update.Request(
            password: "newSecurePassword456"
        )

        let api: Mailgun.Credentials.API = .update(
            domain: try .init("test.domain.com"),
            login: "user@test.domain.com",
            request: request
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/domains/test.domain.com/credentials/user@test.domain.com")

        let match: Mailgun.Credentials.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.update))
        let expected5 = try Domain("test.domain.com")
        #expect(Mailgun.Credentials.API.cases.update.extract(match)?.domain == expected5)
        #expect(Mailgun.Credentials.API.cases.update.extract(match)?.login == "user@test.domain.com")
        #expect(Mailgun.Credentials.API.cases.update.extract(match)?.request.password == "newSecurePassword456")
    }

    @Test("Creates correct URL for deleting specific credentials")
    func testDeleteSpecificCredentialsURL() throws {
        let router: Mailgun.Credentials.API.Router = .init()

        let api: Mailgun.Credentials.API = .delete(
            domain: try .init("test.domain.com"),
            login: "user@test.domain.com"
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/domains/test.domain.com/credentials/user@test.domain.com")

        let match: Mailgun.Credentials.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.delete))
        let expected6 = try Domain("test.domain.com")
        #expect(Mailgun.Credentials.API.cases.delete.extract(match)?.domain == expected6)
        #expect(Mailgun.Credentials.API.cases.delete.extract(match)?.login == "user@test.domain.com")
    }

    @Test("Creates correct URL for updating mailbox")
    func testUpdateMailboxURL() throws {
        let router: Mailgun.Credentials.API.Router = .init()

        let request = Mailgun.Credentials.Mailbox.Update.Request(
            password: "newMailboxPassword789"
        )

        let api: Mailgun.Credentials.API = .updateMailbox(
            domain: try .init("test.domain.com"),
            login: "user@test.domain.com",
            request: request
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/mailboxes/user@test.domain.com")

        let match: Mailgun.Credentials.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.updateMailbox))
        let expected7 = try Domain("test.domain.com")
        #expect(Mailgun.Credentials.API.cases.updateMailbox.extract(match)?.domain == expected7)
        #expect(Mailgun.Credentials.API.cases.updateMailbox.extract(match)?.login == "user@test.domain.com")
        #expect(Mailgun.Credentials.API.cases.updateMailbox.extract(match)?.request.password == "newMailboxPassword789")
    }

    @Test("Handles special characters in login parameter")
    func testSpecialCharactersInLoginURL() throws {
        let router: Mailgun.Credentials.API.Router = .init()

        let loginWithSpecialChars = "user+test@test.domain.com"

        let api: Mailgun.Credentials.API = .delete(
            domain: try .init("test.domain.com"),
            login: loginWithSpecialChars
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/domains/test.domain.com/credentials/user+test@test.domain.com")

        let match: Mailgun.Credentials.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.delete))
        let expected8 = try Domain("test.domain.com")
        #expect(Mailgun.Credentials.API.cases.delete.extract(match)?.domain == expected8)
        #expect(Mailgun.Credentials.API.cases.delete.extract(match)?.login == "user+test@test.domain.com")
    }
}
