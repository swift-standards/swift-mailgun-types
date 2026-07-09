//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import Mailgun_Types_Shared

extension Mailgun.Domains.DKIM_Security {
    @Witness
    public struct Client: Sendable {
        public var updateRotation:
            @Sendable (
                _ domain: Domain,
                _ request: Mailgun.Domains.DKIM_Security.Rotation.Update.Request
            ) async throws -> Mailgun.Domains.DKIM_Security.Rotation.Update.Response
        public var rotateManually:
            @Sendable (_ domain: Domain) async throws ->
                Mailgun.Domains.DKIM_Security.Rotation.Manual.Response
    }
}
