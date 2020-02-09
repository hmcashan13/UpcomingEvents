//
//  UpcomingEventsTests.swift
//  UpcomingEventsTests
//
//  Created by Hudson Mcashan on 2/7/20.
//

import XCTest
import Combine
@testable import UpcomingEvents

class UpcomingEventsPerformanceTests: XCTestCase {
    let repo = EventRepository.shared
    var disposables = Set<AnyCancellable>()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadingExample() {
        let expectation = XCTestExpectation(description: "loading expectation")
        let viewModel = EventViewModel(repository: repo)
        viewModel.refresh()
        viewModel.$loading.sink { (loading) in
            XCTAssertEqual(loading, true)
            expectation.fulfill()
        }.store(in: &disposables)
        self.wait(for: [expectation], timeout: 5)
    }

    func testDataSortingAndConflictingAlgorithmPerformanceExample() {
        let expectation = XCTestExpectation(description: "data expectation")
        // This is an example of a performance test case.
        self.measure {
            repo.data.sink { (events) in
                if events?.count == 21 {
                    expectation.fulfill()
                }
            }.store(in: &disposables)
        }
        
        self.wait(for: [expectation], timeout: 5)
    }

}
