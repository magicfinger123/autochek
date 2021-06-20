//
//  NetworkManager.swift
//  autocheck
//
//  Created by CWG Mobile Dev on 18/06/2021.
//

import Foundation
import Moya

enum NetworkManager  {
    case getPopularModels
    case getAllCars(currentPage:Int, pageSize: Int)
    case getCarDetails(carId:String)
    case getCarMedia(carId:String)
}
extension NetworkManager : TargetType{
    var baseURL: URL {
        URL(string: AppUrls.BASE_URL)!
    }
    var path: String {
        switch self {
        case .getPopularModels:
            return AppUrls.POPULAR_CARS
        case .getAllCars:
            return AppUrls.LIST_ALL_CARS
        case .getCarDetails(carId: let carId):
            return AppUrls.CAR_DETAILS+carId
        case .getCarMedia:
            return AppUrls.GET_CAR_MEDIA
        }
    }
    var method: Moya.Method {
        .get
    }
    var sampleData: Data {
        Data()
    }
    var task: Task {
        switch self {//?popular=true
        case .getAllCars(let currentPage, let pageSize):
            return .requestParameters(parameters: ["currentPage" : currentPage, "pageSize":pageSize], encoding: URLEncoding(destination: .queryString, arrayEncoding: .noBrackets))
        case  .getCarDetails:
            return .requestPlain
        case .getCarMedia(carId: let carId):
            return .requestParameters(parameters: ["carId" : carId], encoding: URLEncoding(destination: .queryString, arrayEncoding: .noBrackets))
        case .getPopularModels:
            return .requestParameters(parameters: ["popular" : "true"], encoding: URLEncoding(destination: .queryString, arrayEncoding: .noBrackets))
        }
    }
    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "Accept":"application/json"
        ]
    }
    
    
}
