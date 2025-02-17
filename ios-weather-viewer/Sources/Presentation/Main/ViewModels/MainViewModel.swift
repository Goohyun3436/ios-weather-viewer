//
//  MainViewModel.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/13/25.
//

import Foundation

final class MainViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let viewWillAppear: Observable<Void?> = Observable(nil)
    }
    
    //MARK: - Output
    struct Output {
        let navigationTitle = Observable("")
        let refreshButtonImage = "arrow.clockwise"
        let searchButtonImage = "magnifyingglass"
        let forecastButtonImageTitle = Observable(UIButtonImageTitle(
            image: "chevron.down.2",
            title: " 5일간 예보 보러가기"
        ))
        let chatCases = Chat.allCases
        let present: Observable<MainPresent?> = Observable(nil)
    }
    
    //MARK: - Private
    private struct Private {
        let city: Observable<CityInfo?> = Observable(nil)
        let weather: Observable<WeatherResponse?> = Observable(nil)
        let photo: Observable<PhotoResponse?> = Observable(nil)
        let dataDidLoad: Observable<Void?> = Observable(nil)
    }
    
    //MARK: - Property
    private(set) var input: Input
    private(set) var output: Output
    private var priv: Private
    
    //MARK: - Initializer Method
    init() {
        input = Input()
        output = Output()
        priv = Private()
        
        transform()
    }
    
    //MARK: - Transform
    func transform() {
        input.viewWillAppear.lazyBind { [weak self] _ in
            self?.getCity()
        }
        
        priv.city.lazyBind { [weak self] city in
            self?.getWeather(city)
        }
        
        priv.weather.lazyBind { [weak self] weather in
            self?.getPhoto(weather)
        }
        
        priv.photo.lazyBind { [weak self] photo in
            guard let city = self?.priv.city.value,
                  let weather = self?.priv.weather.value,
                  let weatherDescription = weather.weather.first?.description,
                  let photo
            else {
                // nil 처리
                return
            }
            
            self?.setPresent(city, weather, weatherDescription, photo)
        }
    }
    
    private func getCity() {
        self.priv.city.value = CityStorage.shared.userCity()
    }
    
    private func getWeather(_ city: CityInfo?) {
        guard let cityId = city?.id else { return } // error 처리
        
        NetworkManager.shared.request(
            WeatherRequest.weather(cityId),
            WeatherResponse.self
        ) { [weak self] data in
            self?.priv.weather.value = data
        } failureHandler: {
            // error 처리
            self.priv.weather.value = nil // weak self 처리
        }
    }
    
    private func getPhoto(_ weather: WeatherResponse?) {
        guard let query = weather?.weather.first?.main else { return } // error 처리
        
        NetworkManager.shared.request(
            PhotoRequest.search(query),
            PhotoResponse.self
        ) { [weak self] data in
            self?.priv.photo.value = data
        } failureHandler: {
            // error 처리
            self.priv.photo.value = nil // weak self 처리
        }
    }
    
    private func setPresent(
        _ city: CityInfo,
        _ weather: WeatherResponse,
        _ weatherDescription: String,
        _ photo: PhotoResponse
    ) {
        self.output.present.value = MainPresent(
            locationName: city.locationName,
            datetime: weather.datetime,
            weatherChat: IconNLabelChat(
                image: weather.weather.first?.iconUrl ?? "",
                imagePlaceholder: "sun.max",
                text: "오늘의 날씨는 \(weatherDescription) 입니다",
                targetStrings: [weatherDescription]
            ),
            tempChat: LabelNSubLabelChat(
                text: "현재 온도는 \(weather.main.temp)°입니다",
                subText: "최저 \(weather.main.tempMin)° 최고 \(weather.main.tempMax)°",
                targetStrings: ["\(weather.main.temp)°"]
            ),
            feelsLikeTempChat: LabelChat(
                text: "체감 온도는 \(weather.main.feelsLike)°입니다",
                targetStrings: ["\(weather.main.feelsLike)°"]
            ),
            sunriseNSunsetChat: LabelChat(
                text: "서울의 일출시각은 \(weather.sys.sunriseText), 일몰 시각은 \(weather.sys.sunsetText) 입니다",
                targetStrings: [weather.sys.sunriseText, weather.sys.sunsetText]
            ),
            humidityNWindspeedChat: LabelChat(
                text: "습도는 \(Int(weather.main.humidity))% 이고, 풍속은 \(weather.wind.speed)m/s 입니다",
                targetStrings: ["\(Int(weather.main.humidity))%", "\(weather.wind.speed)m/s"]
            ),
            photoChat: ImageNLabelChat(
                text: "오늘의 사진",
                image: photo.results.first?.urls.small ?? "",
                imagePlaceholder: "weather"
            )
        )
    }
    
}
