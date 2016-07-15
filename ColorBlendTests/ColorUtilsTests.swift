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
    
    func testClosestMatch() {
        XCTAssertEqual(ColorName.closestMatch(UIColor.blackColor()), "Black")
        XCTAssertEqual(ColorName.closestMatch(UIColor.whiteColor()), "White")
        XCTAssertEqual(ColorName.closestMatch(UIColor.blueColor()),  "Blue")
        XCTAssertEqual(ColorName.closestMatch(UIColor.redColor()),   "Red")
        XCTAssertEqual(ColorName.closestMatch(UIColor.greenColor()), "Green")
        XCTAssertEqual(ColorName.closestMatch(UIColor.cyanColor()),  "Cyan")
        XCTAssertEqual(ColorName.closestMatch(UIColor.magentaColor()),  "Magenta")
        XCTAssertEqual(ColorName.closestMatch(UIColor.orangeColor()),  "Orange")
        XCTAssertEqual(ColorName.closestMatch(UIColor.brownColor()),  "Brown")
        XCTAssertEqual(ColorName.closestMatch(UIColor.lightGrayColor()),  "Light gray")
        XCTAssertEqual(ColorName.closestMatch(UIColor.darkGrayColor()),  "Dark gray")
        XCTAssertEqual(ColorName.closestMatch(UIColor.purpleColor()),  "Purple")
        
        XCTAssertEqual(ColorName.closestMatch(UIColor.init(red: 0, green: 0.0784313725490196, blue: 0.6588235294117647, alpha: 1.0)), "Zaffre")
        XCTAssertEqual(ColorName.closestMatch(UIColor.init(red: 0, green: 0.079, blue: 0.6588235294117647, alpha: 1.0)), "Zaffre")
    }
    
    func testNoDuplicateNames() {
        for spec in ColorName.ColorNames {
            let color = UIColor.init(red: spec.red, green: spec.green, blue: spec.blue, alpha: 1)
            XCTAssertEqual(ColorName.closestMatch(color), spec.name)
        }
    }
    
    func testHSVBlend() {
        XCTAssertEqual(ColorName.closestMatch(ColorUtils.hsvBlend([UIColor.redColor()])), "Red")
        XCTAssertEqual(ColorName.closestMatch(ColorUtils.hsvBlend([UIColor.blueColor()])), "Blue")
        XCTAssertEqual(ColorName.closestMatch(ColorUtils.hsvBlend([UIColor.redColor(), UIColor.blueColor()])), "Magenta")
        XCTAssertEqual(ColorName.closestMatch(ColorUtils.hsvBlend([UIColor.yellowColor(), UIColor.blueColor()])), "Spring green")
        XCTAssertEqual(ColorName.closestMatch(ColorUtils.hsvBlend([UIColor.redColor(), UIColor.redColor(), UIColor.greenColor()])), "Orange")
        

        let neutral = ColorUtils.hsvBlend([
            UIColor.blueColor(),
            UIColor.redColor(),
            UIColor.greenColor()
            ]);

        // This is nonintuitive, but due to the slight rounding this is what happens.
        XCTAssertEqual(ColorName.closestMatch(neutral), "Blue");
    }
    
    func colorWithHue(hueDegrees: Int) -> UIColor {
        return UIColor.init(hue: CGFloat(hueDegrees) / 360, saturation: 1, brightness: 1, alpha: 1)
    }
    
    func testClosestPrimaryHue() {
        func getClosestHue(hueDegrees: Int) -> Int {
            let color = colorWithHue(hueDegrees)
            return ColorUtils.getHueDegrees(ColorUtils.closestPrimaryColor(color))
        }
        
        XCTAssertEqual(getClosestHue(0), 360);
        XCTAssertEqual(getClosestHue(10), 360);
        XCTAssertEqual(getClosestHue(29), 360);
        XCTAssertEqual(getClosestHue(30), 60);
        XCTAssertEqual(getClosestHue(31), 60);
        XCTAssertEqual(getClosestHue(65), 60);
        XCTAssertEqual(getClosestHue(89), 60);
        XCTAssertEqual(getClosestHue(91), 120);
        XCTAssertEqual(getClosestHue(149), 120);
        XCTAssertEqual(getClosestHue(150), 180);
        XCTAssertEqual(getClosestHue(209), 180);
        XCTAssertEqual(getClosestHue(210), 240);
        XCTAssertEqual(getClosestHue(269), 240);
        XCTAssertEqual(getClosestHue(270), 300);
        XCTAssertEqual(getClosestHue(329), 300);
        XCTAssertEqual(getClosestHue(330), 360);
        XCTAssertEqual(getClosestHue(359), 360);
        XCTAssertEqual(getClosestHue(360), 360);
    }

    func describe(color: UIColor) -> String {
        var h: CGFloat = 0;
        var s: CGFloat = 0;
        var v: CGFloat = 0;
        color.getHue(&h, saturation: &s, brightness: &v, alpha: nil)
        
        let name = ColorName.closestMatch(color);
        let colorStr = "[\(name) \(String(Int(h * 360))) \(String(Int(s * 100))) \(String(Int(v * 100)))]";
        return colorStr;
    }
    
    func testHSVUnblend() {
        func S(colors: [UIColor]) -> String {
            var strs: [String] = [];
            
            for color in colors {
                strs.append(describe(color))
            }
            
            return strs.joinWithSeparator(" ");
        }
        
        XCTAssertEqual(S(ColorUtils.hsvUnblend(Constants.Palette.red)),
                       "[Red 360 100 100]")
        XCTAssertEqual(S(ColorUtils.hsvUnblend(Constants.Palette.orange)), "[Yellow 60 100 100] [Red 360 100 100]")
        XCTAssertEqual(S(ColorUtils.hsvUnblend(Constants.Palette.brown)),
                       "[Yellow 60 100 100] [Red 360 100 100] [White 0 0 100] [Black 0 0 0] [Black 0 0 0]")
        XCTAssertEqual(S(ColorUtils.hsvUnblend(Constants.Palette.pink)), "[Red 360 100 100] [Magenta 300 100 100] [Red 360 100 100] [Red 360 100 100] [Red 360 100 100] [White 0 0 100] [White 0 0 100] [White 0 0 100] [White 0 0 100] [White 0 0 100] [White 0 0 100] [White 0 0 100] [White 0 0 100] [White 0 0 100] [White 0 0 100] [White 0 0 100] [White 0 0 100] [White 0 0 100] [White 0 0 100] [White 0 0 100]")
    }
    
    func testHSVUnblendAllColors() {
        func getBlend(spec: ColorName) -> UIColor {
            print("Testing unblend for \(spec.name)")
            let color = UIColor(red: spec.red, green: spec.green, blue: spec.blue, alpha: 1)
            let components = ColorUtils.hsvUnblend(color)
            let blend = ColorUtils.hsvBlend(components)
            return blend;
        }

        func getColor(spec: ColorName) -> UIColor {
            return UIColor(red: spec.red, green: spec.green, blue: spec.blue, alpha: 1)
        }

/*
        XCTAssertEqual(ColorName.closestMatch(getBlend(ColorName.get("Air Force blue")!)), "Air Force blue")
        XCTAssertEqual(ColorName.closestMatch(getBlend(ColorName.get("Alice blue")!)), "Alice blue")
        XCTAssertEqual(ColorName.closestMatch(getBlend(ColorName.get("Alizarin crimson")!)), "Alizarin crimson")
        XCTAssertEqual(ColorName.closestMatch(getBlend(ColorName.get("Almond")!)), "Almond")
        XCTAssertEqual(ColorName.closestMatch(getBlend(ColorName.get("Amaranth")!)), "Amaranth")
        XCTAssertEqual(ColorName.closestMatch(getBlend(ColorName.get("Amber")!)), "Amber")
        XCTAssertEqual(ColorName.closestMatch(getBlend(ColorName.get("Amber (SAE/ECE)")!)), "Amber (SAE/ECE)")
        XCTAssertEqual(ColorName.closestMatch(getBlend(ColorName.get("American rose")!)), "American rose")
        XCTAssertEqual(ColorName.closestMatch(getBlend(ColorName.get("Amethyst")!)), "Amethyst")
*/
    }

    
    func testMatchPerformance() {
        // This is an example of a performance test case.
        self.measureBlock {
            ColorName.closestMatch(UIColor.whiteColor())
        }
    }
    
}

