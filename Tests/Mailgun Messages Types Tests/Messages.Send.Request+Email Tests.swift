//
//  Messages.Send.Request+Email Tests.swift
//  swift-mailgun-types
//
//  Tests for Email to Mailgun.Messages.Send.Request conversion
//

import Dependencies_Test_Support
import Email_Standard
import Foundation
import Mailgun_Messages_Types
import Testing

@Suite("Messages.Send.Request+Email Integration Tests")
struct MessagesSendRequestEmailTests {

    // MARK: - Basic Email Conversion

    @Test("Converts simple text email")
    func convertSimpleTextEmail() throws {
        let email = try Email(
            to: [EmailAddress("recipient@example.com")],
            from: EmailAddress("sender@example.com"),
            subject: "Test Subject",
            body: "Hello, World!"
        )

        let request = Mailgun.Messages.Send.Request(email: email)

        #expect(request.from.address == "sender@example.com")
        #expect(request.to.count == 1)
        #expect(request.to[0].address == "recipient@example.com")
        #expect(request.subject == "Test Subject")
        #expect(request.text == "Hello, World!")
        #expect(request.html == nil)
    }

    @Test("Converts simple HTML email")
    func convertSimpleHTMLEmail() throws {
        let email = try Email(
            to: [EmailAddress("recipient@example.com")],
            from: EmailAddress("sender@example.com"),
            subject: "Test Subject",
            body: .html("<h1>Hello, World!</h1>")
        )

        let request = Mailgun.Messages.Send.Request(email: email)

        #expect(request.from.address == "sender@example.com")
        #expect(request.to.count == 1)
        #expect(request.to[0].address == "recipient@example.com")
        #expect(request.subject == "Test Subject")
        #expect(request.html == "<h1>Hello, World!</h1>")
        #expect(request.text == nil)
    }

    @Test("Converts multipart email (text + HTML)")
    func convertMultipartEmail() throws {
        let multipart = try Multipart.alternative(
            textContent: "Plain text version",
            htmlContent: "<h1>HTML version</h1>"
        )

        let email = try Email(
            to: [EmailAddress("recipient@example.com")],
            from: EmailAddress("sender@example.com"),
            subject: "Test Subject",
            body: .multipart(multipart)
        )

        let request = Mailgun.Messages.Send.Request(email: email)

        #expect(request.from.address == "sender@example.com")
        #expect(request.to.count == 1)
        #expect(request.subject == "Test Subject")
        #expect(request.text == "Plain text version")
        #expect(request.html == "<h1>HTML version</h1>")
    }

    // MARK: - Multiple Recipients

    @Test("Converts email with multiple TO recipients")
    func convertMultipleRecipients() throws {
        let email = try Email(
            to: [
                EmailAddress("recipient1@example.com"),
                EmailAddress("recipient2@example.com"),
                EmailAddress("recipient3@example.com"),
            ],
            from: EmailAddress("sender@example.com"),
            subject: "Test Subject",
            body: "Hello!"
        )

        let request = Mailgun.Messages.Send.Request(email: email)

        #expect(request.to.count == 3)
        #expect(request.to[0].address == "recipient1@example.com")
        #expect(request.to[1].address == "recipient2@example.com")
        #expect(request.to[2].address == "recipient3@example.com")
    }

    @Test("Converts email with CC recipients")
    func convertWithCCRecipients() throws {
        let email = try Email(
            to: [EmailAddress("recipient@example.com")],
            from: EmailAddress("sender@example.com"),
            cc: [
                EmailAddress("cc1@example.com"),
                EmailAddress("cc2@example.com"),
            ],
            subject: "Test Subject",
            body: "Hello!"
        )

        let request = Mailgun.Messages.Send.Request(email: email)

        #expect(request.cc?.count == 2)
        #expect(request.cc?[0].address == "cc1@example.com")
        #expect(request.cc?[1].address == "cc2@example.com")
    }

    @Test("Converts email with BCC recipients")
    func convertWithBCCRecipients() throws {
        let email = try Email(
            to: [EmailAddress("recipient@example.com")],
            from: EmailAddress("sender@example.com"),
            bcc: [
                EmailAddress("bcc1@example.com"),
                EmailAddress("bcc2@example.com"),
            ],
            subject: "Test Subject",
            body: "Hello!"
        )

        let request = Mailgun.Messages.Send.Request(email: email)

        #expect(request.bcc?.count == 2)
        #expect(request.bcc?[0].address == "bcc1@example.com")
        #expect(request.bcc?[1].address == "bcc2@example.com")
    }

    // MARK: - Reply-To Handling

    @Test("Converts email with Reply-To header")
    func convertWithReplyTo() throws {
        let email = try Email(
            to: [EmailAddress("recipient@example.com")],
            from: EmailAddress("sender@example.com"),
            replyTo: EmailAddress("replyto@example.com"),
            subject: "Test Subject",
            body: "Hello!"
        )

        let request = Mailgun.Messages.Send.Request(email: email)

        #expect(request.from.address == "sender@example.com")
        #expect(request.headers?["Reply-To"] == "replyto@example.com")
    }

    @Test("Email without Reply-To has no Reply-To header")
    func convertWithoutReplyTo() throws {
        let email = try Email(
            to: [EmailAddress("recipient@example.com")],
            from: EmailAddress("sender@example.com"),
            subject: "Test Subject",
            body: "Hello!"
        )

        let request = Mailgun.Messages.Send.Request(email: email)

        #expect(request.headers?["Reply-To"] == nil)
    }

    // MARK: - Additional Headers

    @Test("Converts email with additional headers")
    func convertWithAdditionalHeaders() throws {
        let email = try Email(
            to: [EmailAddress("recipient@example.com")],
            from: EmailAddress("sender@example.com"),
            subject: "Test Subject",
            body: "Hello!",
            additionalHeaders: [
                .init(name: "X-Custom-Header", value: "CustomValue"),
                .init(name: "X-Priority", value: "1"),
            ]
        )

        let request = Mailgun.Messages.Send.Request(email: email)

        #expect(request.headers?["X-Custom-Header"] == "CustomValue")
        #expect(request.headers?["X-Priority"] == "1")
    }

    @Test("Email with no additional headers results in nil headers")
    func convertWithNoAdditionalHeaders() throws {
        let email = try Email(
            to: [EmailAddress("recipient@example.com")],
            from: EmailAddress("sender@example.com"),
            subject: "Test Subject",
            body: "Hello!"
        )

        let request = Mailgun.Messages.Send.Request(email: email)

        #expect(request.headers == nil)
    }

    @Test("Combines Reply-To and additional headers")
    func convertWithReplyToAndAdditionalHeaders() throws {
        let email = try Email(
            to: [EmailAddress("recipient@example.com")],
            from: EmailAddress("sender@example.com"),
            replyTo: EmailAddress("replyto@example.com"),
            subject: "Test Subject",
            body: "Hello!",
            additionalHeaders: [
                .init(name: "X-Custom-Header", value: "CustomValue")
            ]
        )

        let request = Mailgun.Messages.Send.Request(email: email)

        #expect(request.headers?["Reply-To"] == "replyto@example.com")
        #expect(request.headers?["X-Custom-Header"] == "CustomValue")
        #expect(request.headers?.count == 2)
    }

    // MARK: - Display Names

    @Test("Converts email with display names")
    func convertWithDisplayNames() throws {
        let email = try Email(
            to: [EmailAddress(displayName: "Recipient Name", "recipient@example.com")],
            from: EmailAddress(displayName: "Sender Name", "sender@example.com"),
            subject: "Test Subject",
            body: "Hello!"
        )

        let request = Mailgun.Messages.Send.Request(email: email)

        #expect(request.from.displayName == "Sender Name")
        #expect(request.from.address == "sender@example.com")
        #expect(request.to[0].displayName == "Recipient Name")
        #expect(request.to[0].address == "recipient@example.com")
    }

    // MARK: - Mailgun-Specific Options

    @Test("Adds Mailgun-specific options to email")
    func convertWithMailgunOptions() throws {
        let email = try Email(
            to: [EmailAddress("recipient@example.com")],
            from: EmailAddress("sender@example.com"),
            subject: "Test Subject",
            body: "Hello!"
        )

        let request = Mailgun.Messages.Send.Request(
            email: email,
            tags: ["newsletter", "announcement"],
            testMode: true,
            tracking: .yes,
            trackingClicks: .yes,
            trackingOpens: true
        )

        #expect(request.tags == ["newsletter", "announcement"])
        #expect(request.tracking == .yes)
        #expect(request.trackingClicks == .yes)
        #expect(request.trackingOpens == true)
        #expect(request.testMode == true)
    }

    @Test("Adds Mailgun variables to email")
    func convertWithMailgunVariables() throws {
        let email = try Email(
            to: [EmailAddress("recipient@example.com")],
            from: EmailAddress("sender@example.com"),
            subject: "Test Subject",
            body: "Hello!"
        )

        let request = Mailgun.Messages.Send.Request(
            email: email,
            variables: ["user_id": "123", "campaign": "summer-sale"]
        )

        #expect(request.variables?["user_id"] == "123")
        #expect(request.variables?["campaign"] == "summer-sale")
    }

    @Test("Adds Mailgun scheduled delivery")
    func convertWithScheduledDelivery() throws {
        let email = try Email(
            to: [EmailAddress("recipient@example.com")],
            from: EmailAddress("sender@example.com"),
            subject: "Test Subject",
            body: "Hello!"
        )

        let deliveryDate = Date(timeIntervalSince1970: 1_700_000_000)
        let request = Mailgun.Messages.Send.Request(
            email: email,
            deliveryTime: deliveryDate
        )

        #expect(request.deliveryTime == deliveryDate)
    }

    // MARK: - Edge Cases

    @Test("Converts email with internationalized addresses")
    func convertInternationalizedEmail() throws {
        let email = try Email(
            to: [EmailAddress("用户@example.com")],
            from: EmailAddress("发送者@example.com"),
            subject: "国际化测试",
            body: "你好世界!"
        )

        let request = Mailgun.Messages.Send.Request(email: email)

        #expect(request.from.address == "发送者@example.com")
        #expect(request.to[0].address == "用户@example.com")
        #expect(request.subject == "国际化测试")
        #expect(request.text == "你好世界!")
    }

    @Test("Converts email with special characters in subject")
    func convertSpecialCharactersSubject() throws {
        let email = try Email(
            to: [EmailAddress("recipient@example.com")],
            from: EmailAddress("sender@example.com"),
            subject: "Test with émojis 🎉 and spëcial çhars!",
            body: "Hello!"
        )

        let request = Mailgun.Messages.Send.Request(email: email)

        #expect(request.subject == "Test with émojis 🎉 and spëcial çhars!")
    }

    @Test("Converts email with very long subject")
    func convertLongSubject() throws {
        let longSubject = String(repeating: "A", count: 200)
        let email = try Email(
            to: [EmailAddress("recipient@example.com")],
            from: EmailAddress("sender@example.com"),
            subject: longSubject,
            body: "Hello!"
        )

        let request = Mailgun.Messages.Send.Request(email: email)

        #expect(request.subject == longSubject)
        #expect(request.subject.count == 200)
    }

    // MARK: - Convenience Initializer

    @Test("Convenience initializer creates request with defaults")
    func convertWithConvenienceInit() throws {
        let email = try Email(
            to: [EmailAddress("recipient@example.com")],
            from: EmailAddress("sender@example.com"),
            subject: "Test Subject",
            body: "Hello!"
        )

        let request = Mailgun.Messages.Send.Request(email: email)

        // Should have basic fields set
        #expect(request.from.address == "sender@example.com")
        #expect(request.to.count == 1)
        #expect(request.subject == "Test Subject")
        #expect(request.text == "Hello!")

        // Should have no Mailgun-specific options set
        #expect(request.tags == nil)
        #expect(request.tracking == nil)
        #expect(request.testMode == nil)
    }
}
