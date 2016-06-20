//
//  TableViewPopoverPresenting_UITests.swift
//  TableViewPopoverPresenting_UITests
//
//  Created by Daniel Loewenherz on 6/19/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
//import Nimble
//import Quick
@testable import TableViewPopoverPresenting

class TableViewPopoverPresenting_ExampleUITests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testExample() {
        let app = XCUIApplication()
        let tablesQuery = app.tables

        //        describe("the first table view row") {
        //            it("displays a popover when you tap it") {
        //                tablesQuery.staticTexts["Cell #0"].tap()
        //                app.sheets["Important Question"].collectionViews.buttons["Red"].tap()
        //            }
        //        }

        tablesQuery.staticTexts["Cell #1"].tap()
        app.alerts["Hey"].collectionViews.buttons[":("].tap()
    }
}
