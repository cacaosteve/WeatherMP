import SwiftUI
import Alamofire
import Combine

public class WeatherFetcher: ObservableObject {
    @Published var response : Response?
    @Published var title = ""
    @Published var showingAlert = false
    @Published var isLoading = false
    @AppStorage("zip") var zip = 94024
    var subscriptions = Set<AnyCancellable>()
    
    init(){
        loadWithAF()
        
        UserDefaults.standard
            .publisher(for: \.zip)
            .handleEvents(receiveOutput: { zipCode in
                self.loadWithAF()
            })
            .sink { _ in }
            .store(in: &subscriptions)
    }
    
    func loadWithAF() {
        isLoading = true
        let request = AF.request("https://api.openweathermap.org/data/2.5/weather?zip=\(zip)&units=imperial&appid=c9f9c127d30aa092df526660d71c1167")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        request.responseDecodable(of: Response.self, decoder: decoder) { (response) in
            print(response)
            switch response.result {
            case .success(let value):
                self.response = value
//                self.title = value.title
            case .failure( _):
                self.showingAlert = true
            }
            self.isLoading = false
        }
    }
}
