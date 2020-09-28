import SwiftUI
import Alamofire
import Combine

public class CityIDFetcher: ObservableObject {
    @Published var city = 0
    @Published var showingAlert = false
    @AppStorage("cityName") var cityName = "San Diego"
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
        let cityURLString = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let request = AF.request("https://www.metaweather.com/api/location/search/?query=\(cityURLString!)")
        
        let decoder = JSONDecoder()
        
        request.responseDecodable(of: [City].self, decoder: decoder) { (response) in
            print(response)
            switch response.result {
            case .success(let value):
                print(value)
                if value.count > 0 {
                    self.woeid = value[0].woeid
                }
            case .failure( _):
                self.showingAlert = true
            }
        }
    }
}
