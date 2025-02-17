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
        let prefetchRowsAt = Observable([IndexPath]())
        let didSelectRowAt: Observable<IndexPath?> = Observable(nil)
        let mainViewTapped: Observable<Void?> = Observable(nil)
    }
    
    //MARK: - Output
    struct Output {
        let navigationTitle = Observable("도시 검색")
        let backButtonTitle = Observable("")
        let searchBarPlaceholder = Observable("지금, 날씨가 궁금한 곳은?")
        let present = Observable(SearchPresent(cities: []))
        let showsKeyboard = Observable(false)
        let popVC: Observable<Void?> = Observable(nil)
    }
    
    //MARK: - Private
    private struct Private {
        let page = Observable(0)
        var perPage = 20
        let total = CityStaticStorage.info.cityArray.count
        var isEnd = false
        let cities = Observable([CityInfo]())
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
            print("viewDidLoad")
            self?.priv.page.value = 1
        }
        
        input.prefetchRowsAt.lazyBind { [weak self] indexPaths in
            print("prefetchRowsAt")
            self?.prefetch(indexPaths)
        }
        
        input.didSelectRowAt.lazyBind { [weak self] indexPath in
            self?.setUserCity(indexPath)
            self?.output.popVC.value = ()
        }
        
        input.mainViewTapped.lazyBind { [weak self] _ in
            self?.output.showsKeyboard.value = false
        }
        
        priv.page.lazyBind { [weak self] page in
            print("page")
            self?.getCities(page)
        }
        
        priv.cities.lazyBind { [weak self] cities in
            print("cities")
            self?.getWeatherGroup(cities)
        }
        
        priv.weatherGroup.lazyBind { [weak self] weatherGroup in
            print("weatherGroup")
            guard let cities = self?.priv.cities.value,
                  let weatherGroup
            else {
                // nil 처리
                return
            }
            
            self?.setPresent(cities, weatherGroup)
        }
    }
    
    private func getCities(_ page: Int) {
        guard priv.total > 0 else { return } // error 처리
        
        if priv.total < 20 {
            priv.perPage = priv.total
        }
        
        if priv.total - output.present.value.cities.count < priv.perPage {
            priv.perPage = priv.total - output.present.value.cities.count
            priv.isEnd = true
        }
        
        print(#function)
        print("page: \(page), perPage: \(priv.perPage), isEnd: \(priv.isEnd)")
        
        let startIdx = priv.perPage * (priv.page.value - 1)
        let endIdx = priv.perPage * priv.page.value - 1
        let cities = Array(CityStaticStorage.info.cityArray[startIdx...endIdx])
        
        self.priv.cities.value = cities
    }
    
    private func getWeatherGroup(_ cities: [CityInfo]) {
        let cityIds = cities.map { $0.id }
        
        NetworkManager.shared.request(
            WeatherRequest.group(cityIds),
            WeatherGroupResponse.self
        ) { [weak self] data in
            self?.priv.weatherGroup.value = data
        } failureHandler: {
            // error 처리
            self.priv.weatherGroup.value = nil // weak self 처리
        }
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
        
        self.output.present.value.cities.append(contentsOf: cityWeathers)
    }
    
    private func prefetch(_ indexPaths: [IndexPath]) {
        guard !priv.isEnd else { return }
        
        indexPaths.forEach {
            if self.output.present.value.cities.count - 2 == $0.row {
                self.priv.page.value += 1
            }
        }
    }
    
    private func setUserCity(_ indexPath: IndexPath?) {
        guard let indexPath else { return }
        
        let cityId = output.present.value.cities[indexPath.row].id
        UserStorage.shared.info.cityId = cityId
    }
    
}
