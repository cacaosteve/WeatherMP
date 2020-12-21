import SwiftUI
import Alamofire
import Combine
import SwiftKeychainWrapper
import AuthenticationServices

public class WeatherViewModel: ObservableObject {
    @Published var response : Response?
    @Published var title = ""
    @Published var name = ""
    @Published var id = 0
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
        
        UserDefaults.standard
            .publisher(for: \.name)
            .handleEvents(receiveOutput: { name in
                self.name = name
            })
            .sink { _ in }
            .store(in: &subscriptions)
        
        UserDefaults.standard
            .publisher(for: \.id)
            .handleEvents(receiveOutput: { id in
                self.id = id
            })
            .sink { _ in }
            .store(in: &subscriptions)
    }
    
    func logout() {
        self.name = ""
        //self.id = 0
        UserDefaults.standard.removeObject(forKey: "name")
        //UserDefaults.standard.removeObject(forKey: "id")
        KeychainWrapper.standard.removeObject(forKey: "access_token")
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
                if let id = UserDefaults.standard.object(forKey: "id") {
                    UserDefaults.standard.setValue(self.zip, forKey: id as! String)
                }
            case .failure( _):
                self.showingAlert = true
            }
            self.isLoading = false
        }
    }
}

class SignInViewModel: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    
    func signIn() {
        let authSession = ASWebAuthenticationSession(
            url: URL(string: "https://www.facebook.com/v9.0/dialog/oauth?client_id=732008171068255&client_secret=7d090ca45feef4e4820822f268efc0ce&display=popup&response_type=token&redirect_uri=fb732008171068255://authorize")!, callbackURLScheme:
                "fb732008171068255") { (url, error) in
            if let error = error {
                    print(error)// Handle the error here. An error can even be when the user cancels authentication.
            } else if let url = url {
                self.processResponseURL(url: url)
            }
        }
        
        authSession.presentationContextProvider = self
        authSession.prefersEphemeralWebBrowserSession = true
        authSession.start()
    }
    
    func processResponseURL(url: URL) {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        if  let fragment = components?.fragment,
            let dummyURL = URL(string: "fb732008171068255://authorize?\(fragment)"),
            let components = URLComponents(url: dummyURL, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems,
            let token = queryItems.filter ({ $0.name == "access_token" }).first?.value,
            let expirationDate = queryItems.filter ({ $0.name == "expires_in" }).first?.value
            {
            
            KeychainWrapper.standard.set(token, forKey: "access_token")
            self.loadUserID()
            /// Store the token expiration date if necessary.
        }
    }
    
    func loadUserID() {
        let retrievedString: String? = KeychainWrapper.standard.string(forKey: "access_token")
        
        let request = AF.request("https://graph.facebook.com/me?fields=id,name&access_token=\(retrievedString!)")
        
        let decoder = JSONDecoder()
        
        request.responseDecodable(of: GraphResponseMe.self, decoder: decoder) { (response) in
            print(response)
            switch response.result {
            case .success(let value):
                print("id")
                UserDefaults.standard.setValue(value.id, forKeyPath: "id")
                print(value.id ?? "")
                print("name")
                print(value.name ?? "")
                UserDefaults.standard.setValue(value.name, forKeyPath: "name")
            case .failure( _):
                print("failure")
            }
        }
    }
}
