import CasePaths
import Dependencies
import Domain_Standard
import Foundation
import Testing
import URLFormCoding

@testable import Mailgun_Domains_Types
@testable import Mailgun_Messages_Types
@testable import Mailgun_Reporting_Types
@testable import Mailgun_Suppressions_Types
@testable import Mailgun_Templates_Types
@testable import Mailgun_Types

@Suite("README Code Examples Validation", .serialized)
struct ReadmeVerificationTests {

    // MARK: - Quick Start Example (README lines 44-53)

    @Test("Quick Start - Type-safe request models (README lines 44-53)")
    func quickStartExample() async throws {
        // Type-safe request models with compile-time validation
        let request = Mailgun.Messages.Send.Request(
            from: try .init("hello@yourdomain.com"),
            to: [try .init("user@example.com")],
            subject: "Welcome to swift-mailgun-types!",
            html: "<h1>Type-safe emails</h1><p>Built with Swift</p>"
        )

        // Verify the request was created correctly
        #expect(request.from.rawValue == "hello@yourdomain.com")
        #expect(request.to.count == 1)
        #expect(request.to.first?.rawValue == "user@example.com")
        #expect(request.subject == "Welcome to swift-mailgun-types!")
        #expect(request.html == "<h1>Type-safe emails</h1><p>Built with Swift</p>")
    }

    // MARK: - Sending Messages (README lines 431-481)

    @Test("Simple email (README lines 434-439)")
    func simpleEmailExample() async throws {
        let simpleEmail = Mailgun.Messages.Send.Request(
            from: try .init("noreply@yourdomain.com"),
            to: [try .init("user@example.com")],
            subject: "Hello!",
            text: "Welcome to our service."
        )

        #expect(simpleEmail.from.rawValue == "noreply@yourdomain.com")
        #expect(simpleEmail.to.count == 1)
        #expect(simpleEmail.subject == "Hello!")
        #expect(simpleEmail.text == "Welcome to our service.")
    }

    @Test("Rich email with all features (README lines 442-480)")
    func richEmailExample() async throws {
        let reportData = Data("PDF content".utf8)
        let logoData = Data("PNG content".utf8)

        let richEmail = Mailgun.Messages.Send.Request(
            from: try .init("Newsletter <news@yourdomain.com>"),
            to: [
                try .init("subscriber1@example.com"),
                try .init("subscriber2@example.com"),
            ],
            subject: "Monthly Newsletter",  // subject must come before cc/bcc
            html: """
                    <h1>Your Monthly Update</h1>
                    <p>Check out our latest features!</p>
                    <img src="cid:logo.png">
                """,
            text: "Your Monthly Update - Check out our latest features!",
            cc: [try .init("manager@yourdomain.com")],
            bcc: [try .init("archive@yourdomain.com")],
            template: "monthly-newsletter",
            templateVariables: #"{"month":"January","year":"2024"}"#,  // JSON string
            attachments: [
                Mailgun.Messages.Attachment.Data(
                    data: reportData,
                    filename: "report.pdf",
                    contentType: "application/pdf"
                )
            ],
            inline: [
                Mailgun.Messages.Attachment.Data(
                    data: logoData,
                    filename: "logo.png",
                    contentType: "image/png"
                )
            ],
            tags: ["newsletter", "monthly"],
            deliveryTime: Date().addingTimeInterval(3600),  // Send in 1 hour
            tracking: true,
            trackingClicks: .htmlOnly,
            trackingOpens: true,
            headers: ["X-Campaign-ID": "JAN2024"],
            recipientVariables: #"{"subscriber1@example.com":{"name":"Alice","id":"001"}}"#  // JSON string
        )

        #expect(richEmail.from.rawValue.contains("news@yourdomain.com"))
        #expect(richEmail.to.count == 2)
        #expect(richEmail.cc?.count == 1)
        #expect(richEmail.bcc?.count == 1)
        #expect(richEmail.template == "monthly-newsletter")
        #expect(richEmail.tags?.contains("newsletter") == true)
        #expect(richEmail.tracking == true)
        #expect(richEmail.attachments?.count == 1)
        #expect(richEmail.inline?.count == 1)
    }

    // MARK: - Working with Templates (README lines 486-512)

    @Test("Create a template (README lines 489-499)")
    func createTemplateExample() async throws {
        let template = Mailgun.Templates.Create.Request(
            name: "welcome-email",
            description: "Welcome email for new users",
            template: """
                    <h1>Welcome {{name}}!</h1>
                    <p>Thanks for joining on {{signup_date}}.</p>
                    <p>Your account type: {{account_type}}</p>
                """,
            tag: "v1.0",
            comment: "Initial version"
        )

        #expect(template.name == "welcome-email")
        #expect(template.description == "Welcome email for new users")
        #expect(template.template?.contains("{{name}}") == true)
    }

    @Test("Create a new template version (README lines 502-512)")
    func createTemplateVersionExample() async throws {
        let newVersion = Mailgun.Templates.Version.Create.Request(
            template: """
                    <h1>Welcome aboard, {{name}}!</h1>
                    <p>We're excited to have you join us on {{signup_date}}.</p>
                    <p>Your {{account_type}} account is ready!</p>
                    <a href="{{cta_link}}">Get Started</a>
                """,
            tag: "v2.0",
            comment: "Added CTA button",
            active: "yes"  // Note: active is a String, not Bool
        )

        #expect(newVersion.tag == "v2.0")
        #expect(newVersion.comment == "Added CTA button")
        #expect(newVersion.active == "yes")
        #expect(newVersion.template.contains("{{cta_link}}"))
    }

    // MARK: - Managing Suppressions (README lines 518-544)

    @Test("Handle a bounce (README lines 521-525)")
    func handleBounceExample() async throws {
        let bounce = Mailgun.Suppressions.Bounces.Create.Request(
            address: try .init("invalid@example.com"),
            code: "550",
            error: "Mailbox does not exist"
        )

        #expect(bounce.address.rawValue == "invalid@example.com")
        #expect(bounce.code == "550")
        #expect(bounce.error == "Mailbox does not exist")
    }

    @Test("Add to unsubscribe list (README lines 528-531)")
    func addUnsubscribeExample() async throws {
        let unsubscribe = Mailgun.Suppressions.Unsubscribe.Create.Request(
            address: try .init("user@example.com"),
            tags: ["newsletter"]  // Unsubscribe from specific tags
        )

        #expect(unsubscribe.address.rawValue == "user@example.com")
        #expect(unsubscribe.tags?.contains("newsletter") == true)
    }

    @Test("Allowlist VIP addresses (README lines 534-536)")
    func allowlistExample() async throws {
        // Allowlist VIP addresses (enum-based)
        let allowlist = Mailgun.Suppressions.Allowlist.Create.Request.address(
            try .init("vip@partner.com")
        )

        if case .address(let email) = allowlist {
            #expect(email.rawValue == "vip@partner.com")
        } else {
            Issue.record("Expected address case")
        }
    }

    @Test("Query suppressions (README lines 539-543)")
    func querySuppressions() async throws {
        let query = Mailgun.Suppressions.Bounces.List.Request(
            limit: 100,
            page: "next",  // page is a String
            term: "example.com"
        )

        #expect(query.limit == 100)
        #expect(query.page == "next")
        #expect(query.term == "example.com")
    }

    // MARK: - Analytics and Reporting (README lines 549-584)

    @Test("Get total stats (README lines 552-558)")
    func getStatisticsExample() async throws {
        let statsQuery = Mailgun.Reporting.Stats.Total.Request(
            event: "delivered",
            start: "2024-01-01",
            end: "2024-01-31",
            resolution: "day",
            duration: "1M"
        )

        #expect(statsQuery.event == "delivered")
        #expect(statsQuery.start == "2024-01-01")
        #expect(statsQuery.resolution == "day")
        #expect(statsQuery.duration == "1M")
    }

    @Test("Advanced metrics with dimensions (README lines 561-584)")
    func advancedMetricsExample() async throws {
        let metricsFilter = Mailgun.Reporting.Metrics.Filter(
            and: [
                Mailgun.Reporting.Metrics.FilterCondition(
                    attribute: "status",
                    comparator: "eq",
                    values: [
                        Mailgun.Reporting.Metrics.FilterValue(
                            label: "Delivered",
                            value: "delivered"
                        )
                    ]
                )
            ]
        )

        let metricsQuery = Mailgun.Reporting.Metrics.GetAccountMetrics.Request(
            start: "2024-01-01",
            end: "2024-01-31",
            resolution: "day",
            duration: "1M",
            dimensions: ["campaign"],
            metrics: ["delivered_count"],
            filter: metricsFilter,
            includeSubaccounts: true,
            includeAggregates: true
        )

        #expect(metricsQuery.metrics.count == 1)
        #expect(metricsQuery.resolution == "day")
        #expect(metricsQuery.dimensions.contains("campaign") == true)
        #expect(metricsQuery.includeSubaccounts == true)
    }

    // MARK: - Managing Domains (README lines 590-612)

    @Test("Create a domain (README lines 593-595)")
    func createDomainExample() async throws {
        let createRequest = Mailgun.Domains.Domains.Create.Request(
            name: "mail.yourdomain.com"
        )

        #expect(createRequest.name == "mail.yourdomain.com")
    }

    @Test("Update domain settings (README lines 598-600)")
    func updateDomainExample() async throws {
        let updateRequest = Mailgun.Domains.Domains.Update.Request(
            spamAction: .tag
        )

        #expect(updateRequest.spamAction == .tag)
    }

    @Test("List domains with filters (README lines 603-608)")
    func listDomainsExample() async throws {
        let listRequest = Mailgun.Domains.Domains.List.Request(
            authority: "example.com",
            state: .active,
            limit: 10,
            skip: 0
        )

        #expect(listRequest.authority == "example.com")
        #expect(listRequest.state == .active)
        #expect(listRequest.limit == 10)
        #expect(listRequest.skip == 0)
    }

    @Test("Get tracking settings (README lines 611-612)")
    func getTrackingExample() async throws {
        let domain = try Domain("example.com")
        let trackingAPI = Mailgun.Domains.Domains.Tracking.API.get(domain: domain)

        #expect(trackingAPI.is(\.get))
        #expect(trackingAPI.get == domain)
    }

    // MARK: - Mock Client Testing (README lines 646-712)

    struct TestError: Error {}

    @Test("Mock Client Testing (README lines 646-712)")
    func mockClientTestingExample() async throws {
        // Create a mock client with controlled responses
        let client = Mailgun.Messages.Client(
            send: { request in
                // Verify the request
                #expect(request.from.rawValue == "test@example.com")
                #expect(request.subject == "Test Email")
                #expect(request.to.count == 1)

                // Return mock response
                return Mailgun.Messages.Send.Response(
                    id: "<test-message-id@mailgun.org>",
                    message: "Queued. Thank you."
                )
            },
            sendMime: { _ in
                throw TestError()
            },
            retrieve: { storageKey in
                #expect(storageKey == "test-key")
                return Mailgun.Messages.StoredMessage(
                    contentTransferEncoding: "7bit",
                    contentType: "text/plain",
                    from: try .init("sender@example.com"),
                    messageId: "<test-id>",
                    mimeVersion: "1.0",
                    subject: "Test",
                    to: try .init("recipient@example.com"),
                    tags: [],
                    sender: try .init("sender@example.com"),
                    recipients: [try .init("recipient@example.com")],
                    bodyHtml: nil,
                    bodyPlain: "Test message",
                    strippedHtml: nil,
                    strippedText: "Test message",
                    strippedSignature: nil,
                    messageHeaders: [],
                    templateName: nil,
                    templateVariables: nil
                )
            },
            queueStatus: {
                throw TestError()
            },
            deleteAll: {
                throw TestError()
            }
        )

        // Test sending
        let request = Mailgun.Messages.Send.Request(
            from: try .init("test@example.com"),
            to: [try .init("recipient@example.com")],
            subject: "Test Email",
            text: "This is a test"
        )

        let response = try await client.send(request)
        #expect(response.id == "<test-message-id@mailgun.org>")

        // Test retrieval
        let message = try await client.retrieve("test-key")
        #expect(message.from.rawValue == "sender@example.com")
    }

    // MARK: - Type Conformance Validation

    @Test("Verify all types are Sendable and Codable")
    func typeConformanceValidation() async throws {
        // Verify Send.Request conforms to required protocols
        let request = Mailgun.Messages.Send.Request(
            from: try .init("test@test.com"),
            to: [try .init("user@test.com")],
            subject: "Test",
            text: "Test"
        )

        let _: any Sendable = request
        let _: any Codable = request

        // Verify Response types conform
        let response = Mailgun.Messages.Send.Response(
            id: "test-id",
            message: "Queued"
        )
        let _: any Sendable = response
        let _: any Decodable = response

        // Verify Template types conform
        let template = Mailgun.Templates.Create.Request(
            name: "test",
            template: "<h1>Test</h1>"
        )
        let _: any Sendable = template
        let _: any Codable = template
    }

    @Test("Verify Client protocols are properly defined")
    func clientProtocolValidation() async throws {
        // Verify Messages client exists and has expected methods
        let _: Mailgun.Messages.Client.Type = Mailgun.Messages.Client.self

        // Verify other client types exist
        let _: Mailgun.Templates.Client.Type = Mailgun.Templates.Client.self
        let _: Mailgun.Domains.Client.Type = Mailgun.Domains.Client.self
        let _: Mailgun.Suppressions.Client.Type = Mailgun.Suppressions.Client.self
    }
}
