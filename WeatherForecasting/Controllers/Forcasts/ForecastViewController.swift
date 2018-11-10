
import UIKit
import CoreLocation

final class ForecastViewController: UIViewController {

    static let height: CGFloat = 80
    static let HeaderHeight: CGFloat = 50

    static let cellIdentifier = "ForecastTableViewCell"
    @IBOutlet weak var headerSeperator: UIView!
    @IBOutlet weak var tableView: UITableView!

    fileprivate let forecastInteractor: ForecastInteractor

    init() {
        forecastInteractor = ForecastInteractor()

        super.init(nibName: nil, bundle: nil)

        forecastInteractor.controller = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastViewController.cellIdentifier)

        tableView.register(CustomHeaderTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: CustomHeaderTableViewHeaderFooterView.reuseIdentifer)

        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self

        setupNotifications()
        setupNavigationItem()
        setupLoadCompletion()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UIGraphicsBeginImageContext(view.frame.size)
        UIImage(named: "2px Line")?.draw(in: self.view.bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        headerSeperator.backgroundColor = UIColor.init(patternImage: image!)
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
        navigationItem.title = forecastInteractor.cityName
    }

    fileprivate func fetchData() {
        forecastInteractor.fetchForecasting()
    }

    private func setupLoadCompletion() {
        forecastInteractor.requestloadForecastCompleteHandler = { [weak self] () in
            guard let localSelf = self else { return }
            localSelf.setupNavigationItem()
            localSelf.tableView.reloadData()
        }
    }
}

extension ForecastViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return forecastInteractor.numberOfDaysForecasting
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomHeaderTableViewHeaderFooterView.reuseIdentifer) as? CustomHeaderTableViewHeaderFooterView else {
            return nil
        }

        guard let weatherData = forecastInteractor.forecastingWeatherByDay[section]?.first else { return nil }

        header.titleLabel.text = weatherData.isToday ? "TODAY" : weatherData.dayInWeek.uppercased()
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ForecastViewController.HeaderHeight
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ForecastViewController.height
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastInteractor.forecastingWeatherByDay[section]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastViewController.cellIdentifier) as! ForecastTableViewCell
        cell.accessoryType = .none

        let weatherData = forecastInteractor.forecastingWeatherByDay[indexPath.section]?[indexPath.row]
        let arrayCount = forecastInteractor.forecastingWeatherByDay[indexPath.section]?.count ?? 0
        cell.configure(weatherData: weatherData, needToDrawSeperator: indexPath.row < arrayCount - 1)
        return cell
    }
}

extension ForecastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
