import Foundation
import UIKit

final class ForecastTableViewCell: UITableViewCell {

    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.alignment = .center
        return stackView
    }()

    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .fill
        return stackView
    }()

    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let hourLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ProximaNova-SemiBold", size: 14)
        label.textColor = .darkColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ProximaNova-Regular", size: 14)
        label.textColor = .darkColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ProximaNova-SemiBold", size: 50)
        label.textColor = .dodgerBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 999, height: 999))

        labelStackView.addArrangedSubview(hourLabel)
        labelStackView.addArrangedSubview(weatherDescriptionLabel)

        rootStackView.addArrangedSubview(weatherIconImageView)
        rootStackView.addArrangedSubview(labelStackView)

        contentView.addSubview(rootStackView)
        contentView.addSubview(temperatureLabel)
        layoutComponents()
    }

    private func layoutComponents() {
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            temperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            temperatureLabel.leadingAnchor.constraint(greaterThanOrEqualTo: rootStackView.trailingAnchor, constant: 16),
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            ])
    }

    func configure(weatherData: WeatherData?) {
        guard let weatherData = weatherData  else {
            return
        }

        guard let weather = weatherData.weather  else {
            return
        }

        hourLabel.text = "\(weatherData.time)"
        weatherDescriptionLabel.text = weatherData.weather?.description
        temperatureLabel.text = "\(weatherData.main?.temperatureCelcius ?? "-")"
        weatherIconImageView.image = UIImage(named: weather.icon?.smallIconName ?? "")
    }
}
