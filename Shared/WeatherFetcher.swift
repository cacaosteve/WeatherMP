import SwiftUI
import Alamofire

struct ResponseData : Decodable {
    var weathers: [Weather]
}

public class WeatherFetcher: ObservableObject {
    @Published var consolidatedWeathers = [ConsolidatedWeather]()
    @Published var title = ""
    @Published var showingAlert = false
    
    init(){
        loadWithAF()
    }
    
    func loadWithAF() {
        let request = AF.request("https://www.metaweather.com/api/location/2487889/")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        request.responseDecodable(of: Weather.self, decoder: decoder) { (response) in
            print(response)
            switch response.result {
            case .success(let value):
                self.consolidatedWeathers = value.consolidatedWeather
                self.title = value.title
            case .failure( _):
                self.showingAlert = true
            }
        }
    }
}
