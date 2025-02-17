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
        let searchBarSearchButtonClicked: Observable<Void?> = Observable(nil)
        let queryDidChange: Observable<Query?> = Observable(nil)
        let prefetchRowsAt = Observable([IndexPath]())
        let didSelectRowAt: Observable<IndexPath?> = Observable(nil)
    }
    
    //MARK: - Output
    struct Output {
        let navigationTitle = Observable("도시 검색")
        let backButtonTitle = Observable("")
        let searchBarPlaceholder = Observable("지금, 날씨가 궁금한 곳은?")
        let cancelButtonTitle = Observable("취소")
        let noneContentText = Observable("원하는 도시를 찾지 못했습니다.")
        let searchBarText: Observable<String?> = Observable(nil)
        let showsKeyboard = Observable(false)
        let showsCancelButton = Observable(false)
        let showsNoneContentLabel = Observable(false)
        let showsTableView = Observable(true)
        let present = Observable(SearchPresent(cities: []))
        let popVC: Observable<Void?> = Observable(nil)
    }
    
    //MARK: - Private
    private struct Private {
        var total = Observable(CityStaticStorage.info.cityArray)
        let page = Observable(0)
        var perPage = 20
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
            self?.priv.page.value = 1
        }
        
        input.mainViewTapped.lazyBind { [weak self] _ in
            self?.output.showsKeyboard.value = false
        }
        
        input.searchBarSearchButtonClicked.lazyBind { [weak self] query in
            self?.output.showsKeyboard.value = false
        }
        
        input.queryDidChange.lazyBind { [weak self] query in
            self?.output.present.value.cities = []
            self?.priv.total.value = CityStaticStorage.info.cityArray
            self?.priv.perPage = 20
            self?.priv.isEnd = false
            self?.priv.weatherGroup.value = nil
            self?.getFilteredCities(query)
            self?.priv.page.value = 1
        }
        
        input.prefetchRowsAt.lazyBind { [weak self] indexPaths in
            self?.prefetch(indexPaths)
        }
        
        input.didSelectRowAt.lazyBind { [weak self] indexPath in
            self?.setUserCity(indexPath)
            self?.output.popVC.value = ()
        }
        
        priv.page.lazyBind { [weak self] page in
            self?.getCities(page)
        }
        
        priv.cities.lazyBind { [weak self] cities in
            self?.getWeatherGroup(cities)
        }
        
        priv.weatherGroup.lazyBind { [weak self] weatherGroup in
            guard let cities = self?.priv.cities.value,
                  let weatherGroup,
                  cities.count == weatherGroup.list.count
            else {
                // nil 처리
                return
            }
            
            self?.setPresent(cities, weatherGroup)
        }
        
        priv.total.lazyBind { [weak self] total in
            let isEmpty = total.isEmpty
            self?.output.showsNoneContentLabel.value = isEmpty
            self?.output.showsTableView.value = !isEmpty
        }
    }
    
    private func getFilteredCities(_ query: Query?) {
        guard var query, !query.isEmpty else {
            self.priv.total.value = CityStaticStorage.info.cityArray
            return
        }
        
        query = query.trimmingCharacters(in: .whitespaces).lowercased()
        
        let filtered = CityStaticStorage.info.citySet.filter {
            $0.koCityName.contains(query) ||
            $0.koCountryName.contains(query) ||
            $0.city.lowercased().contains(query) ||
            $0.country.lowercased().contains(query)
        }
        
        self.priv.total.value = Array(filtered)
    }
    
    private func getCities(_ page: Int) {
        guard page > 0 else { return }
        
        let totalCount = priv.total.value.count
        
        guard totalCount > 0 else { return } // error 처리
        
        if totalCount < 20 {
            priv.perPage = totalCount
        }
        
        let remain = totalCount - output.present.value.cities.count
        
        if remain <= priv.perPage {
            priv.perPage = remain
            priv.isEnd = true
        }
        
        let startIdx = output.present.value.cities.count
        let endIdx = startIdx + priv.perPage - 1
        let cities = Array(priv.total.value[startIdx...endIdx])
        
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
            if self.output.present.value.cities.first(where: { $0.id == cities[i].id }) != nil {
                continue
            }
            
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
