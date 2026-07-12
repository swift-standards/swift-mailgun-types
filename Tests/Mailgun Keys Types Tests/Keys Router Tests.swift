//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies_Test_Support
import Testing

@testable import Mailgun_Keys_Types

@Suite(
    "Keys Router Tests"
)
struct KeysRouterTests {

    @Test("Creates correct URL for listing keys")
    func testListKeysURL() throws {
        let router: Mailgun.Keys.API.Router = .init()

        let api: Mailgun.Keys.API = .list

        let url = router.url(for: api)
        #expect(url.path == "/v1/keys")

        let match: Mailgun.Keys.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.list))
    }

    @Test("Creates correct URL for creating a key")
    func testCreateKeyURL() throws {
        let router: Mailgun.Keys.API.Router = .init()

        let request = Mailgun.Keys.Create.Request(description: "Test API Key")
        let api: Mailgun.Keys.API = .create(request: request)

        let url = router.url(for: api)
        #expect(url.path == "/v1/keys")

        let match: Mailgun.Keys.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.create))
        #expect(Mailgun.Keys.API.cases.create.extract(match)?.description == "Test API Key")
    }

    @Test("Creates correct URL for deleting a key")
    func testDeleteKeyURL() throws {
        let router: Mailgun.Keys.API.Router = .init()

        let keyId = "test-key-123"
        let api: Mailgun.Keys.API = .delete(keyId: keyId)

        let url = router.url(for: api)
        #expect(url.path == "/v1/keys/test-key-123")

        let match: Mailgun.Keys.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.delete))
        #expect(Mailgun.Keys.API.cases.delete.extract(match)?.description == "test-key-123")
    }

    @Test("Creates correct URL for adding public key")
    func testAddPublicKeyURL() throws {
        let router: Mailgun.Keys.API.Router = .init()

        let request = Mailgun.Keys.PublicKey.Request(
            publicKey: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ..."
        )
        let api: Mailgun.Keys.API = .addPublicKey(request: request)

        let url = router.url(for: api)
        #expect(url.path == "/v1/keys/public")

        let match: Mailgun.Keys.API = try router.match(request: try router.request(for: api))
        #expect(match.is(\.addPublicKey))
        #expect(Mailgun.Keys.API.cases.addPublicKey.extract(match)?.publicKey == "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ...")
    }

    @Test("Verifies all endpoints use v1 API version")
    func testAllEndpointsUseV1() throws {
        let router: Mailgun.Keys.API.Router = .init()

        let listApi: Mailgun.Keys.API = .list
        let createApi: Mailgun.Keys.API = .create(request: .init())
        let deleteApi: Mailgun.Keys.API = .delete(keyId: "123")
        let addPublicKeyApi: Mailgun.Keys.API = .addPublicKey(request: .init(publicKey: "test"))

        let listUrl = router.url(for: listApi)
        let createUrl = router.url(for: createApi)
        let deleteUrl = router.url(for: deleteApi)
        let addPublicKeyUrl = router.url(for: addPublicKeyApi)

        #expect(listUrl.path.hasPrefix("/v1/"))
        #expect(createUrl.path.hasPrefix("/v1/"))
        #expect(deleteUrl.path.hasPrefix("/v1/"))
        #expect(addPublicKeyUrl.path.hasPrefix("/v1/"))
    }
}
