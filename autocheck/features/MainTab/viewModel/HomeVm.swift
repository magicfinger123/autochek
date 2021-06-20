//
//  HomeVm.swift
//  autocheck
//
//  Created by CWG Mobile Dev on 19/06/2021.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class HomeVM {
    var coordinatorProtocol : TabSceneProtocol!
    var apiClient = ApiClient()
    var makeListRelay = BehaviorRelay<[MakeList]>(value: [])
    var carListRelay = BehaviorRelay<[Car]>(value: [])
    var disposeBag = DisposeBag()
    var carDetailsRelay = BehaviorRelay<[CarDetailResponse]>(value: [])
    var carMediaListRelay = BehaviorRelay<[CarMediaList]>(value: [])
    var successfulFetchRelay =  BehaviorRelay<Bool>(value: false)
    
    func getProviderModel(){
        apiClient.getPopularModels().asObservable().subscribe(onNext: {
            result in
            if result.makeList?.count ?? 0 > 0{
                self.makeListRelay.accept(result.makeList!)
            }
        }) { error in
            //errors will be handles as Moya Error
        }.disposed(by: disposeBag)
    }
    
    func getCarList(page:Int, size: Int){
        apiClient.getCarsList(page: page, size: size).asObservable().subscribe(onNext: {[self]
            result in
            if result.result?.count ?? 0 > 0{
                successfulFetchRelay.accept(true)
                self.carListRelay.accept(result.result!)
            }
        }) { error in
            //errors will be handles as Moya Error
        }.disposed(by: disposeBag)
    }
    
    func getCarDetails(carId: String){
        apiClient.getCarDetails(carId: carId).asObservable().subscribe(onNext: {[self]
            result in
            if result.id != nil {
                successfulFetchRelay.accept(true)
                self.carDetailsRelay.accept([result])
            }
        })
        { error in
            //errors will be handles
        }.disposed(by: disposeBag)
    }
    
    func goToCardDetailScene(cardId: String){
        coordinatorProtocol.goToCardDetails(carId: cardId)
    }
    
    func getCarMedia(carId: String){
        apiClient.getCarMedia(carId: carId).asObservable().subscribe(onNext: {[self]
            result in
            if result.carMediaList?.count ?? 0 > 0{
                successfulFetchRelay.accept(true)
                self.carMediaListRelay.accept(result.carMediaList!)
            }
        }, onError: { error in
            //errors will be handles as Moya Error
        }).disposed(by: disposeBag)
    }
}
