//
//  ExampleAppTests.swift
//  ExampleAppTests
//
//  Created by Denis Efimov on 6/22/20.
//  Copyright © 2020 Freshly. All rights reserved.
//

import Behave
@testable import ExampleApp
import XCTest

class HomeViewControllerBDDTests: XCTestCase {
    func testLaunchApp_StartScreen_isHomeViewController() {
        let expectations = expectation(description: "\(#function)")
        let api = Behaviour()
        api.listen(for: "login-view") {
            api.stubNetworkRequest(stub: Stub(httpMethod: HTTPMethods.post, httpResponse: 200, jsonReturn: "{\"success\":\"true\"}"))
            api.typeIntoTextField(identifier: "email", text: "email")
            api.typeIntoTextField(identifier: "password", text: "password")
            api.tapButton(identifier: "submit")
        }
        api.listen(for: "home-view") {
            api.tapRightNavigationItem()
            api.selectTableRow(identfier: "home-view", indexPath: IndexPath(row: 0, section: 0))

        }
        api.listen(for: "detail-view") {
            expectations.fulfill()
        }
        api.run { error in
            if let error = error {
                XCTFail(error)
            }
        }
        waitForExpectations(timeout: api.testTimeInSeconds)
    }
}