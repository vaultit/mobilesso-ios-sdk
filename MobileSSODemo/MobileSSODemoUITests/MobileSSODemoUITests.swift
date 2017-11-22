//
//  MobileSSODemoUITests.swift
//  MobileSSODemoUITests
//
//  Created by Testi on 02/05/2017.
//  Copyright © 2017 Nixu. All rights reserved.
//

import XCTest

fileprivate let LoginButtonLabel = "Click here to login"
fileprivate let LogoutButtonLabel = "Click here to logout"
fileprivate let LoginStateIndicatorLabel = "YOU ARE LOGGED IN AS:"

fileprivate let DeleteDataArgument = "deleteData"

/**
 * This class tests the features of VaultITMobileSSOFramework through the demo app.
 *
 * Test cases are:
 * 1. Test login
 * 2. Test logout
 * 3. Test that session persists between application launches.
 *
 * The tests are not super reliable, since a slow internet connection can cause timeouts to fire when expecting 
 * UI elements in the login web page to appear.
 *
 * Setup: The following keys must be set in the Info.plist of the UI test target: 
 * - TestUsername: The test user's username
 * - TestPasseword: The test user's password
 * - TestUserFullName: The full name in the test user's Qvarn profile
 */
class MobileSSODemoUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    var infoDict: [String:Any] {
        return Bundle(for: MobileSSODemoUITests.self).infoDictionary!
    }
    
    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app = XCUIApplication()
        
        // Uncomment this to delete app data between tests. Currently not necessary.
        // app.launchArguments.append(DeleteDataArgument)
        
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test1SuccessfulLogin() {
        logoutIfNeeded()
        
        let loginButton = app.buttons[LoginButtonLabel]
        loginButton.tap()
        
        // EXPECTATION: Safari will appear
        
        let oxauthLoginElement = app.webViews.otherElements["oxAuth - Login"]
        
        // Here we need to sleep because we don't know whether to expect an auto-login.
        // We can't touch the system Safari state or cookies so this is necessary.
        sleep(3)
        
        logoutIfNeeded()
        
        // EXPECTATION: There will be a login screen with username and password fields.
        
        let infoDict = self.infoDict
        let usernameString = infoDict["TestUsername"] as! String
        let passwordString = infoDict["TestPassword"] as! String
        
        let usernameField = oxauthLoginElement.children(matching: .other).element(boundBy: 3).children(matching: .textField).element
        
        usernameField.forceTap()
        usernameField.typeText(usernameString)
        
        let passwordField = oxauthLoginElement.children(matching: .other).element(boundBy: 5).children(matching: .secureTextField).element
        passwordField.forceTap()
        passwordField.typeText(passwordString)
        
        oxauthLoginElement.swipeRight() // Will reveal the login button
        oxauthLoginElement.buttons["Login"].forceTap()
        
        // EXPECTATION: User is now logged in
        
        checkLoginIsSuccessful()
    }
    
    private func logoutIfNeeded() {
        let logoutButton = app.buttons[LogoutButtonLabel]
        
        if logoutButton.exists {
            // Auto-login occurred -> this means the Safari remembers the login cookie.
            logoutButton.tap()
            sleep(2)
        }
    }
    
    private func checkLoginIsSuccessful() {
        let loggedInLabel = app.staticTexts[LoginStateIndicatorLabel]
        waitForElementToAppear(element: loggedInLabel)
        XCTAssert(loggedInLabel.exists)
        
        // EXPECTATION: User profile is now loaded from Qvarn and displays the correct info
        let profileFullName = infoDict["TestUserFullName"] as! String
        let fullNameLabel = app.staticTexts[profileFullName]
        waitForElementToAppear(element: fullNameLabel)
        XCTAssert(fullNameLabel.exists)
    }
    
    func test2Logout() {
        // PREQUISITE: Login is successful
        test1SuccessfulLogin()
        
        // EXPECTATION: Log out button takes the app back to the login screen
        let logoutButton = app.buttons[LogoutButtonLabel]
        
        logoutButton.tap()
        
        let loginButton = app.buttons[LoginButtonLabel]
        
        // EXPECTATION: We need to see the login button again.
        waitForElementToAppear(element: loginButton)
        XCTAssert(loginButton.exists)
    }
    
    func test3PersistSession() {
        // PREQUISITE: Login is successful
        test1SuccessfulLogin()
        
        // Kill the app
        app.terminate()
        
        // Relaunch the app
        app.launch()
        
        // EXPECTATION: Login is restored successfully
        checkLoginIsSuccessful()
        
        // CLEANUP: Logout
        logoutIfNeeded()
    }
    
    func waitForElementToAppear(element: XCUIElement, timeout: TimeInterval = 5,  file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        
        waitForExpectations(timeout: timeout) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after \(timeout) seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: Int(line), expected: true)
            }
        }
    }
}

extension XCUIElement {
    /// This is a hack to ensure hitting UI elements inside Safari.
    func forceTap() {
        if self.isHittable {
            self.tap()
        } else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
            coordinate.tap()
        }
    }
    
    /// This is a hack to ensure hitting UI elements inside Safari.
    func forceDoubleTap() {
        if self.isHittable {
            self.tap()
        } else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
            coordinate.doubleTap()
        }
    }
}
