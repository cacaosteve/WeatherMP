import SwiftUI

// MARK: - Response
struct Response: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double?
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int?
    let message: Double?
    let country: String?
    let sunrise, sunset: Int?
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main, weatherDescription, icon: String?
    
    var weatherStateImageName: String {
        get {
            switch icon {
            case "01d":
                return "sun.max.fill"
            case "01n":
                return "sun.max.fill"
            case "02d":
                return "cloud.sun.fill"
            case "02n":
                return "cloud.sun.fill"
            case "03d":
                return "cloud.fill"
            case "03n":
                return "cloud.fill"
            case "04d":
                return "cloud.fog.fill"
            case "04n":
                return "cloud.fog.fill"
            case "09d":
                return "cloud.heavyrain.fill"
            case "09n":
                return "cloud.heavyrain.fill"
            case "10d":
                return "cloud.sun.rain.fill"
            case "10n":
                return "cloud.sun.rain.fill"
            case "11d":
                return "cloud.bolt"
            case "11n":
                return "cloud.bolt"
            case "13d":
                return "cloud.snow"
            case "13n":
                return "cloud.snow"
            case "50d":
                return "cloud.sun.rain.fill"
            case "50n":
                return "cloud.sun.rain.fill"
            default:
                return ""
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}
