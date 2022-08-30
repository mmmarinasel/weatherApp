import UIKit

class WeeklyForecastTableViewCell: UITableViewCell {
    
    private lazy var weatherImageView: UIImageView = {
        var imageView = UIImageView(frame: CGRect(x: 10,
                                                  y: self.contentView.frame.midY,
                                                  width: 30,
                                                  height: 30))
//        imageView.image = UIImage(named: "sun")
        return imageView
    }()

    private lazy var dayOfWeekLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: self.weatherImageView.frame.maxX + 20,
                                          y: self.contentView.frame.midY,
                                          width: self.contentView.frame.width / 2,
                                          height: 25))
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .white
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: self.contentView.frame.maxX - 50,
                                          y: self.contentView.frame.midY,
                                          width: self.contentView.frame.width / 2,
                                          height: 25))
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setImage(image: UIImage) {
        self.contentView.addSubview(self.weatherImageView)
        self.weatherImageView.image = image
    }
    
    func setLabels(dayOfWeek: String, temperature: String) {
        self.contentView.addSubview(self.dayOfWeekLabel)
        self.contentView.addSubview(self.temperatureLabel)
        self.dayOfWeekLabel.text = dayOfWeek
        self.temperatureLabel.text = temperature
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
