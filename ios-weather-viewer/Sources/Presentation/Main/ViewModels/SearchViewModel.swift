//
//  SearchViewModel.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/13/25.
//

import Foundation

final class SearchViewModel: BaseViewModel {
    
    //MARK: - Input
    struct Input {
        let viewDidLoad: Observable<Void?> = Observable(nil)
    }
    
    //MARK: - Output
    struct Output {
        let navigationTitle = Observable("도시 검색")
        let backButtonTitle = Observable("")
        let searchBarPlaceholder = Observable("지금, 날씨가 궁금한 곳은?")
        let cities = CityStaticStorage.cities
        let present: Observable<SearchPresent?> = Observable(nil)
    }
    
    //MARK: - Private
    private struct Private {
        let weatherGroup: Observable<WeatherGroupResponse?> = Observable(nil)
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
        input.viewDidLoad.lazyBind { [weak self] _ in
            self?.priv.weatherGroup.value = self?.getWeatherGroup()
        }
        
        priv.weatherGroup.lazyBind { [weak self] weatherGroup in
            guard let cities = self?.output.cities, let weatherGroup else {
                // nil 처리
                return
            }
            
            self?.setPresent(cities, weatherGroup)
        }
    }
    
    private func getWeatherGroup() -> WeatherGroupResponse? {
        // id 20개씩 처리
        
        let weatherGroup = JSONManager.shared.load("WeatherGroupResponse", WeatherGroupResponse.self)
        
        return weatherGroup
    }
    
    private func setPresent(_ cities: [CityInfo], _ weatherGroup: WeatherGroupResponse) {
        var cityWeathers = [CityWeatherInfo]()
        
        for i in weatherGroup.list.indices {
            cityWeathers.append(CityWeatherInfo(
                id: cities[i].id,
                koCityName: cities[i].koCityName,
                koCountryName: cities[i].koCountryName,
                iconUrl: weatherGroup.list[i].weather.first?.iconUrl ?? "", // nil 처리
                tempMinMax: "최저 \(Int(weatherGroup.list[i].main.tempMin))° 최고 \(Int(weatherGroup.list[i].main.tempMax))°",
                temp: "\(weatherGroup.list[i].main.temp)°"
            ))
        }
        
        self.output.present.value = SearchPresent(cities: cityWeathers)
    }
    
}
