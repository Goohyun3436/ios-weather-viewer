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
        let mainViewTapped: Observable<Void?> = Observable(nil)
        let searchBarShouldBeginEditing: Observable<Void?> = Observable(nil)
        let searchBarCancelButtonClicked: Observable<Void?> = Observable(nil)
        let searchBarSearchButtonClicked: Observable<Void?> = Observable(nil)
        let queryDidChange: Observable<String?> = Observable(nil)
        let prefetchRowsAt = Observable([IndexPath]())
        let didSelectRowAt: Observable<IndexPath?> = Observable(nil)
    }
    
    //MARK: - Output
    struct Output {
        let navigationTitle = Observable("도시 검색")
        let backButtonTitle = Observable("")
        let searchBarPlaceholder = Observable("지금, 날씨가 궁금한 곳은?")
        let cancelButtonTitle = Observable("취소")
        let present = Observable(SearchPresent(cities: []))
        let showsKeyboard = Observable(false)
        let showsCancelButton = Observable(false)
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
        var backupCityWeatherGroup = Set<WeatherResponse>()
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
        
        input.mainViewTapped.lazyBind { [weak self] _ in
            self?.output.showsKeyboard.value = false
        }
        
        input.searchBarShouldBeginEditing.lazyBind { [weak self] _ in
            self?.output.showsCancelButton.value = true
        }
        
        input.searchBarCancelButtonClicked.lazyBind { [weak self] _ in
            self?.output.showsKeyboard.value = false
            self?.output.showsCancelButton.value = false
//            self?.input.query.value = nil
        }
        
        input.searchBarSearchButtonClicked.lazyBind { [weak self] query in
            self?.output.showsKeyboard.value = false
            self?.output.showsCancelButton.value = false
        }
        
        input.queryDidChange.lazyBind { [weak self] query in
            self?.getFilteredCities(query)
        }
        
        input.prefetchRowsAt.lazyBind { [weak self] indexPaths in
            print("prefetchRowsAt")
            self?.prefetch(indexPaths)
        }
        
        input.didSelectRowAt.lazyBind { [weak self] indexPath in
            self?.setUserCity(indexPath)
            self?.output.popVC.value = ()
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
    
    private func getFilteredCities(_ query: Query?) {
        guard let query else { return }
        
        let filtered = CityStaticStorage.info.citySet.filter {
            $0.koCityName.contains(query) ||
            $0.koCountryName.contains(query) ||
            $0.city.contains(query) ||
            $0.country.contains(query)
        }
        
        print("query: \(query), \(filtered.count)/\(CityStaticStorage.info.citySet.count)")
        print("==================")
        print(filtered)
        print("==================")
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
        
        let startIdx = output.present.value.cities.count
        let endIdx = startIdx + priv.perPage - 1
        let cities = Array(CityStaticStorage.info.cityArray[startIdx...endIdx])
        
        print("start: \(startIdx), end: \(endIdx)")
        
        self.priv.cities.value = cities
    }
    
    private func getWeatherGroup(_ cities: [CityInfo]) {
        var cityIdSet = Set<CityId>()
        
        cities.forEach {
            cityIdSet.insert($0.id)
        }
        
        print("before(\(cityIdSet.count)): \(cityIdSet)")
        
        // 분기
        var exceptionCityIds = [Int]()
        var weatherGroup: WeatherGroupResponse? = WeatherGroupResponse(list: [])
        
        for id in cityIdSet {
            if let backup = self.priv.backupCityWeatherGroup.first(where: { $0.id == id }) {
                exceptionCityIds.append(id)
                weatherGroup?.list.append(backup)
            }
        }
        
        let cityIds = Array(cityIdSet.subtracting(exceptionCityIds))
        
        print("after(\(cityIds.count)): \(cityIds)")
        
        let group = DispatchGroup()
        
        group.enter()
        NetworkManager.shared.request(
            WeatherRequest.group(cityIds),
            WeatherGroupResponse.self
        ) { data in
            weatherGroup?.list.append(contentsOf: data.list)
            group.leave()
        } failureHandler: {
            // error 처리
            weatherGroup = nil // weak self 처리
            group.leave()
        }
        
        group.notify(queue: .main) {
            let sorted = weatherGroup?.list.sorted { $0.id < $1.id } ?? []
            weatherGroup?.list = sorted
            self.priv.weatherGroup.value = weatherGroup
        }
    }
    
    private func setPresent(_ cities: [CityInfo], _ weatherGroup: WeatherGroupResponse) {
        var cityWeathers = [CityWeatherInfo]()
        
        for i in weatherGroup.list.indices {
            cityWeathers.append(CityWeatherInfo(
                id: cities[i].id,
                koCityName: cities[i].koCityName,
                koCountryName: cities[i].koCountryName,
                iconUrl: weatherGroup.list[i].weather.first?.iconUrl ?? "",
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
