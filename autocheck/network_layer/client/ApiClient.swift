//
//  ApiClient.swift
//  autocheck
//
//  Created by CWG Mobile Dev on 18/06/2021.
//

import Foundation
import Moya
import RxSwift

class ApiClient {
    fileprivate var provider = MoyaProvider<NetworkManager>(plugins: [NetworkLoggerPlugin()])
    func getPopularModels() -> Observable<PopularMakeResponse> {
        provider.rx.request(.getPopularModels).asObservable().map(PopularMakeResponse.self)
    }
    func getCarsList(page:Int, size: Int) -> Observable<CarListResponse> {
        provider.rx.request(.getAllCars(currentPage: page, pageSize: size)).asObservable().map(CarListResponse.self)
    }
    func getCarDetails(carId: String) -> Observable<CarDetailResponse> {
        provider.rx.request(.getCarDetails(carId: carId)).asObservable().map(CarDetailResponse.self)
    }
    func getCarMedia(carId: String) -> Observable<CarMediaResponse> {
        provider.rx.request(.getCarMedia(carId: carId)).asObservable().map(CarMediaResponse.self)
    }
}
