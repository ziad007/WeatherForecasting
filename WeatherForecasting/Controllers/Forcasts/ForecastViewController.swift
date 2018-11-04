
import UIKit
import CoreLocation

final class ForecastViewController: UIViewController {

    static let height: CGFloat = 80
    static let cellIdentifier = "ForecastTableViewCell"

    fileprivate let forecastInteractor: ForecastInteractor

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        return tableView
    }()

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

        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self

        setupNotifications()
        setupNavigationItem()
        addComponents()
        layoutComponents()
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
        navigationItem.title = "GitHub DM"
    }

    private func addComponents() {
        view.addSubview(tableView)
    }

    private func layoutComponents() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
    }

    fileprivate func fetchData() {
        forecastInteractor.fetchForecasting()
    }

    private func setupLoadCompletion() {
        forecastInteractor.requestloadForecastCompleteHandler = { [weak self] () in
            guard let localSelf = self else { return }
            localSelf.tableView.reloadData()
        }
    }
}

extension ForecastViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return forecastInteractor.numberOfDaysForecasting
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let weatherData = forecastInteractor.forecastingWeatherByDay[section]?.first else { return "" }
        return weatherData.isToday ? "Today" : weatherData.dayInWeek
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
        cell.configure(weatherData: weatherData)
        return cell
    }
}

extension ForecastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
