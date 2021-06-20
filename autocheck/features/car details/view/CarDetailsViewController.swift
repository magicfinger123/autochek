//
//  CarDetailsViewController.swift
//  autocheck
//
//  Created by CWG Mobile Dev on 19/06/2021.
//


//Gilroy-ExtraBold,16
import UIKit
import Reusable
import RxCocoa
import RxSwift
import Kingfisher
import SDWebImage
import SVGKit
import AVKit
import AVFoundation
import KVNProgress

class CarDetailsViewController: UIViewController , StoryboardBased, UIScrollViewDelegate{
    @IBOutlet weak var selectedImage: UIImageView!
    
    @IBOutlet weak var activityLoader: UIView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var contentUI: UIView!
    @IBOutlet weak var carTitle: CustomLabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var transmission: UILabel!
    @IBOutlet weak var make: UILabel!
    @IBOutlet weak var sellingCondition: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var engineType: UILabel!
    @IBOutlet weak var milage: UILabel!
    var viewModel: HomeVM!
    var carId: String!
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        contentUI.layer.shadowColor = UIColor.systemGray3.cgColor
        contentUI.layer.shadowOpacity = 1
        contentUI.layer.shadowOffset = .zero
        contentUI.layer.shadowRadius = 10
        viewModel.getCarDetails(carId: carId)
        viewModel.getCarMedia(carId: carId)
        showLoader()
        viewModel.carDetailsRelay.asObservable().subscribe(onNext: { [self]
            result in
            if result.count > 0 {
                let carDetails = result[0]
                transmission.text = carDetails.transmission
                make.text = carDetails.model?.name
                rating.text = String(format: "%.2f", carDetails.gradeScore!)
                sellingCondition.text = carDetails.sellingCondition
                price.text = String(carDetails.price!).currencyFormatting()
                engineType.text = carDetails.engineType
                milage.text = String(carDetails.mileage!)
                carTitle.text = carDetails.model?.make?.name
                embedImage(imageItem: selectedImage, url: carDetails.imageURL!)
                
            }
            
        },onError: { error in
            
        }
        ).disposed(by: disposeBag)
        
        collectionView.register(UINib(nibName: "CarMediaCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "CarMediaCollectionViewCell")
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.carMediaListRelay.asObservable().asObservable().bind(to: self.collectionView.rx.items(cellIdentifier: "CarMediaCollectionViewCell", cellType: CarMediaCollectionViewCell.self)) {[self]
            row, data, cell in
            embedImage(imageItem: selectedImage, url: data.url!)
            embedImage(imageItem: cell.image, url: data.url!)
        }.disposed(by: disposeBag)
        Observable.zip(
            collectionView.rx.itemSelected
            ,collectionView.rx.modelSelected(CarMediaList.self))
            .asObservable()
            .bind{ [self] indexPath, model in
                embedImage(imageItem: selectedImage, url: model.url!)
            }
            .disposed(by: disposeBag)
        collectionView.rx.itemDeselected.bind{
            index in
        }.disposed(by: disposeBag)
        backBtn.rx.tap.subscribe({_ in 
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.successfulFetchRelay.asObservable().subscribe{[self]
            result in
            if result.element == true {
               hideLoader()
                viewModel.successfulFetchRelay.accept(false)
            }
        }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width) // compute your cell width
        return CGSize(width: cellWidth, height: collectionView.bounds.height - 5)
    }
    func embedImage(imageItem: UIImageView, url: String){
        let imgURL: URL? = URL(string: url)
        let last4 = String(url.suffix(3))
        if last4.lowercased() == "mp4" {
            playVideo(url: imgURL!)
            return
        }
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
    
        imageItem.kf.setImage(with: imgURL, placeholder: nil, options: [.processor(processor)])
        {
            result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                imageItem.kf.setImage(with: imgURL, placeholder: nil, options: [.processor(SVGImgProcessor())])
            }
        }
    }
    
    func playVideo(url: URL) {
           let player = AVPlayer(url: url)
        print("video url: \(url)")
           let vc = AVPlayerViewController()
           vc.player = player
           
           self.present(vc, animated: true) { vc.player?.play() }
       }
    func showLoader(){
        activityLoader.isHidden = false
    }
    func hideLoader(){
        activityLoader.isHidden = true
    }
}
