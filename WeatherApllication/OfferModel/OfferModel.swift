import CoreLocation
import Foundation

class OfferModel: Codable {
    var coord: CoordModel?
    var weather: [WeatherModel]?
    var main: MainOfferModel?
    var wind: WindModel?
    var clouds: CloudModel?
    var name: String?
    
    
    func getWeatherID() -> String {
        var weatherArray = [String]()
        for id in weather! {
            print(id)
            weatherArray.append(id.icon!)
        }
        return weatherArray[0]
    }
}



