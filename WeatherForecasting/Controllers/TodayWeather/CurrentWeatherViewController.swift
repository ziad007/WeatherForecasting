
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
    @IBOutlet weak var headerSeperator: UIView!

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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UIGraphicsBeginImageContext(view.frame.size)
        UIImage(named: "2px Line")?.draw(in: self.view.bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        headerSeperator.backgroundColor = UIColor.init(patternImage: image!)
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

    func showErrorAlertToEnableLocation(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

        let enableLocationAction = UIAlertAction(title: "Setting", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                })
            }
        }

        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertController.addAction(dismissAction)
        alertController.addAction(enableLocationAction)

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

    @IBAction func didPressedShare(_ sender: UIButton) {
        guard let weatherData = currentWeathInteractor.weatherResponse else { return }
        guard let weather = weatherData.weather else { return }

        guard let main = weatherData.main else { return }

        let textToShare = String(format: "Weather in %@ %@ is %@ | %@°C ", weatherData.name ?? "" , weatherData.sys?.countryFullName ?? "", weather.description ?? "", main.temperatureCelcius)

        let activities = [textToShare]

        let activityViewController = UIActivityViewController(activityItems: activities, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        self.present(activityViewController, animated: true, completion: nil)
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
        locationLabel.text =  "\(weatherData.name ?? ""), \(weatherData.sys?.countryFullName ?? "")"
        temperatureLabel.text = "\(main.temperatureCelcius)°C | \(weather.main ?? "")"

        if let pressure = main.pressure {
            pressureLabel.text = "\(pressure) hPa"
        }

        if let humidity = main.humidity {
            hummidityLabel.text = "\(humidity)%"
        }

        if let windSpeed = weatherData.wind?.speed {
            windLabel.text = "\(windSpeed) km/h"
        }

        if let windDeg = weatherData.wind?.deg {
            windDegreeLabel.text = "\(windDeg)"
        }
    }
}
