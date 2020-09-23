import SwiftUI

class Weather: Codable, Identifiable {
    let consolidatedWeather: [ConsolidatedWeather]
    let time, sunRise, sunSet, timezoneName: String
    let parent: Parent
    let sources: [Source]
    let title, locationType: String
    let woeid: Int
    let lattLong, timezone: String

    enum CodingKeys: String, CodingKey {
        case consolidatedWeather = "consolidated_weather"
        case time
        case sunRise = "sun_rise"
        case sunSet = "sun_set"
        case timezoneName = "timezone_name"
        case parent, sources, title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
        case timezone
    }
}

struct ConsolidatedWeather : Codable, Identifiable {
    var id:Int
    var weatherStateName:String
    var weatherStateAbbr:String
    var windDirectionCompass:String
//    var created:Date
    var applicableDate:String
    var minTemp:Double
    var maxTemp:Double
    var theTemp:Double
//    var windSpeed:Double
//    var windDirection:Double
//    var humidity:Int
//    var visibility:Double
//    var predictability:Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case weatherStateName = "weather_state_name"
        case weatherStateAbbr = "weather_state_abbr"
        case windDirectionCompass = "wind_direction_compass"
//        case created = "created"
        case applicableDate = "applicable_date"
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
        case theTemp = "the_temp"
//        case windSpeed = "wind_speed"
//        case windDirection = "wind_direction"
//        case humidity = "humidity"
//        case visibility = "visibility"
//        case predictability = "predictability"
    }
}

//extension ConsolidatedWeather: Identifiable {
//    var id: UUID { return uuid }
//}

class Parent: Codable {
    let title, locationType: String
    let woeid: Int
    let lattLong: String

    enum CodingKeys: String, CodingKey {
        case title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
    }
}

class Source: Codable {
    let title, slug: String
    let url: String
    let crawlRate: Int

    enum CodingKeys: String, CodingKey {
        case title, slug, url
        case crawlRate = "crawl_rate"
    }
}
