//
//  ContentView.swift
//  weather2
//
//  Created by steve on 11/2/20.
//

import SwiftUI
import OAuthSwift

extension UserDefaults {
    @objc var id: Int {
        get {
            return integer(forKey: "id")
        }
        set {
            set(newValue, forKey: "id")
        }
    }
}

extension UserDefaults {
    @objc var zip: Int {
        get {
            return integer(forKey: "zip")
        }
        set {
            set(newValue, forKey: "zip")
        }
    }
}

extension UserDefaults {
    @objc var name: String {
        get {
            return string(forKey: "name") ?? ""
        }
        set {
            set(newValue, forKey: "name")
        }
    }
}

struct GoodContentView: View {
    @State private var isNight = false
    @ObservedObject var weatherViewModel = WeatherViewModel()
    var cityName : String
    @State var isPresentingModal: Bool = false
    @State var isPresentingSafariModal: Bool = false
    
    var body: some View {
        ZStack {
            NavigationView{
                ZStack {
                    BackgroundView()
                    VStack {
                        if weatherViewModel.id == 0 {
                            loginButton
                        }
                        else {
                            logoutButton
                        }
                        
                        Text(weatherViewModel.name)
                            .fontWeight(.semibold)
                            .font(.system(.title, design: .rounded))
                            .foregroundColor(.primary)
                        
                        CityTextView(cityName: weatherViewModel.response?.name ?? "")
                        
                        let cw = weatherViewModel.response
                        
                        MainWeatherStatusView(imageName: cw?.weather?.first?.weatherStateImageName ?? "", temperature: Int(cw?.main?.temp ?? 0) )
                        
                        //                    HStack {
                        //                        ForEach(fetcher.consolidatedWeathers) { consolidatedWeather in
                        //                            WeatherDayView(dayOfWeek: consolidatedWeather.dayName, imageName: consolidatedWeather.weatherStateImageName, temperature: Int(consolidatedWeather.maxTempFahrenheit))
                        //                        }
                        //                        .padding(3)
                        //                    }
                        
                        Spacer()
                    }
                }
                .navigationBarItems(trailing: addButton)
                .alert(isPresented: $weatherViewModel.showingAlert) {
                    Alert(title: Text("Zip Code Not Found"), message: Text("Please enter a 5 digit zip code."), dismissButton: .default(Text("OK")))
                }
            }
            
            if (weatherViewModel.isLoading) {
                LoadingView()
            }
        }
    }
    
    func loginWithFacebook() {
        let oauthswift = OAuth2Swift(
          consumerKey: "732008171068255",
          consumerSecret: "7d090ca45feef4e4820822f268efc0ce",
          authorizeUrl: "https://www.facebook.com/v9.0/dialog/oauth",
          accessTokenUrl: "https://www.facebook.com/v9.0/dialog/oauth/access_token",
          responseType: "token"
        )

        let vc = UIHostingController(rootView: self)
        oauthswift.allowMissingStateCheck = true
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: vc, oauthSwift: oauthswift)
        
        guard let rwURL = URL(string: "fb732008171068255://authorize") else { return }
        oauthswift.authorize(withCallbackURL: rwURL, scope: "email", state: "state123abc", completionHandler: { response in

        })
    }
    
    private var logoutButton: some View {
        Button(action: {
            weatherViewModel.logout()
        }) {
            Text("Logout")
                .fontWeight(.bold)
                .font(.system(.largeTitle, design: .rounded))
                .foregroundColor(.primary)
        }
    }
    
    private var loginButton: some View {
        Button(action: {
            self.isPresentingSafariModal = true
        }) {
            Text("Login with Facebook")
                .fontWeight(.bold)
                .font(.system(.largeTitle, design: .rounded))
                .foregroundColor(.primary)
        }.sheet(isPresented: $isPresentingSafariModal) {
            ViewView()
        }
    }
    
    private var addButton: some View {
        Button(action: {
            self.isPresentingModal = true
        }) {
            Image(systemName: "magnifyingglass.circle.fill") // magnifyingglass.circle.fill
                .font(.title)
        }.sheet(isPresented: $isPresentingModal) {
            SearchView()
        }
    }
}

struct GoodContentView_Previews: PreviewProvider {
    static var previews: some View {
        GoodContentView(cityName: "Cupertino")
    }
}

struct WeatherDayView: View {
    
    var dayOfWeek: String
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack {
            Text(dayOfWeek)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            Text("\(temperature)°")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

struct BackgroundView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [colorScheme == .dark ? .black : .blue, colorScheme == .dark ? .gray: Color("lightBlue")]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
}

struct CityTextView: View {
    var cityName: String
    
    var body: some View {
        Text(cityName)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding()
    }
}

struct MainWeatherStatusView: View {
    
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            
            Text("\(temperature)°")
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.bottom, 40)
    }
}

struct WeatherButton: View {
    var title: String
    var textColor: Color
    var backgroundColor: Color
    
    var body: some View {
        Text(title)
            .frame(width: 280, height: 50)
            .background(backgroundColor)
            .foregroundColor(.blue)
            .font(.system(size: 20, weight: .bold, design: .default))
            .cornerRadius(10)
    }
}
