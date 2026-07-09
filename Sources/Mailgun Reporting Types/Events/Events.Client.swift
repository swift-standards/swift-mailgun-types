//
//  File.swift
//  swift-mailgun
//
//  Created by coenttb on 26/12/2024.
//

import Dependencies
import Mailgun_Types_Shared

extension Mailgun.Reporting.Events {
    @Witness
    public struct Client: Sendable {
        public var list:
            @Sendable (_ query: Mailgun.Reporting.Events.List.Query?) async throws ->
                Mailgun.Reporting.Events.List.Response
    }
}
