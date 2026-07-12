//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Foundation
import Mailgun_Types_Shared
import RFC_2183

extension Mailgun.Messages {
    @Cases
    public enum API: Equatable, Sendable {
        case send(domain: Domain, request: Mailgun.Messages.Send.Request)
        case sendMime(domain: Domain, request: Mailgun.Messages.Send.Mime.Request)
        case retrieve(domain: Domain, storageKey: String)
        case queueStatus(domain: Domain)
        case deleteScheduled(domain: Domain)
    }
}

extension Mailgun.Messages.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<Mailgun.Messages.API> {
            OneOf {
                URLRouting.Route(
                    .convert(
                        apply: { (domain: $0.0, request: $0.1) },
                        unapply: { ($0.domain, $0.request) }
                    )
                    .map(.case(Mailgun.Messages.API.cases.send))
                ) {
                    let sendMultipartConversion = Mailgun.Messages.SendMultipartConversion()
                    Headers {
                        Field("Content-Type") { sendMultipartConversion.contentType }
                    }
                    Method.post
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.messages
                    URLRouting.Body(sendMultipartConversion)
                }

                URLRouting.Route(
                    .convert(
                        apply: { (domain: $0.0, request: $0.1) },
                        unapply: { ($0.domain, $0.request) }
                    )
                    .map(.case(Mailgun.Messages.API.cases.sendMime))
                ) {
                    let mimeMultipartConversion = Mailgun.Messages.MimeMultipartConversion()
                    Headers {
                        Field("Content-Type") { mimeMultipartConversion.contentType }
                    }
                    Method.post
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path { "messages.mime" }
                    URLRouting.Body(mimeMultipartConversion)
                }

                URLRouting.Route(
                    .convert(
                        apply: { (domain: $0.0, storageKey: $0.1) },
                        unapply: { ($0.domain, $0.storageKey) }
                    )
                    .map(.case(Mailgun.Messages.API.cases.retrieve))
                ) {
                    Method.get
                    Path { "v3" }
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.messages
                    Path { Parse(.string) }
                }

                URLRouting.Route(.case(Mailgun.Messages.API.cases.queueStatus)) {
                    Method.get
                    Path { "v3" }
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path { "sending_queues" }
                }

                URLRouting.Route(.case(Mailgun.Messages.API.cases.deleteScheduled)) {
                    Method.delete
                    Path { "v3" }
                    Path { Parse(.string.representing(Domain.self)) }
                    Path { "envelopes" }
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    public static var messages: Path<PathBuilder.Component<String>> { Path {
        "messages"
    } }

    public static var domains: Path<PathBuilder.Component<String>> { Path {
        "domains"
    } }
}

extension Mailgun.Messages {
    struct SendMultipartConversion: URLRouting.Conversion {
        public let boundary = RFC_2046.Boundary(__unchecked: (), rawValue: "----=_Part_\(UUID().uuidString)")

        public init() {}

        public var contentType: String {
            RFC_2045.ContentType(
                __unchecked: (),
                type: "multipart",
                subtype: "form-data",
                parameters: [.boundary: boundary.rawValue]
            ).headerValue
        }

        public func apply(_ input: Foundation.Data) throws -> Mailgun.Messages.Send.Request {
            fatalError("SendMultipartConversion.apply not implemented - only used for sending")
        }

        public func unapply(_ request: Mailgun.Messages.Send.Request) throws -> Foundation.Data {
            var parts: [RFC_2046.BodyPart] = []

            // Helper to add text field
            func addField(name: String, value: String) {
                parts.append(
                    RFC_2046.BodyPart(
                        headers: RFC_2046.BodyPart.Headers(
                            contentDisposition: .formData(name: name)
                        ),
                        content: RFC_2046.BodyPart.Content(value)
                    )
                )
            }

            // Helper to add file field
            func addFileField(
                name: String,
                filename: String,
                contentType: String,
                data: Foundation.Data
            ) {
                let parsedContentType = try? RFC_2045.ContentType(contentType)
                parts.append(
                    RFC_2046.BodyPart(
                        headers: RFC_2046.BodyPart.Headers(
                            contentDisposition: .formData(
                                name: name,
                                filename: try? RFC_2183.Filename(filename)
                            ),
                            contentType: parsedContentType
                        ),
                        content: RFC_2046.BodyPart.Content(data.map(Byte.init))
                    )
                )
            }

            // Add required fields
            addField(
                name: Mailgun.Messages.Send.Request.CodingKeys.from.rawValue,
                value: request.from.rawValue
            )
            for recipient in request.to {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.to.rawValue,
                    value: recipient.rawValue
                )
            }
            addField(
                name: Mailgun.Messages.Send.Request.CodingKeys.subject.rawValue,
                value: request.subject
            )

            // Add optional text/html content
            if let html = request.html {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.html.rawValue,
                    value: html
                )
            }
            if let text = request.text {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.text.rawValue,
                    value: text
                )
            }

            // Add CC/BCC
            if let cc = request.cc {
                for ccRecipient in cc {
                    addField(
                        name: Mailgun.Messages.Send.Request.CodingKeys.cc.rawValue,
                        value: ccRecipient.rawValue
                    )
                }
            }
            if let bcc = request.bcc {
                for bccRecipient in bcc {
                    addField(
                        name: Mailgun.Messages.Send.Request.CodingKeys.bcc.rawValue,
                        value: bccRecipient.rawValue
                    )
                }
            }

            // Add AMP HTML
            if let ampHtml = request.ampHtml {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.ampHtml.rawValue,
                    value: ampHtml
                )
            }

            // Add template fields
            if let template = request.template {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.template.rawValue,
                    value: template
                )
            }
            if let templateVersion = request.templateVersion {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.templateVersion.rawValue,
                    value: templateVersion
                )
            }
            if let templateText = request.templateText {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.templateText.rawValue,
                    value: templateText ? "yes" : "no"
                )
            }
            if let templateVariables = request.templateVariables {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.templateVariables.rawValue,
                    value: templateVariables
                )
            }

            // Add attachments
            if let attachments = request.attachments {
                for attachment in attachments {
                    addFileField(
                        name: Mailgun.Messages.Send.Request.CodingKeys.attachments.rawValue,
                        filename: attachment.filename,
                        contentType: attachment.contentType,
                        data: attachment.data
                    )
                }
            }

            // Add inline attachments
            if let inline = request.inline {
                for inlineAttachment in inline {
                    addFileField(
                        name: Mailgun.Messages.Send.Request.CodingKeys.inline.rawValue,
                        filename: inlineAttachment.filename,
                        contentType: inlineAttachment.contentType,
                        data: inlineAttachment.data
                    )
                }
            }

            // Add tags
            if let tags = request.tags {
                for tag in tags {
                    addField(
                        name: Mailgun.Messages.Send.Request.CodingKeys.tags.rawValue,
                        value: tag
                    )
                }
            }

            // Add DKIM settings
            if let dkim = request.dkim {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.dkim.rawValue,
                    value: dkim ? "yes" : "no"
                )
            }
            if let secondaryDkim = request.secondaryDkim {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.secondaryDkim.rawValue,
                    value: secondaryDkim
                )
            }
            if let secondaryDkimPublic = request.secondaryDkimPublic {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.secondaryDkimPublic.rawValue,
                    value: secondaryDkimPublic
                )
            }

            // Add delivery time
            if let deliveryTime = request.deliveryTime {
                let formatter = DateFormatter()
                formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
                formatter.locale = Locale(identifier: "en_US_POSIX")
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.deliveryTime.rawValue,
                    value: formatter.string(from: deliveryTime)
                )
            }
            if let deliveryTimeOptimizePeriod = request.deliveryTimeOptimizePeriod {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.deliveryTimeOptimizePeriod
                        .rawValue,
                    value: deliveryTimeOptimizePeriod
                )
            }
            if let timeZoneLocalize = request.timeZoneLocalize {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.timeZoneLocalize.rawValue,
                    value: timeZoneLocalize
                )
            }

            // Add test mode
            if let testMode = request.testMode {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.testMode.rawValue,
                    value: testMode ? "yes" : "no"
                )
            }

            // Add tracking options
            if let tracking = request.tracking {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.tracking.rawValue,
                    value: tracking.rawValue
                )
            }
            if let trackingClicks = request.trackingClicks {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.trackingClicks.rawValue,
                    value: trackingClicks.rawValue
                )
            }
            if let trackingOpens = request.trackingOpens {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.trackingOpens.rawValue,
                    value: trackingOpens ? "yes" : "no"
                )
            }

            // Add TLS settings
            if let requireTls = request.requireTls {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.requireTls.rawValue,
                    value: requireTls ? "yes" : "no"
                )
            }
            if let skipVerification = request.skipVerification {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.skipVerification.rawValue,
                    value: skipVerification ? "yes" : "no"
                )
            }

            // Add sending IP settings
            if let sendingIp = request.sendingIp {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.sendingIp.rawValue,
                    value: sendingIp
                )
            }
            if let sendingIpPool = request.sendingIpPool {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.sendingIpPool.rawValue,
                    value: sendingIpPool
                )
            }

            // Add tracking pixel location
            if let trackingPixelLocationTop = request.trackingPixelLocationTop {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.trackingPixelLocationTop
                        .rawValue,
                    value: trackingPixelLocationTop ? "yes" : "no"
                )
            }

            // Add custom headers
            if let headers = request.headers {
                let headerPrefix = Mailgun.Messages.Send.Request.CodingKeys.headers.rawValue
                for (key, value) in headers {
                    addField(name: "\(headerPrefix):\(key)", value: value)
                }
            }

            // Add custom variables
            if let variables = request.variables {
                let variablePrefix = Mailgun.Messages.Send.Request.CodingKeys.variables.rawValue
                for (key, value) in variables {
                    addField(name: "\(variablePrefix):\(key)", value: value)
                }
            }

            // Add recipient variables
            if let recipientVariables = request.recipientVariables {
                addField(
                    name: Mailgun.Messages.Send.Request.CodingKeys.recipientVariables.rawValue,
                    value: recipientVariables
                )
            }

            // Build and encode multipart message
            let multipart = try RFC_2046.Multipart(
                subtype: .formData,
                parts: parts,
                boundary: boundary
            )
            var bytes: [Byte] = []
            RFC_2046.Multipart.serialize(multipart, into: &bytes)
            return Data(bytes.map(\.underlying))
        }
    }

    struct MimeMultipartConversion: URLRouting.Conversion {
        public let boundary = RFC_2046.Boundary(__unchecked: (), rawValue: "----=_Part_\(UUID().uuidString)")

        public init() {}

        public var contentType: String {
            RFC_2045.ContentType(
                __unchecked: (),
                type: "multipart",
                subtype: "form-data",
                parameters: [.boundary: boundary.rawValue]
            ).headerValue
        }

        public func apply(_ input: Foundation.Data) throws -> Mailgun.Messages.Send.Mime.Request {
            fatalError("MimeMultipartConversion.apply not implemented - only used for sending")
        }

        public func unapply(_ request: Mailgun.Messages.Send.Mime.Request) throws -> Foundation.Data
        {
            var parts: [RFC_2046.BodyPart] = []

            // Helper to add text field
            func addField(name: String, value: String) {
                parts.append(
                    RFC_2046.BodyPart(
                        headers: RFC_2046.BodyPart.Headers(
                            contentDisposition: .formData(name: name)
                        ),
                        content: RFC_2046.BodyPart.Content(value)
                    )
                )
            }

            // Helper to add file field
            func addFileField(name: String, filename: String, data: Foundation.Data) {
                parts.append(
                    RFC_2046.BodyPart(
                        headers: RFC_2046.BodyPart.Headers(
                            contentDisposition: .formData(
                                name: name,
                                filename: try? RFC_2183.Filename(filename)
                            ),
                            contentType: .applicationOctetStream
                        ),
                        content: RFC_2046.BodyPart.Content(data.map(Byte.init))
                    )
                )
            }

            // Add recipients
            for recipient in request.to {
                addField(
                    name: Mailgun.Messages.Send.Mime.Request.CodingKeys.to.rawValue,
                    value: recipient.rawValue
                )
            }

            // Add message as file upload
            addFileField(
                name: Mailgun.Messages.Send.Mime.Request.CodingKeys.message.rawValue,
                filename: "message",
                data: request.message
            )

            // Add optional fields
            if let template = request.template {
                addField(
                    name: Mailgun.Messages.Send.Mime.Request.CodingKeys.template.rawValue,
                    value: template
                )
            }
            if let templateVersion = request.templateVersion {
                addField(
                    name: Mailgun.Messages.Send.Mime.Request.CodingKeys.templateVersion.rawValue,
                    value: templateVersion
                )
            }
            if let templateText = request.templateText {
                addField(
                    name: Mailgun.Messages.Send.Mime.Request.CodingKeys.templateText.rawValue,
                    value: templateText ? "yes" : "no"
                )
            }
            if let templateVariables = request.templateVariables {
                addField(
                    name: Mailgun.Messages.Send.Mime.Request.CodingKeys.templateVariables.rawValue,
                    value: templateVariables
                )
            }
            if let tags = request.tags {
                for tag in tags {
                    addField(
                        name: Mailgun.Messages.Send.Mime.Request.CodingKeys.tags.rawValue,
                        value: tag
                    )
                }
            }
            if let dkim = request.dkim {
                addField(
                    name: Mailgun.Messages.Send.Mime.Request.CodingKeys.dkim.rawValue,
                    value: dkim ? "yes" : "no"
                )
            }
            if let secondaryDkim = request.secondaryDkim {
                addField(
                    name: Mailgun.Messages.Send.Mime.Request.CodingKeys.secondaryDkim.rawValue,
                    value: secondaryDkim
                )
            }
            if let secondaryDkimPublic = request.secondaryDkimPublic {
                addField(
                    name: Mailgun.Messages.Send.Mime.Request.CodingKeys.secondaryDkimPublic
                        .rawValue,
                    value: secondaryDkimPublic
                )
            }
            if let deliveryTime = request.deliveryTime {
                let formatter = DateFormatter()
                formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
                formatter.locale = Locale(identifier: "en_US_POSIX")
                addField(
                    name: Mailgun.Messages.Send.Mime.Request.CodingKeys.deliveryTime.rawValue,
                    value: formatter.string(from: deliveryTime)
                )
            }
            if let deliveryTimeOptimizePeriod = request.deliveryTimeOptimizePeriod {
                addField(
                    name: Mailgun.Messages.Send.Mime.Request.CodingKeys.deliveryTimeOptimizePeriod
                        .rawValue,
                    value: deliveryTimeOptimizePeriod
                )
            }
            if let timeZoneLocalize = request.timeZoneLocalize {
                addField(
                    name: Mailgun.Messages.Send.Mime.Request.CodingKeys.timeZoneLocalize.rawValue,
                    value: timeZoneLocalize
                )
            }
            if let testMode = request.testMode {
                addField(
                    name: Mailgun.Messages.Send.Mime.Request.CodingKeys.testMode.rawValue,
                    value: testMode ? "yes" : "no"
                )
            }
            if let tracking = request.tracking {
                addField(
                    name: Mailgun.Messages.Send.Mime.Request.CodingKeys.tracking.rawValue,
                    value: tracking.rawValue
                )
            }
            if let trackingClicks = request.trackingClicks {
                addField(
                    name: Mailgun.Messages.Send.Mime.Request.CodingKeys.trackingClicks.rawValue,
                    value: trackingClicks.rawValue
                )
            }
            if let trackingOpens = request.trackingOpens {
                addField(
                    name: Mailgun.Messages.Send.Mime.Request.CodingKeys.trackingOpens.rawValue,
                    value: trackingOpens ? "yes" : "no"
                )
            }
            if let requireTls = request.requireTls {
                addField(
                    name: Mailgun.Messages.Send.Mime.Request.CodingKeys.requireTls.rawValue,
                    value: requireTls ? "yes" : "no"
                )
            }
            if let skipVerification = request.skipVerification {
                addField(
                    name: Mailgun.Messages.Send.Mime.Request.CodingKeys.skipVerification.rawValue,
                    value: skipVerification ? "yes" : "no"
                )
            }
            if let sendingIp = request.sendingIp {
                addField(
                    name: Mailgun.Messages.Send.Mime.Request.CodingKeys.sendingIp.rawValue,
                    value: sendingIp
                )
            }
            if let sendingIpPool = request.sendingIpPool {
                addField(
                    name: Mailgun.Messages.Send.Mime.Request.CodingKeys.sendingIpPool.rawValue,
                    value: sendingIpPool
                )
            }
            if let trackingPixelLocationTop = request.trackingPixelLocationTop {
                addField(
                    name: Mailgun.Messages.Send.Mime.Request.CodingKeys.trackingPixelLocationTop
                        .rawValue,
                    value: trackingPixelLocationTop ? "yes" : "no"
                )
            }
            if let headers = request.headers {
                let headerPrefix = Mailgun.Messages.Send.Mime.Request.CodingKeys.headers.rawValue
                for (key, value) in headers {
                    addField(name: "\(headerPrefix):\(key)", value: value)
                }
            }
            if let variables = request.variables {
                let variablePrefix = Mailgun.Messages.Send.Mime.Request.CodingKeys.variables
                    .rawValue
                for (key, value) in variables {
                    addField(name: "\(variablePrefix):\(key)", value: value)
                }
            }
            if let recipientVariables = request.recipientVariables {
                addField(
                    name: Mailgun.Messages.Send.Mime.Request.CodingKeys.recipientVariables.rawValue,
                    value: recipientVariables
                )
            }

            // Build and encode multipart message
            let multipart = try RFC_2046.Multipart(
                subtype: .formData,
                parts: parts,
                boundary: boundary
            )
            var bytes: [Byte] = []
            RFC_2046.Multipart.serialize(multipart, into: &bytes)
            return Data(bytes.map(\.underlying))
        }
    }
}
