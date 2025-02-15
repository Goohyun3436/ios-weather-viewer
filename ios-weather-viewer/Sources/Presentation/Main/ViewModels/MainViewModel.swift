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
        let chatCases = Chat.allCases
        let city: Observable<CityInfo?> = Observable(nil)
        let present: Observable<MainPresent?> = Observable(nil)
    }
    
    private struct Private {
        var weather: Observable<WeatherResponse?> = Observable(nil)
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
            self?.output.city.value = self?.getCity()
            self?.priv.weather.value = self?.getWeather()
        }
        
        priv.weather.lazyBind { [weak self] weather in
            guard let city = self?.output.city.value, let weather else {
                // nil 처리
                return
            }
            
            self?.setPresent(city, weather)
        }
    }
    
    private func getCity() -> CityInfo? {
        return CityStaticStorage.cities.first
    }
    
    private func getWeather() -> WeatherResponse? {
        let weather = JSONManager.shared.load("WeatherResponse", WeatherResponse.self)
        
        return weather
    }
    
    private func setPresent(_ city: CityInfo, _ weather: WeatherResponse) {
        self.output.present.value = MainPresent(
            locationName: city.locationName,
            datetime: weather.datetime,
            weatherChat: IconNLabelChat(
                image: weather.weather.first?.iconUrl ?? "", // kingfisher nil 처리
                text: "오늘의 날씨는 \(weather.weather.first?.description ?? "??") 입니다", // nil 처리
                targetStrings: [weather.weather.first?.description ?? "??"] // nil 처리
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
            sunriceNSunsetChat: LabelChat(
                text: "서울의 일출시각은 오전 7시 43분, 일몰 시각은 오후 5시 23분 입니다",  // rawData 처리
                targetStrings: ["오전 7시 43분", "오후 5시 23분"]
            ),
            humidityNWindspeedChat: LabelChat(
                text: "습도는 \(weather.main.humidity)% 이고, 풍속은 \(weather.wind.speed)m/s 입니다",
                targetStrings: ["\(weather.main.humidity)%", "\(weather.wind.speed)m/s"]
            ),
            photoChat: ImageNLabelChat( // rawData 처리
                image: "https://images.unsplash.com/photo-1536543142971-bf3497c288c7?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTgwMzl8MHwxfHNlYXJjaHwyMXx8b3ZlcmNhc3QlMjBjbG91ZHNwYWlyXzczNTYxZTM2Zjc0NjQ5ZjU4Nzc5MzYxOTE5ZmE5NzM5fGVufDB8fHx8MTczOTYwNjcyNHww&ixlib=rb-4.0.3&q=80&w=400",
                text: "오늘의 사진"
            )
        )
    }
    
}
