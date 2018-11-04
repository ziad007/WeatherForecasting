
import UIKit
import CoreLocation

final class CurrentWeatherViewController: UIViewController {
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!

    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var hummidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var windDegreeLabel: UILabel!

    @IBOutlet weak var precipitationLabel: UILabel!
    let locationManager = CLLocationManager()
    fileprivate var fetchWeatherIfNeeded = true
    let refreshWeatherDuration: TimeInterval = 20

    fileprivate let currentWeathInteractor: CurrentWeathInteractor

    init() {
        currentWeathInteractor = CurrentWeathInteractor()

        super.init(nibName: nil, bundle: nil)

        currentWeathInteractor.controller = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNotifications()
        setupNavigationItem()
        setupLoadCompletion()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveLocation(_:)), name:
            NSNotification.Name(rawValue: "didReceiveLocation"), object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }

    @objc func applicationDidBecomeActive() {
        fetchData()
    }

    @objc func didReceiveLocation(_ notification: Notification) {
        fetchData()
    }

    private func setupNavigationItem() {
        navigationItem.title = "Today"
    }

    private func setupLoadCompletion() {
        currentWeathInteractor.requestloadCurrentWeatherCompleteHandler = { [weak self] () in
            guard let localSelf = self else { return }
            localSelf.bindControls()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func fetchData() {
        currentWeathInteractor.fetchCurrentWeather()
    }

    private func bindControls() {
        guard let weatherData = currentWeathInteractor.weatherResponse else { return }
        guard let weather = weatherData.weather else { return }
        guard let main = weatherData.main else { return }

        let iconName = weather.icon?.largeIconName ?? ""
        weatherIconImageView.image =  UIImage(named: iconName)
        locationLabel.text =  "\(weatherData.name ?? "") \(weatherData.sys?.countryFullName ?? "")"
        temperatureLabel.text = "\(main.temperatureCelcius) | \(weather.description ?? "")"

        if let pressure = main.pressure {
            pressureLabel.text = "\(pressure)"
        }

        if let humidity = main.humidity {
            hummidityLabel.text = "\(humidity)"
        }

        if let windSpeed = weatherData.wind?.speed {
            windLabel.text = "\(windSpeed)"
        }

        if let windDeg = weatherData.wind?.deg {
            windDegreeLabel.text = "\(windDeg)"
        }
    }
}
