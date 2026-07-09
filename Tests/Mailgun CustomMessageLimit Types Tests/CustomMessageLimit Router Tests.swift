//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies_Test_Support
import Foundation
import Testing

@testable import Mailgun_CustomMessageLimit_Types

@Suite(
    "CustomMessageLimit Router Tests"
)
struct CustomMessageLimitRouterTests {

    @Test("Creates correct URL for getting monthly limit")
    func testGetMonthlyLimitURL() throws {
        let router: Mailgun.CustomMessageLimit.API.Router = .init()

        let api: Mailgun.CustomMessageLimit.API = .getMonthly

        let url = router.url(for: api)
        #expect(url.path == "/v5/accounts/limit/custom/monthly")

        let match: Mailgun.CustomMessageLimit.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.getMonthly))
    }

    @Test("Creates correct URL for setting monthly limit")
    func testSetMonthlyLimitURL() throws {
        let router: Mailgun.CustomMessageLimit.API.Router = .init()

        let request = Mailgun.CustomMessageLimit.Monthly.Set.Request(limit: 10000)
        let api: Mailgun.CustomMessageLimit.API = .setMonthly(request: request)

        let url = router.url(for: api)
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict: [String: String?] = Dictionary(
            uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) }
        )

        #expect(url.path == "/v5/accounts/limit/custom/monthly")
        #expect(queryDict["limit"] == "10000")

        let match: Mailgun.CustomMessageLimit.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.setMonthly))
        #expect(match.setMonthly?.limit == 10000)
    }

    @Test("Creates correct URL for deleting monthly limit")
    func testDeleteMonthlyLimitURL() throws {
        let router: Mailgun.CustomMessageLimit.API.Router = .init()

        let api: Mailgun.CustomMessageLimit.API = .deleteMonthly

        let url = router.url(for: api)
        #expect(url.path == "/v5/accounts/limit/custom/monthly")

        let match: Mailgun.CustomMessageLimit.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.deleteMonthly))
    }

    @Test("Creates correct URL for enabling account")
    func testEnableAccountURL() throws {
        let router: Mailgun.CustomMessageLimit.API.Router = .init()

        let api: Mailgun.CustomMessageLimit.API = .enableAccount

        let url = router.url(for: api)
        #expect(url.path == "/v5/accounts/limit/custom/enable")

        let match: Mailgun.CustomMessageLimit.API = try router.match(
            request: try router.request(for: api)
        )
        #expect(match.is(\.enableAccount))
    }

    @Test("Verifies all endpoints use v5 API version")
    func testAllEndpointsUseV5() throws {
        let router: Mailgun.CustomMessageLimit.API.Router = .init()

        let getApi: Mailgun.CustomMessageLimit.API = .getMonthly
        let setApi: Mailgun.CustomMessageLimit.API = .setMonthly(request: .init(limit: 5000))
        let deleteApi: Mailgun.CustomMessageLimit.API = .deleteMonthly
        let enableApi: Mailgun.CustomMessageLimit.API = .enableAccount

        let getUrl = router.url(for: getApi)
        let setUrl = router.url(for: setApi)
        let deleteUrl = router.url(for: deleteApi)
        let enableUrl = router.url(for: enableApi)

        #expect(getUrl.path.hasPrefix("/v5/"))
        #expect(setUrl.path.hasPrefix("/v5/"))
        #expect(deleteUrl.path.hasPrefix("/v5/"))
        #expect(enableUrl.path.hasPrefix("/v5/"))
    }
}
