//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Mailgun_AccountManagement_Types
import Mailgun_Credentials_Types
import Mailgun_CustomMessageLimit_Types
import Mailgun_Domains_Types
import Mailgun_IPAllowlist_Types
import Mailgun_IPPools_Types
import Mailgun_IPs_Types
import Mailgun_Keys_Types
import Mailgun_Lists_Types
import Mailgun_Messages_Types
import Mailgun_Reporting_Types
import Mailgun_Routes_Types
import Mailgun_Subaccounts_Types
import Mailgun_Suppressions_Types
import Mailgun_Templates_Types
import Mailgun_Types_Shared
import Mailgun_Users_Types
import Mailgun_Webhooks_Types

extension Mailgun {
    @Witness
    public struct Client: Sendable {
        public let messages: Mailgun.Messages.Client
        public let mailingLists: Mailgun.Lists.Client
        public let events: Mailgun.Reporting.Events.Client
        public let suppressions: Mailgun.Suppressions.Client
        public let webhooks: Mailgun.Webhooks.Client
        public let domains: Mailgun.Domains.Client
        public let templates: Mailgun.Templates.Client
        public let routes: Mailgun.Routes.Client
        public let ips: Mailgun.IPs.Client
        public let ipPools: Mailgun.IPPools.Client
        public let ipAllowlist: Mailgun.IPAllowlist.Client
        public let keys: Mailgun.Keys.Client
        public let users: Mailgun.Users.Client
        public let subaccounts: Mailgun.Subaccounts.Client
        public let credentials: Mailgun.Credentials.Client
        public let customMessageLimit: Mailgun.CustomMessageLimit.Client
        public let accountManagement: Mailgun.AccountManagement.Client
        public let reporting: Mailgun.Reporting.Client

        public init(
            messages: Mailgun.Messages.Client,
            mailingLists: Mailgun.Lists.Client,
            events: Mailgun.Reporting.Events.Client,
            suppressions: Mailgun.Suppressions.Client,
            webhooks: Mailgun.Webhooks.Client,
            domains: Mailgun.Domains.Client,
            templates: Mailgun.Templates.Client,
            routes: Mailgun.Routes.Client,
            ips: Mailgun.IPs.Client,
            ipPools: Mailgun.IPPools.Client,
            ipAllowlist: Mailgun.IPAllowlist.Client,
            keys: Mailgun.Keys.Client,
            users: Mailgun.Users.Client,
            subaccounts: Mailgun.Subaccounts.Client,
            credentials: Mailgun.Credentials.Client,
            customMessageLimit: Mailgun.CustomMessageLimit.Client,
            accountManagement: Mailgun.AccountManagement.Client,
            reporting: Mailgun.Reporting.Client
        ) {
            self.messages = messages
            self.mailingLists = mailingLists
            self.events = events
            self.suppressions = suppressions
            self.webhooks = webhooks
            self.domains = domains
            self.templates = templates
            self.routes = routes
            self.ips = ips
            self.ipPools = ipPools
            self.ipAllowlist = ipAllowlist
            self.keys = keys
            self.users = users
            self.subaccounts = subaccounts
            self.credentials = credentials
            self.customMessageLimit = customMessageLimit
            self.accountManagement = accountManagement
            self.reporting = reporting
        }
    }
}
