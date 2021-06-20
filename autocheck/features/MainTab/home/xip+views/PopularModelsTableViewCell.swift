//
//  PopularModelsTableViewCell.swift
//  autocheck
//
//  Created by CWG Mobile Dev on 19/06/2021.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher
import SDWebImage
import SVGKit

class PopularModelsTableViewCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    @IBOutlet weak var collectionView: UICollectionView!
    var makeListRelay = BehaviorRelay<[MakeList]>(value:[])
    //var viewModel: HomeVM!
    var makeList: [MakeList]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "PopularMakeCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "PopularMakeCollectionViewCell")
        makeListRelay.asObservable().bind(to: self.collectionView.rx.items(cellIdentifier: "PopularMakeCollectionViewCell", cellType: PopularMakeCollectionViewCell.self)){
            row, data, cell in
            let processor = RoundCornerImageProcessor(cornerRadius: 20)
            let imgURL: URL? = URL(string: data.imageURL!)
            cell.makeImage.kf.setImage(with: imgURL, placeholder: nil, options: [.processor(processor)])
            {
                result in
                switch result {
                case .success(_):
                    break
                case .failure(_):
                    cell.makeImage.kf.setImage(with: imgURL, placeholder: nil, options: [.processor(SVGImgProcessor())])
                }
            }
            cell.makeName.text = data.name
        }.disposed(by: disposeBag)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
extension PopularModelsTableViewCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 40) / 4 // compute your cell width
        return CGSize(width: cellWidth, height: collectionView.bounds.height - 5)
    }
}


public struct SVGImgProcessor:ImageProcessor {
    public var identifier: String = "com.appidentifier.webpprocessor"
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            print("already an image")
            return image
        case .data(let data):
            let imsvg = SVGKImage(data: data)
            return imsvg?.uiImage
        }
    }
}
