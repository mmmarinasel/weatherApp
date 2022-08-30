import UIKit

class ViewController: UIViewController {

    private var sideMenuViewController: SideMenuViewController!
    private var sideMenuRevealWidth: CGFloat = 260
    private let paddingForRotation: CGFloat = 150
    private var isExpanded: Bool = false
    
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    
    private var revealSideMenuOnTop: Bool = true
    
    private lazy var containerView: UIView = {
        var view = UIView(frame: CGRect(x: self.view.frame.width / 16,
                                        y: self.view.frame.height / 4,
                                        width: self.view.frame.width / 8 * 7,
                                        height: self.view.frame.height / 2))
        
        view.backgroundColor = UIColor(red: 67 / 255,
                                       green: 122 / 255,
                                       blue: 254 / 255,
                                       alpha: 1)
        
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var locationLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: self.view.frame.width / 16,
                                          y: self.view.frame.height / 8 + 35 / 2,
                                          width: self.view.frame.width / 4 * 3,
                                          height: 35))
        
        label.font = UIFont.boldSystemFont(ofSize: 26)
        return label
    }()
    
    private lazy var weatherImageView: UIImageView = {
        var imageView = UIImageView(frame: CGRect(x: self.containerView.frame.width / 2 - 30,
                                                 y: 25,
                                                 width: 60,
                                                 height: 60))
        return imageView
    }()
    
    private lazy var weatherStatusLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: 0,
                                          y: self.weatherImageView.frame.maxY + 10,
                                          width: self.containerView.frame.width,
                                          height: 30))
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
       var label = UILabel(frame: CGRect(x: 0,
                                         y: self.weatherStatusLabel.frame.maxY + 10,
                                         width: self.containerView.frame.width,
                                         height: 20))
        label.textAlignment = .center
        label.font = UIFont(name: "System", size: 12)
        label.text = "Sunday, 02 Oct"
        label.textColor = .systemGray6
        
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
       var label = UILabel(frame: CGRect(x: 0,
                                         y: self.dateLabel.frame.maxY + 10,
                                         width: self.containerView.frame.width,
                                         height: 80))
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 70)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var dayStatusLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: self.view.frame.width / 16,
                                          y: self.containerView.frame.maxY + 20,
                                          width: self.view.frame.width / 3,
                                          height: 20))
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Today"
        label.textColor = .black
        
        return label
    }()
    
    private lazy var weeklyForecastButton: UIButton = {
        var button = UIButton(frame: CGRect(x: self.view.frame.width / 3 * 2 - self.view.frame.width / 16,
                                           y: self.containerView.frame.maxY + 20,
                                           width: self.view.frame.width / 3,
                                           height: 20))
        button.setTitle("Next 5 Days ❭", for: .normal)
        button.setTitleColor(.systemGray2, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView(frame: CGRect(x: self.view.frame.width / 16,
                                                    y: self.dayStatusLabel.frame.maxY + 15,
                                                    width: self.containerView.frame.width,
                                                    height: self.containerView.frame.height / 4))
        scrollView.backgroundColor = .green
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {

        var stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        
        stackView.backgroundColor = .blue
        return stackView
    }()
    
    public var weatherForecast: WeatherForecast? = nil
    private let loader = NetworkManager()
    private let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=55.75&lon=37.62&appid=ab80f12407806862f98407834baa0193"
    
    @IBAction func openSideMenuButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.sideMenuViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuID") as? SideMenuViewController
        self.sideMenuViewController.delegate = self
//        vc.modalPresentationStyle = .fullScreen
//        show(vc, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.containerView)
        self.view.addSubview(self.locationLabel)
        
        self.containerView.addSubview(self.weatherImageView)
        self.containerView.addSubview(self.weatherStatusLabel)
        self.containerView.addSubview(self.dateLabel)
        self.containerView.addSubview(self.temperatureLabel)
        
        self.view.addSubview(self.dayStatusLabel)
        self.view.addSubview(self.weeklyForecastButton)
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.stackView)
        
        let constraints: [NSLayoutConstraint] = [
            stackView.topAnchor.constraint(equalTo: self.stackView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.stackView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: self.stackView.heightAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        DispatchQueue.global().async {
            self.loader.downloadWeatherForecast(urlString: self.urlString) { [weak self] data in
                self?.weatherForecast = data
                DispatchQueue.main.async {
                    self?.locationLabel.text = self?.weatherForecast?.city.name
                    self?.temperatureLabel.text = self?.setTemperature(temperatureKelvin: self?.weatherForecast?.list[0].temperatute.currentTemperature)
                    
                    self?.weatherStatusLabel.text = self?.weatherForecast?.list[0].weather[0].main
                    let date = self?.setDate(dateString: self?.weatherForecast?.list[0].date)
                    if let date = date {
                        self?.dateLabel.text = date
                    }
                    self?.weatherImageView.image = self?.setImage(status: self?.weatherForecast?.list[0].weather[0].main)
                }
            }
        }
    }

    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        
        let storyboard = UIStoryboard(name: "WeeklyForecast", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "weeklyForecast") as? WeeklyForecastViewController ?? WeeklyForecastViewController()
        vc.weatherForecast = self.weatherForecast
        self.present(vc, animated: true, completion: nil)
    }
    
    func setTemperature(temperatureKelvin: Double?) -> String {
        guard let temperatureKelvin = temperatureKelvin else { return "" }
        let tempCels: Int = Int(temperatureKelvin - 273.15)
        return "\(tempCels)°"
    }
    
    func setDate(dateString: String?) -> String {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let dateString = dateString else { return "" }

        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "EEEE, dd MMM"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = date else { return "" }
        
        return dateFormatter.string(from: date)
    }
    
    func setImage(status: String?) -> UIImage {
        var image = UIImage()
        switch status {
        case "Clouds":
            image = UIImage(named: "cloudy") ?? UIImage()
        case "Clear":
            image = UIImage(named: "clear") ?? UIImage()
        case "Sun":
            image = UIImage(named: "sun") ?? UIImage()
        case "Rain":
            image = UIImage(named: "rain") ?? UIImage()
        case "Snow":
            image = UIImage(named: "snow") ?? UIImage()
        case "Thunderstorm":
            image = UIImage(named: "thunderstorm") ?? UIImage()
        default:
            image = UIImage(named: "moonlight") ?? UIImage()
        }
        return image
    }

}

extension ViewController: SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int) {
        
    }
    
    
}
