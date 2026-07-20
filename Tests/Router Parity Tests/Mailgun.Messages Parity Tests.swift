import Foundation
import Testing
import URL_Routing_Test_Support
@testable import Mailgun_Messages_Types

@Suite("Mailgun.Messages Router Parity")
struct MessagesParityTests {
    let router = Mailgun.Messages.API.Router()

    var routes: [(name: String, route: Mailgun.Messages.API)] {
        get throws {
            [
                (
                    "send",
                    .send(
                        domain: try .init("parity.example.com"),
                        request: .init(
                            from: try .init("sender@parity.example.com"),
                            to: [
                                try .init("first@parity.example.com"),
                                try .init("second@parity.example.com")
                            ],
                            subject: "Parity corpus subject",
                            html: "<h1>Parity</h1><p>Hello</p>",
                            text: "Parity plain text",
                            cc: [try .init("cc@parity.example.com")],
                            bcc: [try .init("bcc@parity.example.com")],
                            ampHtml: "<html amp4email>Parity AMP</html>",
                            template: "parity-template",
                            templateVersion: "v2",
                            templateText: true,
                            templateVariables: "{\"key\":\"value\"}",
                            attachments: [
                                .init(
                                    data: Foundation.Data("attachment-bytes".utf8),
                                    filename: "report.txt",
                                    contentType: "text/plain"
                                )
                            ],
                            inline: [
                                .init(
                                    data: Foundation.Data("inline-bytes".utf8),
                                    filename: "logo.png",
                                    contentType: "image/png"
                                )
                            ],
                            tags: ["parity", "corpus"],
                            dkim: true,
                            secondaryDkim: "secondary.parity.example.com",
                            secondaryDkimPublic: "public.parity.example.com",
                            // deliveryTime intentionally omitted: Date-valued field.
                            deliveryTimeOptimizePeriod: "24h",
                            timeZoneLocalize: "17:00",
                            testMode: true,
                            tracking: .yes,
                            trackingClicks: .htmlOnly,
                            trackingOpens: true,
                            requireTls: true,
                            skipVerification: false,
                            sendingIp: "203.0.113.10",
                            sendingIpPool: "pool-1",
                            trackingPixelLocationTop: true,
                            // Single-entry dictionaries keep multipart part order deterministic.
                            headers: ["X-Parity": "yes"],
                            variables: ["campaign": "parity"],
                            recipientVariables: "{\"first@parity.example.com\":{\"id\":1}}"
                        )
                    )
                ),
                (
                    "sendMime",
                    .sendMime(
                        domain: try .init("parity.example.com"),
                        request: .init(
                            to: [
                                try .init("first@parity.example.com"),
                                try .init("second@parity.example.com")
                            ],
                            message: Foundation.Data(
                                "From: sender@parity.example.com\r\nSubject: Parity MIME\r\n\r\nBody".utf8
                            ),
                            template: "parity-template",
                            templateVersion: "v2",
                            templateText: false,
                            templateVariables: "{\"key\":\"value\"}",
                            tags: ["parity", "mime"],
                            dkim: false,
                            secondaryDkim: "secondary.parity.example.com",
                            secondaryDkimPublic: "public.parity.example.com",
                            // deliveryTime intentionally omitted: Date-valued field.
                            deliveryTimeOptimizePeriod: "48h",
                            timeZoneLocalize: "09:30",
                            testMode: true,
                            tracking: .no,
                            trackingClicks: .yes,
                            trackingOpens: false,
                            requireTls: false,
                            skipVerification: true,
                            sendingIp: "203.0.113.11",
                            sendingIpPool: "pool-2",
                            trackingPixelLocationTop: false,
                            headers: ["X-Parity-Mime": "yes"],
                            variables: ["campaign": "parity-mime"],
                            recipientVariables: "{\"second@parity.example.com\":{\"id\":2}}"
                        )
                    )
                ),
                (
                    "retrieve",
                    .retrieve(
                        domain: try .init("parity.example.com"),
                        storageKey: "storage-key-123"
                    )
                ),
                ("queueStatus", .queueStatus(domain: try .init("parity.example.com"))),
                ("deleteScheduled", .deleteScheduled(domain: try .init("parity.example.com")))
            ]
        }
    }

    @Test func corpus() throws {
        try Support.assertFixture(
            Support.normalizePartBoundary(try Parity.corpus(of: routes, via: router)),
            area: "Messages"
        )
    }

    @Test func roundTrips() throws {
        Support.assertRoundTrips(try routes, via: router, excluding: Self.nonRoundTripping)
    }

    /// SendMultipartConversion.apply / MimeMultipartConversion.apply are
    /// `fatalError` (print-only conversions) — round-tripping them crashes
    /// the process. See __Corpus__/KNOWN-NON-ROUNDTRIP.txt.
    static let nonRoundTripping: Set<String> = ["send", "sendMime"]
}
