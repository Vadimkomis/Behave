//
//  MobileLoginBDDTests.swift
//  MobileTestPRTests
//
//  Created by Derek Bronston on 10/9/19.
//  Copyright © 2019 Freshly. All rights reserved.
//

import Behave
import XCTest

@testable import ExampleApp

class LoginTests: XCTestCase {
    func testGivenTheUserEntersCredsWhenTheUserTapsSubmitAndTheRequestSucceedsThenDisplayHome() {
        let expectations = expectation(description: "\(#function)")
        let api = Behaviour()
        api.listen(for: "login-view") {
            api.stubNetworkRequest(stub: Stub(httpMethod: HTTPMethods.post, httpResponse: 200, jsonReturn: "{\"success\":\"true\"}"))
            api.typeIntoTextField(identifier: "email", text: "email")
            api.typeIntoTextField(identifier: "password", text: "password")
            api.tapButton(identifier: "submit")
        }
        api.listen(for: "home-view") {
            expectations.fulfill()
        }
        api.run(fail: { error in
            XCTFail(error)
        })
        waitForExpectations(timeout: api.testTimeInterval)
    }
    
    func testGivenTheUserEntersCredsWhenTheUserTapsSubmitAndTheRequestFailureThenDisplayAlert() {
        let expectations = expectation(description: "\(#function)")
        let api = Behaviour()
        api.listen(for: "login-view") {
            api.stubNetworkRequest(stub: Stub(httpMethod: HTTPMethods.post,
                                              httpResponse: 401,
                                              jsonReturn: "{\"error\":\"bad login creds\", \"message\":\"bad login creds\", \"status\":\"error\"}"))
            api.typeIntoTextField(identifier: "email", text: "email")
            api.typeIntoTextField(identifier: "password", text: "password")
            api.tapButton(identifier: "submit")
            api.waitForAlert {
                expectations.fulfill()
            }
        }
        api.run(fail: { error in
            XCTFail(error)
        })
        waitForExpectations(timeout: api.testTimeInterval)
    }
    
}
