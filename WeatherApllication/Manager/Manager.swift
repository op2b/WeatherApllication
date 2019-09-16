import Foundation

class Manager {
    private init() {}
    
    static let shared: Manager = Manager()
    
    func getWeather(city: String, result: @escaping((OfferModel?) -> ())) {
        
        var urlComponents  = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host  = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/weather"
        urlComponents.queryItems = [URLQueryItem(name: "units", value: "metric"),
                                    URLQueryItem(name: "q", value: city),
                                    URLQueryItem(name: "appid", value: "c5293f02bea201be37a2701878bfc312")]
        
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        
        let task = URLSession(configuration: .default)
        task.dataTask(with: request) { (data, response, error) in
            
            if error == nil {
                let decoder = JSONDecoder()
                var decoderOfferModel: OfferModel?
                
                
                
                if data != nil {
                    decoderOfferModel = try? decoder.decode(OfferModel.self, from: data!)
                }
                result(decoderOfferModel)
            } else {
                print(error as Any)
            }
            
            }.resume()
        
    }
    
}
