//
//  ContentView.swift
//  weather2
//
//  Created by steve on 11/2/20.
//

import SwiftUI

extension UserDefaults {
    @objc var cityName: String {
        get {
            return string(forKey: "cityName") ?? ""
        }
        set {
            set(newValue, forKey: "cityName")
        }
    }
    
    @objc var woeid: Int {
        get {
            return integer(forKey: "woeid")
        }
        set {
            set(newValue, forKey: "woeid")
        }
    }
}

struct GoodContentView: View {
    @State private var isNight = false
    @ObservedObject var fetcher = WeatherFetcher()
    var cityName : String
    
    var body: some View {
        ZStack {
            BackgroundView(isNight: $isNight)
            VStack {
                CityTextView(cityName: cityName)
                
                let cw = fetcher.consolidatedWeathers.first
                
                MainWeatherStatusView(imageName: cw?.weatherStateImageName ?? "", temperature: Int(cw?.maxTempFahrenheit ?? 0 ))
                
                HStack {
                    ForEach(fetcher.consolidatedWeathers) { consolidatedWeather in
                        WeatherDayView(dayOfWeek: consolidatedWeather.dayName, imageName: consolidatedWeather.weatherStateImageName, temperature: Int(consolidatedWeather.maxTempFahrenheit))
                    }
                    .padding(3)
                }
                
                Spacer()
                
                Button {
                    isNight = !isNight
                } label: {
                    WeatherButton(title: "Change Day Time", textColor: .blue, backgroundColor: .white)
                }
                
                Spacer()
            }
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
    
    @Binding var isNight: Bool
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [isNight ? .black : .blue, isNight ? .gray: Color("lightBlue")]),
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
