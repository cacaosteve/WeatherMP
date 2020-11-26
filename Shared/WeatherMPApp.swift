//
//  WeatherMPApp.swift
//  Shared
//
//  Created by steve on 9/23/20.
//

import SwiftUI

@main
struct WeatherMPApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                GoodContentView(cityName: "Cupertino")
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Cupertino")
                    }
                GoodContentView(cityName: "San Diego")
                    .tabItem {
                        Image(systemName: "gift.fill")
                        Text("San Diego")
                    }
            }
        }
    }
}

struct WeatherMPApp_Previews: PreviewProvider {
    static var previews: some View {
        GoodContentView(cityName: "Cupertino")
    }
}
