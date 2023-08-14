import XCTest

@testable import Battery

class BatteryApiTests: XCTestCase {

    var api: Battery.Api!
    
    override func setUp() {
        super.setUp()
        api = Battery.Api()
    }

    
    func testGetChargingStatus() throws {
        let status = try api.get_sms_charging_status()
        XCTAssertTrue(status)
    }
    
}
