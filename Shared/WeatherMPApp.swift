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
            GoodContentView(cityName: "Cupertino")
        }
    }
}

struct WeatherMPApp_Previews: PreviewProvider {
    static var previews: some View {
        GoodContentView(cityName: "Cupertino")
    }
}
