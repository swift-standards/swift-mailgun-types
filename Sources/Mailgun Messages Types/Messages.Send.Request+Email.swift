import Email_Standard
import Foundation

extension Mailgun.Messages.Send.Request {
    /// Creates a Mailgun send request from a generic Email
    ///
    /// This initializer converts a provider-agnostic Email type into a Mailgun-specific
    /// send request, with optional Mailgun-specific features.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let email = Email(
    ///     to: [EmailAddress("user@example.com")],
    ///     from: EmailAddress("sender@example.com"),
    ///     subject: "Newsletter",
    ///     body: .multipart(text: "Plain", html: "<h1>HTML</h1>")
    /// )
    ///
    /// let request = Mailgun.Messages.Send.Request(
    ///     email: email,
    ///     tags: ["newsletter"],
    ///     tracking: .yes
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - email: The generic email to send
    ///   - ampHtml: AMP HTML content (optional)
    ///   - template: Template name (optional)
    ///   - templateVersion: Template version (optional)
    ///   - templateText: Whether to use template for text part (optional)
    ///   - templateVariables: Template variables as JSON string (optional)
    ///   - attachments: File attachments (optional)
    ///   - inline: Inline attachments (optional)
    ///   - tags: Message tags for tracking (optional)
    ///   - dkim: Enable DKIM signature (optional)
    ///   - secondaryDkim: Secondary DKIM domain (optional)
    ///   - secondaryDkimPublic: Secondary DKIM public key (optional)
    ///   - deliveryTime: Schedule delivery (optional)
    ///   - deliveryTimeOptimizePeriod: Optimization period for delivery (optional)
    ///   - timeZoneLocalize: Timezone for delivery (optional)
    ///   - testMode: Enable test mode (optional)
    ///   - tracking: Overall tracking option (optional)
    ///   - trackingClicks: Click tracking option (optional)
    ///   - trackingOpens: Open tracking (optional)
    ///   - trackingPixelLocationTop: Pixel location (optional)
    ///   - requireTls: Require TLS (optional)
    ///   - skipVerification: Skip verification (optional)
    ///   - sendingIp: Specific sending IP (optional)
    ///   - sendingIpPool: Sending IP pool (optional)
    ///   - variables: Custom variables (optional)
    ///   - recipientVariables: Per-recipient variables (optional)
    public init(
        email: Email,
        ampHtml: String? = nil,
        template: String? = nil,
        templateVersion: String? = nil,
        templateText: Bool? = nil,
        templateVariables: String? = nil,
        attachments: [Mailgun.Messages.Attachment.Data]? = nil,
        inline: [Mailgun.Messages.Attachment.Data]? = nil,
        tags: [String]? = nil,
        dkim: Bool? = nil,
        secondaryDkim: String? = nil,
        secondaryDkimPublic: String? = nil,
        deliveryTime: Date? = nil,
        deliveryTimeOptimizePeriod: String? = nil,
        timeZoneLocalize: String? = nil,
        testMode: Bool? = nil,
        tracking: Mailgun.Messages.Tracking.Option? = nil,
        trackingClicks: Mailgun.Messages.Tracking.Option? = nil,
        trackingOpens: Bool? = nil,
        trackingPixelLocationTop: Bool? = nil,
        requireTls: Bool? = nil,
        skipVerification: Bool? = nil,
        sendingIp: String? = nil,
        sendingIpPool: String? = nil,
        variables: [String: String]? = nil,
        recipientVariables: String? = nil
    ) {
        // Build headers from email's additional headers plus Reply-To if present
        var headers = email.additionalHeaders
        if let replyTo = email.replyTo {
            headers[.replyTo] = replyTo.address
        }

        // Convert RFC_5322.Header array to [String: String] for Mailgun API
        let headersDict: [String: String]? =
            headers.isEmpty
            ? nil
            : Dictionary(
                uniqueKeysWithValues: headers.map { ($0.name.rawValue, $0.value) }
            )

        // Convert body to text/html
        let (text, html) = Self.convertBody(email.body)

        self.init(
            from: email.from,
            to: email.to,
            subject: email.subject,
            html: html,
            text: text,
            cc: email.cc,
            bcc: email.bcc,
            ampHtml: ampHtml,
            template: template,
            templateVersion: templateVersion,
            templateText: templateText,
            templateVariables: templateVariables,
            attachments: attachments,
            inline: inline,
            tags: tags,
            dkim: dkim,
            secondaryDkim: secondaryDkim,
            secondaryDkimPublic: secondaryDkimPublic,
            deliveryTime: deliveryTime,
            deliveryTimeOptimizePeriod: deliveryTimeOptimizePeriod,
            timeZoneLocalize: timeZoneLocalize,
            testMode: testMode,
            tracking: tracking,
            trackingClicks: trackingClicks,
            trackingOpens: trackingOpens,
            requireTls: requireTls,
            skipVerification: skipVerification,
            sendingIp: sendingIp,
            sendingIpPool: sendingIpPool,
            trackingPixelLocationTop: trackingPixelLocationTop,
            headers: headersDict,
            variables: variables,
            recipientVariables: recipientVariables
        )
    }

    /// Converts Email.Body to Mailgun's text/html format
    private static func convertBody(_ body: Email.Body) -> (text: String?, html: String?) {
        switch body {
        case .text(let data, _):
            return (text: String(data: data, encoding: .utf8), html: nil)
        case .html(let data, _):
            return (text: nil, html: String(data: data, encoding: .utf8))
        case .multipart(let multipart):
            // Extract text and HTML from multipart/alternative
            // For multipart/alternative, the parts are typically [text/plain, text/html]
            var textPart: String?
            var htmlPart: String?

            for part in multipart.parts {
                if let contentType = part.contentType {
                    if contentType.type == "text" && contentType.subtype == "plain" {
                        textPart = part.textContent
                    } else if contentType.type == "text" && contentType.subtype == "html" {
                        htmlPart = part.textContent
                    }
                }
            }

            // If we can't extract text/html parts, this might be a complex multipart
            // that should use Mailgun.Messages.Send.Mime.Request instead
            return (text: textPart, html: htmlPart)
        }
    }
}

// MARK: - Convenience for simple sends

extension Mailgun.Messages.Send.Request {
    /// Creates a simple Mailgun request from an Email (no Mailgun-specific options)
    ///
    /// - Parameter email: The email to send
    public init(email: Email) {
        self.init(
            email: email,
            testMode: nil
        )
    }
}
