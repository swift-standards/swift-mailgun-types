import Email_Standard
import Foundation

extension Mailgun.Messages.Client {
    /// Sends an email with optional Mailgun-specific features
    ///
    /// Convenience method that converts a generic Email into a Mailgun request
    /// and sends it with optional Mailgun-specific options.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let email = Email(
    ///     to: [EmailAddress("user@example.com")],
    ///     from: EmailAddress("sender@example.com"),
    ///     subject: "Newsletter",
    ///     body: .html("<h1>Welcome!</h1>")
    /// )
    ///
    /// let response = try await mailgun.messages.send(
    ///     email: email,
    ///     tags: ["newsletter"],
    ///     tracking: .yes
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - email: The email to send
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
    /// - Returns: Send response from Mailgun
    /// - Throws: Error if sending fails
    public func send(
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
    ) async throws -> Mailgun.Messages.Send.Response {
        let request = Mailgun.Messages.Send.Request(
            email: email,
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
            trackingPixelLocationTop: trackingPixelLocationTop,
            requireTls: requireTls,
            skipVerification: skipVerification,
            sendingIp: sendingIp,
            sendingIpPool: sendingIpPool,
            variables: variables,
            recipientVariables: recipientVariables
        )

        return try await send(request)
    }
}
