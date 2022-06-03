//
//  DetailVC.swift
//  GraphqL2
//
//  Created by cedcoss on 02/05/22.
//

import UIKit
import SDWebImage
class DetailVC: UIViewController {
    @IBOutlet weak var productImageDVC: UIImageView!
    @IBOutlet weak var productTitleDVC: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    
    
    var img = UIImage()
//    var imgD = UIImage()
    var titleD = ""
    var descriptionD = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        
        productImageDVC.image = img
        productTitleDVC.text = titleD
        productDescription.text = descriptionD
    }
}
