//
//  WeatherMPApp.swift
//  Shared
//
//  Created by steve on 9/23/20.
//

import SwiftUI
import OAuthSwift

@main
struct WeatherMPApp: App {
    var body: some Scene {
        WindowGroup {
            GoodContentView(cityName: "Cupertino")
                .onOpenURL { url in
                    OAuthSwift.handle(url: url)
                }
        }
    }
}

struct WeatherMPApp_Previews: PreviewProvider {
    static var previews: some View {
        GoodContentView(cityName: "Cupertino")
    }
}
