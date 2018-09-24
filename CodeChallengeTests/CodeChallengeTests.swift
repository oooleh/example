//
//  CodeChallengeTests.swift
//  CodeChallengeTests
//
//  Created by Oleh Kudinov on 22/9/18.
//

import XCTest
@testable import CodeChallenge

class CodeChallengeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Transactions List
    
    func testTransactionsList_WhenOnEditMode_AllowsMultipleSelection() {
        // given
        var viewModel = TransactionsListViewModel()
        // when
        viewModel.mode = .edition
        // then
        XCTAssertTrue(viewModel.allowsMultipleSelection)
    }
}
