//
//  Domains Router Tests.swift
//  swift-mailgun-types
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies_Test_Support
import URL_Routing_Foundation_Integration
import Domain_Standard
import Testing

@testable import Mailgun_Domains_Types

@Suite("Domain Router Tests")
struct DomainRouterTests {
    @Test("Creates correct URL for listing domains")
    func testListDomainsURL() throws {
        let router: Mailgun.Domains.Domains.API.Router = .init()

        let api: Mailgun.Domains.Domains.API = .list(request: nil)

        let url = router.url(for: api)
        #expect(url.path == "/v4/domains")

        let match: Mailgun.Domains.Domains.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.list))
        // The router creates an empty request object instead of nil
        if let listRequest = Mailgun.Domains.Domains.API.cases.list.extract(match) {
            #expect(listRequest?.authority == nil)
            #expect(listRequest?.state == nil)
            #expect(listRequest?.limit == nil)
            #expect(listRequest?.skip == nil)
        }
    }

    @Test("Creates correct URL for listing domains with parameters")
    func testListDomainsWithParamsURL() throws {
        let router: Mailgun.Domains.Domains.API.Router = .init()
        let request = Mailgun.Domains.Domains.List.Request(
            authority: "example.com",
            state: .active,
            limit: 10,
            skip: 5
        )

        let api: Mailgun.Domains.Domains.API = .list(request: request)

        let url = router.url(for: api)
        #expect(url.path == "/v4/domains")
        #expect(url.query?.contains("authority=example.com") == true)
        #expect(url.query?.contains("state=active") == true)
        #expect(url.query?.contains("limit=10") == true)
        #expect(url.query?.contains("skip=5") == true)

        let match: Mailgun.Domains.Domains.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.list))
        if let listRequest2 = Mailgun.Domains.Domains.API.cases.list.extract(match) {
            #expect(listRequest2?.authority == "example.com")
            #expect(listRequest2?.state == .active)
            #expect(listRequest2?.limit == 10)
            #expect(listRequest2?.skip == 5)
        }
    }

    @Test("Creates correct URL for creating domain")
    func testCreateDomainURL() throws {
        let router: Mailgun.Domains.Domains.API.Router = .init()
        let request = Mailgun.Domains.Domains.Create.Request(name: "example.com")

        let api: Mailgun.Domains.Domains.API = .create(request: request)

        let url = router.url(for: api)
        #expect(url.path == "/v4/domains")

        let match: Mailgun.Domains.Domains.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.create))
        #expect(Mailgun.Domains.Domains.API.cases.create.extract(match)?.name == "example.com")
    }

    @Test("Creates correct URL for getting domain")
    func testGetDomainURL() throws {
        let router: Mailgun.Domains.Domains.API.Router = .init()
        let domain = try Domain("example.com")

        let api: Mailgun.Domains.Domains.API = .get(domain: domain)

        let url = router.url(for: api)
        #expect(url.path == "/v4/domains/example.com")

        let match: Mailgun.Domains.Domains.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.get))
        #expect(Mailgun.Domains.Domains.API.cases.get.extract(match) == domain)
    }

    @Test("Creates correct URL for updating domain")
    func testUpdateDomainURL() throws {
        let router: Mailgun.Domains.Domains.API.Router = .init()
        let domain = try Domain("example.com")
        let request = Mailgun.Domains.Domains.Update.Request(spamAction: .tag)

        let api: Mailgun.Domains.Domains.API = .update(domain: domain, request: request)

        let url = router.url(for: api)
        #expect(url.path == "/v4/domains/example.com")

        let match: Mailgun.Domains.Domains.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.update))
        #expect(Mailgun.Domains.Domains.API.cases.update.extract(match)?.domain == domain)
        #expect(Mailgun.Domains.Domains.API.cases.update.extract(match)?.request.spamAction == .tag)
    }

    @Test("Creates correct URL for deleting domain")
    func testDeleteDomainURL() throws {
        let router: Mailgun.Domains.Domains.API.Router = .init()
        let domain = try Domain("example.com")

        let api: Mailgun.Domains.Domains.API = .delete(domain: domain)

        let url = router.url(for: api)
        #expect(url.path == "/v4/domains/example.com")

        let match: Mailgun.Domains.Domains.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.delete))
        #expect(Mailgun.Domains.Domains.API.cases.delete.extract(match) == domain)
    }

    @Test("Creates correct URL for verifying domain")
    func testVerifyDomainURL() throws {
        let router: Mailgun.Domains.Domains.API.Router = .init()
        let domain = try Domain("example.com")

        let api: Mailgun.Domains.Domains.API = .verify(domain: domain)

        let url = router.url(for: api)
        #expect(url.path == "/v4/domains/example.com/verify")

        let match: Mailgun.Domains.Domains.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.verify))
        #expect(Mailgun.Domains.Domains.API.cases.verify.extract(match) == domain)
    }
}
