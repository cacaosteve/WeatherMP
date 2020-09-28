import SwiftUI
import Alamofire
import Combine

struct ResponseData : Decodable {
    var weathers: [Weather]
}

public class WeatherFetcher: ObservableObject {
    @Published var consolidatedWeathers = [ConsolidatedWeather]()
    @Published var title = ""
    @Published var showingAlert = false
    @AppStorage("woeid") var woeid = 2487889
    var subscriptions = Set<AnyCancellable>()
    
    init(){
        loadWithAF()
        
        UserDefaults.standard
            .publisher(for: \.cityName)
            .handleEvents(receiveOutput: { cityName in
                self.loadWithAF()
            })
            .sink { _ in }
            .store(in: &subscriptions)
    }
    
    func loadWithAF() {
        let request = AF.request("https://www.metaweather.com/api/location/\(woeid)/")
        
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
