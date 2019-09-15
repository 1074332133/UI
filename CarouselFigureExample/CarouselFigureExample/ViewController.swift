//
//  ViewController.swift
//  CarouselFigureExample
//
//  Created by 是不是傻呀你 on 2019/9/15.
//  Copyright © 2019 是不是傻呀你. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var carouselView:CarouselFigureView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        let img1 = UIImageView(image: UIImage(named: "a1.jpg"))
        let img2 = UIImageView(image: UIImage(named: "a2.jpg"))
        let img3 = UIImageView(image: UIImage(named: "a3.jpg"))
        let img4 = UIImageView(image: UIImage(named: "a4.jpg"))
        img1.frame = CGRect(x: 0, y: 0, width: 375, height: 200)
        img2.frame = CGRect(x: 0, y: 0, width: 375, height: 200)
        img3.frame = CGRect(x: 0, y: 0, width: 375, height: 200)
        img4.frame = CGRect(x: 0, y: 0, width: 375, height: 200)
        img1.contentMode = .scaleToFill
        img2.contentMode = .scaleToFill
        img3.contentMode = .scaleToFill
        img4.contentMode = .scaleToFill
        
        self.carouselView = CarouselFigureView.initFromNib()
        self.carouselView!.frame = CGRect(x: 0, y: 0, width: 375, height: 250)
        self.carouselView!.pageViews = [img1,img2,img3,img4]
        self.view.addSubview(self.carouselView!)
    }


}

