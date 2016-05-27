import XCTest
import UIKit
@testable import ColorBlend

class ColorUtilsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        XCTAssertEqual(ColorName.closestMatch(UIColor.blackColor()), "Black")
        XCTAssertEqual(ColorName.closestMatch(UIColor.whiteColor()), "White")
        XCTAssertEqual(ColorName.closestMatch(UIColor.blueColor()),  "Blue")
        XCTAssertEqual(ColorName.closestMatch(UIColor.cyanColor()),  "Cyan")
        
        XCTAssertEqual(ColorName.closestMatch(UIColor.init(red: 0, green: 0.0784313725490196, blue: 0.6588235294117647, alpha: 1.0)), "Zaffre")
        XCTAssertEqual(ColorName.closestMatch(UIColor.init(red: 0, green: 0.079, blue: 0.6588235294117647, alpha: 1.0)), "Zaffre")

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            ColorName.closestMatch(UIColor.whiteColor())
        }
    }
    
}

