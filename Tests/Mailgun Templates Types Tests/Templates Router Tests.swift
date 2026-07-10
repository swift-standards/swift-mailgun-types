//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 30/12/2024.
//

import Dependencies_Test_Support
import Domain_Standard
import Testing

@testable import Mailgun_Templates_Types

@Suite("Templates Router Tests")
struct TemplatesRouterTests {
    @Test("Creates correct URL for listing templates")
    func testListTemplatesURL() throws {
        let router: Mailgun.Templates.API.Router = .init()

        let api: Mailgun.Templates.API = .list(
            domainId: try .init("test.domain.com"),
            request: Mailgun.Templates.List.Request(
                page: .first,
                limit: 100,
                p: nil
            )
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/templates")

        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict = [String: String?](
            uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) }
        )

        #expect(queryDict["page"] == "first")
        #expect(queryDict["limit"] == "100")

        let match: Mailgun.Templates.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.list))
        let expected1 = try Domain("test.domain.com")
        #expect(match.list?.domainId == expected1)
        #expect(match.list?.request?.page == .first)
        #expect(match.list?.request?.limit == 100)
        #expect(match.list?.request?.p == nil)
    }

    @Test("Creates correct URL for creating template")
    func testCreateTemplateURL() throws {
        let router: Mailgun.Templates.API.Router = .init()

        let request = Mailgun.Templates.Create.Request(
            name: "Test Template",
            description: "Test Description",
            template: "<html>Hello {{name}}</html>",
            tag: "v1",
            comment: "Initial version"
        )

        let domain = try Domain("test.domain.com")
        let api: Mailgun.Templates.API = .create(domainId: domain, request: request)

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/templates")

        // Note: Round-trip test skipped for multipart form data APIs
        // due to dynamic boundary generation that prevents exact matching
    }

    @Test("Creates correct URL for getting template")
    func testGetTemplateURL() throws {
        let router: Mailgun.Templates.API.Router = .init()

        let domain = try Domain("test.domain.com")
        let templateId = "template123"
        let api: Mailgun.Templates.API = .get(
            domainId: domain,
            templateName: templateId,
            request: Mailgun.Templates.Get.Request(active: "active")
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/templates/template123")

        let match: Mailgun.Templates.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.get))
        let expected2 = try Domain("test.domain.com")
        #expect(match.get?.domainId == expected2)
        #expect(match.get?.templateName == "template123")
        #expect(match.get?.request?.active == "active")
    }

    @Test("Creates correct URL for updating template")
    func testUpdateTemplateURL() throws {
        let router: Mailgun.Templates.API.Router = .init()

        let domain = try Domain("test.domain.com")
        let templateId = "template123"
        let request = Mailgun.Templates.Update.Request(
            description: "Updated Description"
        )
        let api: Mailgun.Templates.API = .update(
            domainId: domain,
            templateName: templateId,
            request: request
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/templates/template123")

        // Note: Round-trip test skipped for multipart form data APIs
        // due to dynamic boundary generation that prevents exact matching
    }

    @Test("Creates correct URL for deleting template")
    func testDeleteTemplateURL() throws {
        let router: Mailgun.Templates.API.Router = .init()

        let domain = try Domain("test.domain.com")
        let templateId = "template123"
        let api: Mailgun.Templates.API = .delete(domainId: domain, templateName: templateId)

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/templates/template123")

        let match: Mailgun.Templates.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.delete))
        let expected3 = try Domain("test.domain.com")
        #expect(match.delete?.domainId == expected3)
        #expect(match.delete?.templateName == "template123")
    }

    @Test("Creates correct URL for listing template versions")
    func testListTemplateVersionsURL() throws {
        let router: Mailgun.Templates.API.Router = .init()

        let domain = try Domain("test.domain.com")
        let templateId = "template123"
        let api: Mailgun.Templates.API = .versions(
            domainId: domain,
            templateName: templateId,
            request: Mailgun.Templates.Versions.Request(page: .next, limit: 50, p: nil)
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/templates/template123/versions")

        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict = [String: String?](
            uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) }
        )

        #expect(queryDict["page"] == "next")
        #expect(queryDict["limit"] == "50")

        let match: Mailgun.Templates.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.versions))
        let expected4 = try Domain("test.domain.com")
        #expect(match.versions?.domainId == expected4)
        #expect(match.versions?.templateName == "template123")
        #expect(match.versions?.request?.page == .next)
        #expect(match.versions?.request?.limit == 50)
        #expect(match.versions?.request?.p == nil)
    }

    @Test("Creates correct URL for creating template version")
    func testCreateTemplateVersionURL() throws {
        let router: Mailgun.Templates.API.Router = .init()

        let domain = try Domain("test.domain.com")
        let templateId = "template123"
        let request = Mailgun.Templates.Version.Create.Request(
            template: "<html>Hello {{name}}</html>",
            tag: "v2",
            comment: "Second version"
        )
        let api: Mailgun.Templates.API = .createVersion(
            domainId: domain,
            templateName: templateId,
            request: request
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/templates/template123/versions")

        // Note: Round-trip test skipped for multipart form data APIs
        // due to dynamic boundary generation that prevents exact matching
    }

    @Test("Creates correct URL for getting template version")
    func testGetTemplateVersionURL() throws {
        let router: Mailgun.Templates.API.Router = .init()

        let domain = try Domain("test.domain.com")
        let templateId = "template123"
        let versionId = "version456"
        let api: Mailgun.Templates.API = .getVersion(
            domainId: domain,
            templateName: templateId,
            versionName: versionId
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/templates/template123/versions/version456")

        let match: Mailgun.Templates.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.getVersion))
        let expected5 = try Domain("test.domain.com")
        #expect(match.getVersion?.domainId == expected5)
        #expect(match.getVersion?.templateName == "template123")
        #expect(match.getVersion?.versionName == "version456")
    }

    @Test("Creates correct URL for updating template version")
    func testUpdateTemplateVersionURL() throws {
        let router: Mailgun.Templates.API.Router = .init()

        let domain = try Domain("test.domain.com")
        let templateId = "template123"
        let versionId = "version456"
        let request = Mailgun.Templates.Version.Update.Request(
            template: "<html>Updated {{name}}</html>",
            comment: "Updated version",
            active: "yes"
        )
        let api: Mailgun.Templates.API = .updateVersion(
            domainId: domain,
            templateName: templateId,
            versionName: versionId,
            request: request
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/templates/template123/versions/version456")

        // Note: Round-trip test skipped for multipart form data APIs
        // due to dynamic boundary generation that prevents exact matching
    }

    @Test("Creates correct URL for deleting template version")
    func testDeleteTemplateVersionURL() throws {
        let router: Mailgun.Templates.API.Router = .init()

        let domain = try Domain("test.domain.com")
        let templateId = "template123"
        let versionId = "version456"
        let api: Mailgun.Templates.API = .deleteVersion(
            domainId: domain,
            templateName: templateId,
            versionName: versionId
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/templates/template123/versions/version456")

        let match: Mailgun.Templates.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.deleteVersion))
        let expected6 = try Domain("test.domain.com")
        #expect(match.deleteVersion?.domainId == expected6)
        #expect(match.deleteVersion?.templateName == "template123")
        #expect(match.deleteVersion?.versionName == "version456")
    }

    @Test("Creates correct URL for copying template version")
    func testCopyTemplateVersionURL() throws {
        let router: Mailgun.Templates.API.Router = .init()

        let domain = try Domain("test.domain.com")
        let templateName = "template123"
        let versionName = "version456"
        let newVersionName = "v3"
        let comment = "Copied version"
        let api: Mailgun.Templates.API = .copyVersion(
            domainId: domain,
            templateName: templateName,
            versionName: versionName,
            newVersionName: newVersionName,
            request: Mailgun.Templates.Version.Copy.Request(comment: comment)
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/templates/template123/versions/version456/copy/v3")

        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict = [String: String?](
            uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) }
        )

        #expect(queryDict["comment"] == "Copied version")

        let match: Mailgun.Templates.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.copyVersion))
        let expected7 = try Domain("test.domain.com")
        #expect(match.copyVersion?.domainId == expected7)
        #expect(match.copyVersion?.templateName == "template123")
        #expect(match.copyVersion?.versionName == "version456")
        #expect(match.copyVersion?.newVersionName == "v3")
        #expect(match.copyVersion?.request?.comment == "Copied version")
    }
}
