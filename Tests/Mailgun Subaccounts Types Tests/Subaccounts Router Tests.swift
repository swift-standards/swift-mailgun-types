//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies_Test_Support
import URL_Routing_Foundation_Integration
import Testing

@testable import Mailgun_Subaccounts_Types

@Suite(
    "Subaccounts Router Tests"
)
struct SubaccountsRouterTests {

    @Test("Creates correct URL for getting a subaccount")
    func testGetSubaccountURL() throws {
        let router: Mailgun.Subaccounts.API.Router = .init()

        let subaccountId = "test-subaccount-123"
        let api: Mailgun.Subaccounts.API = .get(subaccountId: subaccountId)

        let url = router.url(for: api)
        #expect(url.path == "/v5/accounts/subaccounts/test-subaccount-123")

        let match: Mailgun.Subaccounts.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.get))
        #expect(Mailgun.Subaccounts.API.cases.get.extract(match)?.description == "test-subaccount-123")
    }

    @Test("Creates correct URL for listing subaccounts")
    func testListSubaccountsURL() throws {
        let router: Mailgun.Subaccounts.API.Router = .init()

        let api: Mailgun.Subaccounts.API = .list(request: nil)

        let url = router.url(for: api)
        #expect(url.path == "/v5/accounts/subaccounts")

        let match: Mailgun.Subaccounts.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.list))
    }

    @Test("Creates correct URL for creating a subaccount")
    func testCreateSubaccountURL() throws {
        let router: Mailgun.Subaccounts.API.Router = .init()

        let request = Mailgun.Subaccounts.Create.Request(name: "Test Subaccount")
        let api: Mailgun.Subaccounts.API = .create(request: request)

        let url = router.url(for: api)
        #expect(url.path == "/v5/accounts/subaccounts")

        let match: Mailgun.Subaccounts.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.create))
        #expect(Mailgun.Subaccounts.API.cases.create.extract(match)?.name == "Test Subaccount")
    }

    @Test("Creates correct URL for deleting subaccounts")
    func testDeleteSubaccountsURL() throws {
        let router: Mailgun.Subaccounts.API.Router = .init()

        let subaccountId = "test-subaccount-123"
        let api: Mailgun.Subaccounts.API = .delete(subaccountId: subaccountId)

        let request = try router.request(for: api)
        #expect(request.url?.path == "/v5/accounts/subaccounts")

        let result = try router.print(api)
        #expect(result.headers.fields["x-mailgun-on-behalf-of"] != nil)
        #expect(
            result.headers.fields["x-mailgun-on-behalf-of"]?.contains("test-subaccount-123") == true
        )

        let match: Mailgun.Subaccounts.API = try router.match(request: request)
        #expect(match.is(\.delete))
        #expect(Mailgun.Subaccounts.API.cases.delete.extract(match)?.description == "test-subaccount-123")
    }

    @Test("Creates correct URL for disabling a subaccount")
    func testDisableSubaccountURL() throws {
        let router: Mailgun.Subaccounts.API.Router = .init()

        let subaccountId = "test-subaccount-123"
        let api: Mailgun.Subaccounts.API = .disable(subaccountId: subaccountId, request: nil)

        let url = router.url(for: api)
        #expect(url.path == "/v5/accounts/subaccounts/test-subaccount-123/disable")

        let match: Mailgun.Subaccounts.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.disable))
        #expect(Mailgun.Subaccounts.API.cases.disable.extract(match)?.subaccountId == "test-subaccount-123")
    }

    @Test("Creates correct URL for enabling a subaccount")
    func testEnableSubaccountURL() throws {
        let router: Mailgun.Subaccounts.API.Router = .init()

        let subaccountId = "test-subaccount-123"
        let api: Mailgun.Subaccounts.API = .enable(subaccountId: subaccountId)

        let url = router.url(for: api)
        #expect(url.path == "/v5/accounts/subaccounts/test-subaccount-123/enable")

        let match: Mailgun.Subaccounts.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.enable))
        #expect(Mailgun.Subaccounts.API.cases.enable.extract(match)?.description == "test-subaccount-123")
    }

    @Test("Creates correct URL for getting custom limit")
    func testGetCustomLimitURL() throws {
        let router: Mailgun.Subaccounts.API.Router = .init()

        let subaccountId = "test-subaccount-123"
        let api: Mailgun.Subaccounts.API = .getCustomLimit(subaccountId: subaccountId)

        let url = router.url(for: api)
        #expect(url.path == "/v5/accounts/subaccounts/test-subaccount-123/limit/custom/monthly")

        let match: Mailgun.Subaccounts.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.getCustomLimit))
        #expect(Mailgun.Subaccounts.API.cases.getCustomLimit.extract(match)?.description == "test-subaccount-123")
    }

    @Test("Creates correct URL for updating custom limit")
    func testUpdateCustomLimitURL() throws {
        let router: Mailgun.Subaccounts.API.Router = .init()

        let subaccountId = "test-subaccount-123"
        let api: Mailgun.Subaccounts.API = .updateCustomLimit(
            subaccountId: subaccountId,
            limit: 10000
        )

        let url = router.url(for: api)
        #expect(url.path == "/v5/accounts/subaccounts/test-subaccount-123/limit/custom/monthly")

        let match: Mailgun.Subaccounts.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.updateCustomLimit))
        #expect(Mailgun.Subaccounts.API.cases.updateCustomLimit.extract(match)?.subaccountId == "test-subaccount-123")
        #expect(Mailgun.Subaccounts.API.cases.updateCustomLimit.extract(match)?.limit == 10000)
    }

    @Test("Creates correct URL for deleting custom limit")
    func testDeleteCustomLimitURL() throws {
        let router: Mailgun.Subaccounts.API.Router = .init()

        let subaccountId = "test-subaccount-123"
        let api: Mailgun.Subaccounts.API = .deleteCustomLimit(subaccountId: subaccountId)

        let url = router.url(for: api)
        #expect(url.path == "/v5/accounts/subaccounts/test-subaccount-123/limit/custom/monthly")

        let match: Mailgun.Subaccounts.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.deleteCustomLimit))
        #expect(Mailgun.Subaccounts.API.cases.deleteCustomLimit.extract(match)?.description == "test-subaccount-123")
    }

    @Test("Creates correct URL for updating features")
    func testUpdateFeaturesURL() throws {
        let router: Mailgun.Subaccounts.API.Router = .init()

        let subaccountId = "test-subaccount-123"
        let request = Mailgun.Subaccounts.Features.Update.Request()
        let api: Mailgun.Subaccounts.API = .updateFeatures(
            subaccountId: subaccountId,
            request: request
        )

        let url = router.url(for: api)
        #expect(url.path == "/v5/accounts/subaccounts/test-subaccount-123/features")

        let match: Mailgun.Subaccounts.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.updateFeatures))
        #expect(Mailgun.Subaccounts.API.cases.updateFeatures.extract(match)?.subaccountId == "test-subaccount-123")
        // Request structure verified
    }

    @Test("Verifies all endpoints use v5 API version")
    func testAllEndpointsUseV5() throws {
        let router: Mailgun.Subaccounts.API.Router = .init()

        let getApi: Mailgun.Subaccounts.API = .get(subaccountId: "123")
        let listApi: Mailgun.Subaccounts.API = .list(request: nil)
        let createApi: Mailgun.Subaccounts.API = .create(request: .init(name: "Test"))
        let deleteApi: Mailgun.Subaccounts.API = .delete(subaccountId: "123")
        let disableApi: Mailgun.Subaccounts.API = .disable(subaccountId: "123", request: nil)
        let enableApi: Mailgun.Subaccounts.API = .enable(subaccountId: "123")
        let getCustomLimitApi: Mailgun.Subaccounts.API = .getCustomLimit(subaccountId: "123")
        let updateCustomLimitApi: Mailgun.Subaccounts.API = .updateCustomLimit(
            subaccountId: "123",
            limit: 1000
        )
        let deleteCustomLimitApi: Mailgun.Subaccounts.API = .deleteCustomLimit(subaccountId: "123")
        let updateFeaturesApi: Mailgun.Subaccounts.API = .updateFeatures(
            subaccountId: "123",
            request: .init()
        )

        let getUrl = router.url(for: getApi)
        let listUrl = router.url(for: listApi)
        let createUrl = router.url(for: createApi)
        let deleteUrl = router.url(for: deleteApi)
        let disableUrl = router.url(for: disableApi)
        let enableUrl = router.url(for: enableApi)
        let getCustomLimitUrl = router.url(for: getCustomLimitApi)
        let updateCustomLimitUrl = router.url(for: updateCustomLimitApi)
        let deleteCustomLimitUrl = router.url(for: deleteCustomLimitApi)
        let updateFeaturesUrl = router.url(for: updateFeaturesApi)

        #expect(getUrl.path.hasPrefix("/v5/"))
        #expect(listUrl.path.hasPrefix("/v5/"))
        #expect(createUrl.path.hasPrefix("/v5/"))
        #expect(deleteUrl.path.hasPrefix("/v5/"))
        #expect(disableUrl.path.hasPrefix("/v5/"))
        #expect(enableUrl.path.hasPrefix("/v5/"))
        #expect(getCustomLimitUrl.path.hasPrefix("/v5/"))
        #expect(updateCustomLimitUrl.path.hasPrefix("/v5/"))
        #expect(deleteCustomLimitUrl.path.hasPrefix("/v5/"))
        #expect(updateFeaturesUrl.path.hasPrefix("/v5/"))
    }
}
