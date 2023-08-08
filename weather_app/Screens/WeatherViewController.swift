//
//  ViewController.swift
//  weather_app
//
//  Created by Rustam Aliyev on 29.06.2023.
//

import UIKit
import SnapKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    static let heightScreen = UIScreen.main.bounds.height
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    private let backgroundimageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "light")
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        return image
    }()

    var mainStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .fill
        stackView.spacing = 10

        return stackView
    }()

    var searchStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10

        return stackView
    }()

    let locationButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "location.circle.fill"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.tintColor = .label
        button.addTarget(self, action: #selector(locationPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        textField.backgroundColor = .systemFill
        textField.placeholder = "Search"
        textField.font = UIFont.systemFont(ofSize: 25)
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .words
        textField.textContentType = .countryName
       
        textField.returnKeyType = .go
        
        textField.delegate = self
        
        return textField
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.tintColor = .label
        button.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
        
        return button
    }()

    var conditionImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "sun.max")
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor(named: "weatherColor")
        return image
    }()
    
    var temperatureStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    var temperatureLabel: UILabel = {
        var label = UILabel()
        label.text = "21"
        label.font = UIFont.boldSystemFont(ofSize: 80)
        label.textAlignment = .right
        return label
    }()
    
    var tempOLabel: UILabel = {
        var label = UILabel()
        label.text = "°"
        label.font = UIFont.systemFont(ofSize: 100)
        label.textAlignment = .left
        return label
    }()

    var tempCLabel: UILabel = {
        var label = UILabel()
        label.text = "C"
        label.font = UIFont.systemFont(ofSize: 100)
        label.textAlignment = .left
        return label
    }()
    
    var cityLabel: UILabel = {
        var label = UILabel()
        label.text = "Almaty"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .natural
        return label
    }()
    
    var emptyView: UIView = {
        var view = UIView()
        view.contentMode = .scaleAspectFill
        return view
    }()

    var weatherStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        return stackView
    }()
    
    var windView: UIView = {
        var myView = UIView()
        myView.backgroundColor = .systemFill
        myView.layer.cornerRadius = 15
        return myView
    }()
    var humidityView: UIView = {
        var myView = UIView()
        myView.backgroundColor = .systemFill
        myView.layer.cornerRadius = 15
        return myView
    }()
    
    var windHeaderStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .fillProportionally
        stackView.spacing = 15
        
        return stackView
    }()
    var humidityHeaderStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .fillProportionally
        stackView.spacing = 15
        
        return stackView
    }()
    var windimageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "wind")
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor(named: "weatherColor")
        return image
    }()
    var humidityimageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "humidity")
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor(named: "weatherColor")
        return image
    }()
    var windLabel: UILabel = {
        var label = UILabel()
        label.text = "Wind, км/ч"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    var humidityLabel: UILabel = {
        var label = UILabel()
        label.text = "Humidity, %"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    var windNumberLabel: UILabel = {
        var label = UILabel()
        label.text = "27"
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.textAlignment = .center
        return label
    }()
    var humidityNumberLabel: UILabel = {
        var label = UILabel()
        label.text = "50"
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.textAlignment = .center
        return label
    }()
    let infoButton: UIButton = {
        let button = UIButton()
        button.setTitle("See more...", for: .normal)
        button.backgroundColor = .systemFill
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        // button.addTarget(self, action: #selector(moreInfoPressed), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        weatherManager.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
    //MARK: Private
    private func setupViews() {
        view.addSubview(backgroundimageView)
        backgroundimageView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(searchStackView)
        searchStackView.addArrangedSubview(locationButton)
        searchStackView.addArrangedSubview(searchTextField)
        searchStackView.addArrangedSubview(searchButton)
        mainStackView.addArrangedSubview(conditionImageView)
        mainStackView.addArrangedSubview(temperatureStackView)
        temperatureStackView.addArrangedSubview(temperatureLabel)
        temperatureStackView.addArrangedSubview(tempOLabel)
        temperatureStackView.addArrangedSubview(tempCLabel)
        mainStackView.addArrangedSubview(cityLabel)
        mainStackView.addArrangedSubview(emptyView)
        emptyView.addSubview(weatherStackView)
        weatherStackView.addArrangedSubview(windView)
        weatherStackView.addArrangedSubview(humidityView)
        windView.addSubview(windHeaderStackView)
        humidityView.addSubview(humidityHeaderStackView)
        windHeaderStackView.addArrangedSubview(windimageView)
        humidityHeaderStackView.addArrangedSubview(humidityimageView)
        windHeaderStackView.addArrangedSubview(windLabel)
        humidityHeaderStackView.addArrangedSubview(humidityLabel)
        windView.addSubview(windNumberLabel)
        humidityView.addSubview(humidityNumberLabel)
        //emptyView.addSubview(infoButton)
    }
    
    private func setupConstraints() {
        backgroundimageView.pinEdgesToSuperview()
        
        mainStackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(20)
        }
        searchStackView.snp.makeConstraints { make in
            make.left.right.equalTo(mainStackView)
        }
        locationButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        searchButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        conditionImageView.snp.makeConstraints { make in
            make.width.height.equalTo(120)
        }
        emptyView.snp.makeConstraints { make in
            make.height.equalTo(WeatherViewController.heightScreen/2 - 20)
            make.left.right.equalTo(mainStackView)
        }
        weatherStackView.snp.makeConstraints { make in
            make.left.right.equalTo(emptyView)
            make.height.equalTo((WeatherViewController.heightScreen/2 - 20) / 2)
        }
        windView.snp.makeConstraints { make in
            make.top.bottom.equalTo(weatherStackView)
        }
        humidityView.snp.makeConstraints { make in
            make.top.bottom.equalTo(weatherStackView)
        }
        windHeaderStackView.snp.makeConstraints { make in
            make.left.right.equalTo(windView).inset(15)
            make.top.equalTo(windView).inset(5)
        }
        humidityHeaderStackView.snp.makeConstraints { make in
            make.left.right.equalTo(humidityView).inset(15)
            make.top.equalTo(humidityView).inset(5)
        }
        windimageView.snp.makeConstraints { make in
            make.width.height.equalTo(25)
        }
        humidityimageView.snp.makeConstraints { make in
            make.width.height.equalTo(25)
        }
        windNumberLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(windView)
        }
        humidityNumberLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(humidityView)
        }
//        infoButton.snp.makeConstraints { make in
//            make.left.right.equalTo(emptyView).inset(60)
//            make.bottom.equalTo(emptyView).inset(20)
//        }
    }
    
    //MARK: Actions
    
    @objc
    func locationPressed() {
        locationManager.requestLocation()
    }
    @objc
    func searchPressed() {
        searchTextField.endEditing(true)
    }

//    @objc
//    func moreInfoPressed() {
//        print("searchTextField.text!")
//    }
}
//MARK: Extensions
//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            searchTextField.placeholder = "Type something"
            return false
        }
    }
}
//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.humidityNumberLabel.text = "\(weather.humidityStr)"
            self.windNumberLabel.text = "\(weather.windSpeed)"
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
   
}
//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
