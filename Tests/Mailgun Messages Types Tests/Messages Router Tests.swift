//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Dependencies_Test_Support
import Testing

@testable import Mailgun_Messages_Types

@Suite("Messages Router Tests")
struct MessagesRouterTests {

    @Test("Creates correct URL for sending message")
    func testSendMessageURL() throws {
        let router: Mailgun.Messages.API.Router = .init()

        let sendRequest = Mailgun.Messages.Send.Request(
            from: try .init("sender@test.com"),
            to: [try .init("recipient@test.com")],
            subject: "Test Subject",
            html: "<p>Test content</p>",
            text: "Test content",
            cc: [try .init("cc@test.com")],
            bcc: [try .init("bcc@test.com")],
            tags: ["test-tag"],
            testMode: true
        )

        let api: Mailgun.Messages.API = .send(
            domain: try .init("test.domain.com"),
            request: sendRequest
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/messages")

        // Note: Round-trip test skipped for multipart form data APIs
        // due to dynamic boundary generation that prevents exact matching
    }

    @Test("Creates correct URL for sending MIME message")
    func testSendMimeMessageURL() throws {
        let router: Mailgun.Messages.API.Router = .init()

        let mimeRequest = Mailgun.Messages.Send.Mime.Request(
            to: [try .init("recipient@test.com")],
            message: Foundation.Data("MIME content".utf8),
            tags: ["test-tag"],
            testMode: true
        )

        let api: Mailgun.Messages.API = .sendMime(
            domain: try .init("test.domain.com"),
            request: mimeRequest
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/messages.mime")

        // Note: Round-trip test skipped for multipart form data APIs
        // due to dynamic boundary generation that prevents exact matching
    }

    @Test("Creates correct URL for retrieving stored message")
    func testRetrieveMessageURL() throws {
        let router: Mailgun.Messages.API.Router = .init()

        let api: Mailgun.Messages.API = .retrieve(
            domain: try .init("test.domain.com"),
            storageKey: "message123"
        )

        let url = router.url(for: api)
        #expect(url.path == "/v3/domains/test.domain.com/messages/message123")

        let match: Mailgun.Messages.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.retrieve))
        let expected1 = try Domain("test.domain.com")
        #expect(Mailgun.Messages.API.cases.retrieve.extract(match)?.domain == expected1)
        #expect(Mailgun.Messages.API.cases.retrieve.extract(match)?.storageKey == "message123")
    }

    @Test("Creates correct URL for queue status")
    func testQueueStatusURL() throws {
        let router: Mailgun.Messages.API.Router = .init()

        let api: Mailgun.Messages.API = .queueStatus(domain: try .init("test.domain.com"))

        let url = router.url(for: api)
        #expect(url.path == "/v3/domains/test.domain.com/sending_queues")

        let match: Mailgun.Messages.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.queueStatus))
        let expected2 = try Domain("test.domain.com")
        #expect(Mailgun.Messages.API.cases.queueStatus.extract(match) == expected2)
    }

    @Test("Creates correct URL for deleting scheduled messages")
    func testDeleteScheduledURL() throws {
        let router: Mailgun.Messages.API.Router = .init()

        let api: Mailgun.Messages.API = .deleteScheduled(domain: try .init("test.domain.com"))

        let url = router.url(for: api)
        #expect(url.path == "/v3/test.domain.com/envelopes")

        let match: Mailgun.Messages.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.deleteScheduled))
        let expected3 = try Domain("test.domain.com")
        #expect(Mailgun.Messages.API.cases.deleteScheduled.extract(match) == expected3)
    }
}
