import UIKit

class WeeklyForecastViewController: UIViewController {

    private lazy var cityLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: 0,
                                          y: 20,
                                          width: self.view.frame.width,
                                          height: 24))
        
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
//        label.text = "Moscow, Russia"
        label.textColor = .white
        return label
    }()
    
    private lazy var weeklyForecastLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: 30,
                                          y: self.view.frame.height / 8,
                                          width: self.view.frame.width / 2,
                                          height: 29))
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 21)
        label.text = "Next 5 Days"
        label.textColor = .white
        return label
    }()
    
    private lazy var weeklyForecastTableView: UITableView = {
        var tableView = UITableView(frame: CGRect(x: 0,
                                                  y: self.weeklyForecastLabel.frame.maxY + 20,
                                                  width: self.view.frame.width,
                                                  height: self.view.frame.height / 3 * 2))
        tableView.register(WeeklyForecastTableViewCell.self, forCellReuseIdentifier: "weeklyForecastCell")
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    public var weatherForecast: WeatherForecast? = nil
    var groupedForecast: [GroupedForecast] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.cityLabel)
        self.view.addSubview(self.weeklyForecastLabel)
        
        self.weeklyForecastTableView.delegate = self
        self.weeklyForecastTableView.dataSource = self
        
        self.view.addSubview(self.weeklyForecastTableView)
        
        guard let city = self.weatherForecast?.city.name else { return }
        self.cityLabel.text = city
        
        self.groupedForecast = getSortedData(from: weatherForecast)
        print(self.groupedForecast)
    }
    
    func getTemperature(tempKelvin: [Double], needMaxTemp: Bool) -> Int{
        if needMaxTemp {
            let maxDouble = tempKelvin.max()
            guard let maxDouble = maxDouble else { return 0 }
            return Int(maxDouble - 273.15)
        }
        else {
            let minDouble = tempKelvin.min()
            guard let minDouble = minDouble else { return 0 }
            return Int(minDouble - 273.15)
        }
    }
    
    func getSortedData(from weatherForecast: WeatherForecast?) -> [GroupedForecast] {
        print(weatherForecast)
        var groupedForecast: [GroupedForecast] = []
        var minTemperatures: [Double] = []
        var maxTemperatures: [Double] = []
        guard let data = weatherForecast else { return [] }
        var checkingDateString = convertDate(dateString: data.list[0].date)
        for i in data.list {
            let iDate = convertDate(dateString: i.date)
            if iDate == checkingDateString {
                minTemperatures.append(i.temperatute.minTemperature)
                maxTemperatures.append(i.temperatute.maxTemperature)
            }
            else {
                groupedForecast.append(GroupedForecast(date: iDate,
                                                       minTemperature: minTemperatures,
                                                       maxTemperature: maxTemperatures))
                checkingDateString = iDate
                minTemperatures = []
                maxTemperatures = []
            }
        }
        return groupedForecast
    }
    
    func convertDate(dateString: String?) -> String {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let dateString = dateString else { return "" }

        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "EEEE, dd MMM"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = date else { return "" }
        
        return dateFormatter.string(from: date)
    }

    
}

extension WeeklyForecastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension WeeklyForecastViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupedForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.weeklyForecastTableView.dequeueReusableCell(withIdentifier: "weeklyForecastCell") as? WeeklyForecastTableViewCell else { return WeeklyForecastTableViewCell() }
        
        cell.backgroundColor = UIColor(red: 68 / 255,
                                       green: 124 / 255,
                                       blue: 254 / 255,
                                       alpha: 1)
//        cell.setImage(image: UIImage(named: "sun"))
//        cell.setLabels(dayOfWeek: "Monday, 22 Aug", temperature: "30℃ / 18℃")
        let date = self.groupedForecast[indexPath.row].date
        let maxTemterature = getTemperature(tempKelvin: self.groupedForecast[indexPath.row].maxTemperature,
                                            needMaxTemp: true)
        let minTemterature = getTemperature(tempKelvin: self.groupedForecast[indexPath.row].minTemperature,
                                            needMaxTemp: false)
        cell.setLabels(dayOfWeek: date,
                       temperature: "\(maxTemterature)℃ / \(minTemterature)℃")
        if let img = UIImage(named: "sun") {
            cell.setImage(image: img)
        }
        return cell
    }
    
    
}

struct GroupedForecast {
    var date: String
    var minTemperature: [Double]
    var maxTemperature: [Double]
}
