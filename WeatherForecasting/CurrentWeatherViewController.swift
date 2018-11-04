
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

        setupNavigationItem()
        setupLoadCompletion()

        askForLocation()
    }

    private func askForLocation() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }

    private func setupNavigationItem() {
        navigationItem.title = "Today"
    }

    fileprivate func fetchData(lat: Double, long: Double) {
        currentWeathInteractor.fetchCurrentWeather(for: long, lat: lat)
    }

    private func setupLoadCompletion() {
        currentWeathInteractor.requestloadCurrentWeatherCompleteHandler = { [weak self] () in
            guard let localSelf = self else { return }
            localSelf.bindControls()
        }
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

extension CurrentWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        do {
           let location =  CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            let locData = try NSKeyedArchiver.archivedData(withRootObject: location, requiringSecureCoding: false)
            UserDefaults.standard.set(locData, forKey: "LOCATION")
            UserDefaults.standard.synchronize()
        } catch { }

        fetchData(lat: locValue.latitude, long: locValue.longitude)
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}

