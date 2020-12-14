import Foundation

struct WeatherModel: Identifiable {
    let id = UUID()
    let dayOfWeek: String
    let imageName: String
    let temperature: Int
}

struct MockData {
    
    static let sampleDay = WeatherModel(dayOfWeek: "SUN", imageName: "sun.max.fill", temperature: 75)
    
    static let days = [
        WeatherModel(dayOfWeek: "MON", imageName: "sun.max.fill", temperature: 70),
        WeatherModel(dayOfWeek: "TUE", imageName: "sun.max.fill", temperature: 72),
        WeatherModel(dayOfWeek: "WED", imageName: "sun.max.fill", temperature: 73),
        WeatherModel(dayOfWeek: "THU", imageName: "sun.max.fill", temperature: 71),
        WeatherModel(dayOfWeek: "FRI", imageName: "sun.max.fill", temperature: 74),
    ]
}
