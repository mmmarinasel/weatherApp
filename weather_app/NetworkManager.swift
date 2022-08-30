import Foundation

protocol ILoader {
    func downloadWeatherForecast(urlString: String, completion: @escaping (WeatherForecast) -> ())
    func getData(urlString: String, completion: @escaping (Data?, URLResponse?, Error?) -> ())
}

class NetworkManager: ILoader {
    
    private let urlString: String = "https://api.openweathermap.org/data/2.5/forecast?lat=55.75&lon=37.62&appid=ab80f12407806862f98407834baa0193"
    
    func downloadWeatherForecast(urlString: String, completion: @escaping (WeatherForecast) -> ()) {
        print("началась загрузка")
        getData(urlString: urlString) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            
            do {
                let weatherForecast = try JSONDecoder().decode(WeatherForecast.self, from: data)
                completion(weatherForecast)
            } catch {
                print(error.localizedDescription)
                print(error)
            }
        }
    }
    
    func getData(urlString: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

}
