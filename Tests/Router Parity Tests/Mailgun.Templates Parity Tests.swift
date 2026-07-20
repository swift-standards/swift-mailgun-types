import Foundation
import Testing
import URL_Routing_Test_Support
@testable import Mailgun_Templates_Types

@Suite("Mailgun.Templates Router Parity")
struct TemplatesParityTests {
    let router = Mailgun.Templates.API.Router()

    var routes: [(name: String, route: Mailgun.Templates.API)] {
        get throws {
            let domain: Domain = try .init("parity.example.com")
            return [
                ("list-nil", .list(domainId: domain, request: nil)),
                (
                    "list-full",
                    .list(
                        domainId: domain,
                        request: .init(page: .next, limit: 25, p: "cursor-token")
                    )
                ),
                (
                    "create",
                    .create(
                        domainId: domain,
                        request: .init(
                            name: "welcome-template",
                            description: "Welcome email template",
                            createdBy: "parity@example.com",
                            template: "<html>Hello {{name}}</html>",
                            tag: "v1",
                            comment: "initial version",
                            headers: "{\"X-Test\": \"parity\"}"
                        )
                    )
                ),
                ("deleteAll", .deleteAll(domainId: domain)),
                (
                    "versions-nil",
                    .versions(domainId: domain, templateName: "welcome-template", request: nil)
                ),
                (
                    "versions-full",
                    .versions(
                        domainId: domain,
                        templateName: "welcome-template",
                        request: .init(page: .first, limit: 10, p: "version-cursor")
                    )
                ),
                (
                    "createVersion",
                    .createVersion(
                        domainId: domain,
                        templateName: "welcome-template",
                        request: .init(
                            template: "<html>Hello v2 {{name}}</html>",
                            tag: "v2",
                            comment: "second version",
                            active: "yes",
                            headers: "{\"X-Test\": \"parity\"}"
                        )
                    )
                ),
                ("get-nil", .get(domainId: domain, templateName: "welcome-template", request: nil)),
                (
                    "get-active",
                    .get(
                        domainId: domain,
                        templateName: "welcome-template",
                        request: .init(active: "yes")
                    )
                ),
                (
                    "update",
                    .update(
                        domainId: domain,
                        templateName: "welcome-template",
                        request: .init(description: "Updated description")
                    )
                ),
                ("delete", .delete(domainId: domain, templateName: "welcome-template")),
                (
                    "getVersion",
                    .getVersion(domainId: domain, templateName: "welcome-template", versionName: "v2")
                ),
                (
                    "updateVersion",
                    .updateVersion(
                        domainId: domain,
                        templateName: "welcome-template",
                        versionName: "v2",
                        request: .init(
                            template: "<html>Hello v2.1 {{name}}</html>",
                            comment: "tweak copy",
                            active: "yes",
                            headers: "{\"X-Test\": \"parity\"}"
                        )
                    )
                ),
                (
                    "deleteVersion",
                    .deleteVersion(
                        domainId: domain,
                        templateName: "welcome-template",
                        versionName: "v2"
                    )
                ),
                (
                    "copyVersion-nil",
                    .copyVersion(
                        domainId: domain,
                        templateName: "welcome-template",
                        versionName: "v2",
                        newVersionName: "v3",
                        request: nil
                    )
                ),
                (
                    "copyVersion-comment",
                    .copyVersion(
                        domainId: domain,
                        templateName: "welcome-template",
                        versionName: "v2",
                        newVersionName: "v3",
                        request: .init(comment: "copied from v2")
                    )
                )
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(try Parity.corpus(of: routes, via: router), area: "Templates")
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router, excluding: ["copyVersion-nil", "get-nil", "list-nil", "versions-nil"])
    }
}
