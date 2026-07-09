//
//  Logs.Client.swift
//  swift-mailgun-types
//
//  Created by Coen ten Thije Boonkkamp on 31/12/2024.
//

import Dependencies
import Foundation
import Mailgun_Types_Shared

extension Mailgun.Reporting.Logs {
    @Witness
    public struct Client: Sendable {
        public var analytics:
            @Sendable (_ request: Analytics.Request) async throws -> Analytics.Response
    }
}
