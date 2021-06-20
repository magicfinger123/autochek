//
//  HomeViewController.swift
//  autocheck
//
//  Created by CWG Mobile Dev on 18/06/2021.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher
import SDWebImage
import KVNProgress

enum CellModel{
    case title
    case search
    case popularModels
    case carList(car: Car)
}

struct SectionOfCustomData {
    var header: String
    var items: [CellModel]
}
extension SectionOfCustomData: SectionModelType {

    init(original: SectionOfCustomData, items: [CellModel]) {
        self = original
        self.items = items
    }
}


class HomeViewController: UIViewController, StoryboardBased, UITableViewDelegate{
    var viewModel:HomeVM!
   // var sectionModels:[SectionModel<String, CellModel>] = []
    @IBOutlet weak var activityLoader: UIView!
    var sectionModels:[SectionOfCustomData] = []
    var popularModel:[MakeList] = []
    var carList:[Car] = []
    var disposeBag = DisposeBag()
    var carCells: [CellModel] = []
    var dataSubject = PublishSubject<[SectionOfCustomData]>()
    var data: RxTableViewSectionedReloadDataSource<SectionOfCustomData>?
    var loaded = false;
    var index = 1;
    var carCount : Int?

    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getProviderModel()
        showLoader()
        viewModel.makeListRelay.asObservable().subscribe(onNext: {
            makelist in
            if makelist.count > 0 {
                self.popularModel = makelist
                self.viewModel.getCarList(page: 1, size: 20)
            }
        }) { error in
            
        }.disposed(by: disposeBag)
        viewModel.carListRelay.asObservable().subscribe(onNext: { [self]
            carList in
            if carList.count > 0{
                self.carList.removeAll()
                self.carList.append(contentsOf: carList) //= carList
                if !loaded {
                    carCount = carList.count;
                    self.initTableView()
                    initSections()
                    loaded = true
                }else {
                    updateCarlistSections(carList: carList)
                }
            }
        }) { error in
        }.disposed(by: disposeBag)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.successfulFetchRelay.asObservable().subscribe{[self]
            result in
            if result.element == true {
               hideLoader()
                viewModel.successfulFetchRelay.accept(false)
                if loaded {
                   
                }
            }
        }.disposed(by: disposeBag)
       // tableView.rx.reac
    }
    
    
    func title(from table: UITableView) -> UITableViewCell{
        table.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell") as! TitleTableViewCell
        return cell
    }
    
    func searchBar(from table: UITableView) -> UITableViewCell{
        table.register(UINib(nibName: "SearchBarTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchBarTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBarTableViewCell") as! SearchBarTableViewCell
        return cell
    }
    
    func popularModel(from table: UITableView)->UITableViewCell{
        table.register(UINib(nibName: "PopularModelsTableViewCell", bundle: nil), forCellReuseIdentifier: "PopularModelsTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopularModelsTableViewCell") as! PopularModelsTableViewCell
        cell.makeListRelay.accept(popularModel)
        return cell
        
    }
    func carCell(with element: Car, from table: UITableView)->UITableViewCell {
        table.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell") as! ProductTableViewCell
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        let imgURL: URL? = URL(string: element.imageURL!)
        cell.productImage.kf.setImage(with: imgURL, placeholder: nil, options: [.processor(processor)])
        cell.name.text = element.title!
        cell.price.text = String(element.marketplacePrice!).currencyFormatting()
        cell.condition.text = element.sellingCondition!
        cell.rating.text = String(format: "%.2f", element.gradeScore!)
        
        return cell
    }
    
    
    fileprivate func initSections() {
        for item in carList {
            carCells.append(CellModel.carList(car: item))
        }
        sectionModels.append(SectionOfCustomData(header: "", items: [CellModel.title]))
        sectionModels.append(SectionOfCustomData(header: "", items: [CellModel.search]))
        sectionModels.append(SectionOfCustomData(header: "", items: [CellModel.popularModels]))
        sectionModels.append(SectionOfCustomData(header: "", items: carCells))
        dataSubject.onNext( sectionModels )
    }
    fileprivate func updateCarlistSections(carList: [Car]) {
        for item in carList {
            carCells.append(CellModel.carList(car: item))
        }
        sectionModels.append(SectionOfCustomData(header: "", items: carCells))
        dataSubject.onNext( sectionModels )
    }
    
    fileprivate func initTableView() {
        data = RxTableViewSectionedReloadDataSource<SectionOfCustomData>(configureCell: { dataSource, table, indexPath, item in
           switch item {
           case .title:
               return self.title(from: table)
           case .search:
               return self.searchBar(from: table)
           case .popularModels:
               return self.popularModel(from: table)
           case .carList(car: let car):
               return  self.carCell(with: car, from: table)
           }

       })
        data?.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        Observable.zip(
            tableView.rx.itemSelected
            ,tableView.rx.modelSelected(CellModel.self)).asObservable().bind{
                a, b in
                switch b {
                //case rees
                case .title:
                    break
                case .search:
                    break
                case .popularModels:
                    break
                case .carList(car: let car):
                    self.viewModel.goToCardDetailScene(cardId: car .id!)
                }
               
            }.disposed(by: disposeBag)
        
        dataSubject
          .bind(to: tableView.rx.items(dataSource: data!))
          .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == carCount!-1 {
            viewModel.getCarList(page: index, size: 20)
            index += 1
            carCount = carCount! + carList.count
        }
    }
    func showLoader(){
        activityLoader.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    func hideLoader(){
        activityLoader.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
}
