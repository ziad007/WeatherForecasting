import Foundation
import UIKit

final class ForecastTableViewCell: UITableViewCell {
    fileprivate var needToDrawSeperator = true
    static let seperatorViewHeight: CGFloat = 0.2


    fileprivate lazy var seperatorHeightConstraint = {
       return seperatorView.heightAnchor.constraint(equalToConstant: ForecastTableViewCell.seperatorViewHeight)
    }()

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
        label.font = UIFont(name: "ProximaNova-SemiBold", size: 15)
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
        label.font = UIFont(name: "ProximaNova-Regular", size: 50)
        label.textColor = .dodgerBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if needToDrawSeperator {
            seperatorHeightConstraint.constant = ForecastTableViewCell.seperatorViewHeight
        } else {
            seperatorHeightConstraint.constant = 0
        }
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
        contentView.addSubview(seperatorView)

        layoutComponents()
    }

    private func layoutComponents() {
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),

            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            temperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            temperatureLabel.bottomAnchor.constraint(equalTo: rootStackView.bottomAnchor),
            temperatureLabel.leadingAnchor.constraint(greaterThanOrEqualTo: rootStackView.trailingAnchor, constant: 16),
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            seperatorView.topAnchor.constraint(equalTo: rootStackView.bottomAnchor, constant: 5),
            seperatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            seperatorView.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor),

            seperatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            seperatorHeightConstraint
            ])
    }

    func configure(weatherData: WeatherData?, needToDrawSeperator: Bool) {
        guard let weatherData = weatherData  else {
            return
        }

        guard let weather = weatherData.weather  else {
            return
        }

        self.needToDrawSeperator = needToDrawSeperator

        hourLabel.text = "\(weatherData.time)"
        weatherDescriptionLabel.text = weatherData.weather?.description
        temperatureLabel.text = "\(weatherData.main?.temperatureCelcius ?? "")°"
        weatherIconImageView.image = UIImage(named: weather.icon?.smallIconName ?? "")

        self.layoutIfNeeded()
    }
}
