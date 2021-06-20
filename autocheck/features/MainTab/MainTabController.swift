//
//  MainTabController.swift
//  autocheck
//
//  Created by CWG Mobile Dev on 18/06/2021.
//

import UIKit
import Reusable

class MainTabController: UITabBarController, StoryboardBased {
    let btn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.setNavigationBarHidden(true, animated: false)
        createMiddleButton()
    }
    func createMiddleButton(){
//        btn.setTitleColor(.white, for: .normal)
//        btn.setTitleColor(.red, for: .highlighted)
//        btn.frame =  CGRect(x: 100, y: 0, width: 44, height: 44)
//        btn.backgroundColor = UIColor(named: "color1")
//        btn.layer.borderWidth = 4
//        btn.layer.borderColor = UIColor.white.cgColor
//        btn.layer.shadowColor = UIColor.gray.cgColor
//        self.view.insertSubview(btn, aboveSubview: tabBar)
//        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
//        btn.setImage(UIImage(named: "heart"), for: .normal)
//        btn.setImage(UIImage(named: "heart"), for: .highlighted)
//        btn.imageView?.setImageColor(color: UIColor.white)
//        btn.contentVerticalAlignment = .fill
//        btn.contentHorizontalAlignment = .fill
//        btn.imageEdgeInsets = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        
    }
    @objc func click(sender: UIButton) {
        print("middle button clicked")
    }
}
