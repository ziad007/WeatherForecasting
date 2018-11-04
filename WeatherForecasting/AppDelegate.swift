//
//  AppDelegate.swift
//  WeatherForecasting
//
//  Created by ziad Bou Ismail on 11/2/18.
//  Copyright © 2018 Ziad. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()
    fileprivate var fetchWeatherIfNeeded: Bool = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        setupTabviewController()
        setupLocationManager()

        UINavigationBar.appearance().backgroundColor = .white

        Timer.scheduledTimer(withTimeInterval: 20, repeats: true) { _ in
            self.fetchWeatherIfNeeded = true
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    private func setupLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

    }

    private func setupTabviewController() {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.barTintColor = UIColor.white
        //  tabBarController?.tabBar.unselectedItemTintColor = UIColor.secondaryTextColor

        let currentWeatherViewVC = CurrentWeatherViewController()
        let currentWeatheNavigationController = UINavigationController(rootViewController: currentWeatherViewVC)
        currentWeatheNavigationController.tabBarItem = UITabBarItem(title: "Today", image: UIImage(named: "25x25 Today Active (Tab)"), tag: 0)

        let forecastViewVC = ForecastViewController()
        let forecastNavigationController = UINavigationController(rootViewController: forecastViewVC)
        forecastNavigationController.tabBarItem = UITabBarItem(title: "Forecast", image: UIImage(named: "25x25 Forecast Active (Tab)"), tag: 0)

        let controllers = [currentWeatheNavigationController, forecastNavigationController]

        tabBarController.viewControllers = controllers

        window?.rootViewController = tabBarController

        window?.makeKeyAndVisible()

    }
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {
            LocationStore.shared.saveLocation(for: location)

            if fetchWeatherIfNeeded {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didReceiveLocation"), object: location)
                fetchWeatherIfNeeded = false
            }
        }
    }
}

