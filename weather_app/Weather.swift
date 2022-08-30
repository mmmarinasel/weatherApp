import Foundation

struct WeatherForecast: Codable {
    let city: City
    let list: [List]
}

struct City: Codable {
    let id: Int
    let name: String
    let coordinations: Coordinations
    let country: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case coordinations = "coord"
        case country
    }
}

struct Coordinations: Codable {
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}

struct List: Codable {
    let temperatute: Temperature
    let weather: [Weather]
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case temperatute = "main"
        case weather
        case date = "dt_txt" 
    }
}

struct Temperature: Codable {
    let currentTemperature: Double
    let feelsLikeTemperature: Double
    let minTemperature: Double
    let maxTemperature: Double
    
    enum CodingKeys: String, CodingKey {
        case currentTemperature = "temp"
        case feelsLikeTemperature = "feels_like"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
    }
}

struct Weather: Codable {
    let main: String
    let description: String
}

//enum MainEnum: String, Codable {
//    case clear = "Clear"
//    case clouds = "Clouds"
//}
//
//enum Description: String, Codable {
//    case brokenClouds = "broken clouds"
//    case clearSky = "clear sky"
//    case fewClouds = "few clouds"
//    case overcastClouds = "overcast clouds"
//    case scatteredClouds = "scattered clouds"
//}
