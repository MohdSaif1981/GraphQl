//
//  ViewController.swift
//  GraphqL2
//
//  Created by cedcoss on 02/05/22.
//

import UIKit
import MobileBuySDK
import SDWebImage


class ViewController: UIViewController{
    
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var amountArr:[String] = []
    var titleArr:[String] = []
    var imgArr = [URL]()
    var descriptionArr = [String]()
    var checkoutUrl = URL(string: "")
    var productTitleL = String()
    var productImageL = URL(string: "")
    
    var filteredData = [String]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//       getProductsQuery()
       forMultipleProducts()
        forCollections()
//        Checkout(completion: { url in
//            self.checkoutUrl = url
//        })
//        print(checkoutUrl)
        
        searchBar.delegate = self
        filteredData = titleArr
    }
    func forMultipleProducts() {
        let client =  Graph.Client(shopDomain: "saifs5.myshopify.com", apiKey: "84349a3654445d30f855c0c8654c1aa6")
        client.cachePolicy = .cacheFirst(expireIn: 3600)

        let query = Storefront.buildQuery { $0
                .products(first: 50) { $0
                .edges { $0
                .node { $0
                .id()
                .title()
                .priceRange { $0
                .maxVariantPrice { $0
                .amount()
                }
                }
                .description()
                .images(first : 10) { $0
                .edges { $0
                .node { $0
                .url()
                }
                }
                }
                .variants( first: 250){$0
                .edges{$0
                .node{$0
                .id()
                    
                }
                }
                    
                }
                    
//                .variants{$0
//                .edges{$0
//                .node{$0
//                .id()
//                }
//                }
//                }
                }
                }
                }
        }
      
        let task = client.queryGraphWith(query) { response, error in
            let products  = response?.products.edges.map{$0}
            

            print(products)
            
            for i in products!{
                for j in i.node.variants.edges {
                    print(j.node.id ?? "No id found")
                }

                i.node.variants.edges.forEach { x in
                    print(x.node.id)
                }
            }
            
            
            for i in products! {
                //print(i.node)
                self.descriptionArr.append(i.node.description)
               // self.amountArr.append(i.node.priceRange.maxVariantPrice.amount)
            }
            for i in products! {
                //print(i.node)
                self.titleArr.append(i.node.title)
                print(i.node.title)
               // self.amountArr.append(i.node.priceRange.maxVariantPrice.amount)
            }
            for i in products! {
                for j in i.node.images.edges {
                    self.imgArr.append(j.node.url)
                }
            }
           // self.pairs = zip(self.titleArr, self.imgArr).map { $0 }
          //  print(self.pairs)
          print(self.titleArr)
          print(self.imgArr)
        }
        task.resume()
    }
        
    func getProductsQuery() {
        
        //Query
        let query = Storefront.buildQuery { $0
                .node(id: GraphQL.ID(rawValue: "Z2lkOi8vc2hvcGlmeS9Qcm9kdWN0Lzc2MTcyMDM0Mzc4MDQ=")) { $0
                .onProduct { $0
                    .id()
                    .title()
                    .description()
                    .images(first: 10) { $0
                        .edges { $0
                            .node { $0
                                .id()
                                .transformedSrc()
                            }
                        }
                    }
                    
                    .variants(first: 10) { $0
                        .edges { $0
                            .node { $0
                                .id()
                                .price()
                                .title()
                            }
                        }
                    }
                }
            }
        }
        let client =  Graph.Client(shopDomain: "saifs5.myshopify.com", apiKey: "84349a3654445d30f855c0c8654c1aa6")
        client.cachePolicy = .cacheFirst(expireIn: 3600)

        //Task

        let task = client.queryGraphWith(query) { [self] response, error in
            let product  = response?.node as? Storefront.Product
            let images   = product?.images.edges.map { $0.node }
            let variants = product?.variants.edges.map { $0.node }
            //print(variants)
           
            print(product?.description)
            if let productTitle = product?.title {
                self.productTitleL = product!.title
//                print(self.productTitleL)
            } else {
                print("No title available")
            }
            
            
            for i in images! {
                if let images = images{
                    productImageL = i.transformedSrc
//                    print(productImageL)
//                    print(images)
                } else {
                    print("No image available")
                }
               
            }
                   
        }
        task.resume()
        

    }
    
//MARK: Collection
    
    
    func forCollections() {
        
        let client =  Graph.Client(shopDomain: "saifs5.myshopify.com", apiKey: "84349a3654445d30f855c0c8654c1aa6")
        client.cachePolicy = .cacheFirst(expireIn: 3600)
        
        
        let query = Storefront.buildQuery { $0
            
                .collections( first: 10) { $0
                .edges { $0
                .node { $0
                .id()
                .title()
                .image{$0
                .url()
                }
//                .products(first: 10) { $0
//                .edges{$0
//                .node{$0
//                .title()
//                .images{$0
//                .edges{$0
//                .node{$0
//                .url()
//                }
//                }
//                }
//                }
//                }
//                }
                }
                }
                    
                }
        }
        let task = client.queryGraphWith(query) { response, error in
        //    print(response!.collections.fields)
            
//            for i in response?.collections.fields{
//                print(i.title)
//            }
            response?.collections.edges.forEach({ i in
                print(i.node.title)
            })
        }
        task.resume()
        
    }
    
    
// MARK: Checkout
//
//    func Checkout(completion : @escaping((URL)->())) {
//
//        var ID: GraphQL.ID = GraphQL.ID(rawValue: "")
//
//        let client =  Graph.Client(shopDomain: "saifs5.myshopify.com", apiKey: "84349a3654445d30f855c0c8654c1aa6")
//        client.cachePolicy = .cacheFirst(expireIn: 3600)
//
//        let input = Storefront.CheckoutCreateInput.create(
//            lineItems: .value([
//                Storefront.CheckoutLineItemInput.create(quantity: 1, variantId: GraphQL.ID(rawValue: "Z2lkOi8vc2hvcGlmeS9Qcm9kdWN0VmFyaWFudC80MjcyNDA1NjQ5ODQxMg==")),
//                Storefront.CheckoutLineItemInput.create(quantity: 1, variantId: GraphQL.ID(rawValue: "Z2lkOi8vc2hvcGlmeS9Qcm9kdWN0VmFyaWFudC80MjcyNDA0NjgzMTg1Mg==")),
//            ])
//        )
//
//
//        let mutation = Storefront.buildMutation{$0
//                .checkoutCreate(input: input) {$0
//                .checkout{$0
//                .id()
//                .webUrl()
////                .lineItems{ $0
////                .edges{$0
////                .node{$0
////                .variant{$0
////                .title()
////                }
////                }
////                }
////                }
//                }
//                .userErrors { $0
//                .field()
//                .message()
//                }
//                }
//        }
//
//
//
//        let task = client.mutateGraphWith(mutation) { [weak self] result, error in
//            guard error == nil else {
//                return
//            }
//
//            guard let userError = result?.checkoutCreate?.userErrors else {
//                return
//            }
//
//            let checkoutID = result?.checkoutCreate?.checkout?.id
//            let url = result?.checkoutCreate?.checkout?.webUrl
////            self?.checkoutUrl = result?.checkoutCreate?.checkout?.webUrl
//           // let variant = result?.checkoutCreate?.checkout?.lineItems.edges
////            for i in variant! {
////                print(i.node.variant?.title)
////            }
//            ID = checkoutID!
//            print("Mutation")
//            print(checkoutID!)
//            print(url!)
////            self?.checkoutUrl = url!
//            completion(url!)
//            print(self?.checkoutUrl)
//        }
//        task.resume()
//
////        let query = Storefront.buildQuery { $0
////            .node(id: ID) { $0
////                .onCheckout { $0
////                    .id()
////                    .ready()
////                    .totalDuties { $0
////                        .amount()
////                        .currencyCode()
////                    }
////                    .totalTaxV2 { $0
////                        .amount()
////                        .currencyCode()
////                    }
////                    .totalPriceV2 { $0
////                        .amount()
////                        .currencyCode()
////                    }
////                    // ...
////                }
////            }
////        }
////
////        let retry = Graph.RetryHandler<Storefront.QueryRoot>(endurance: .finite(10)) { (response, _) -> Bool in
////            (response?.node as? Storefront.Checkout)?.ready ?? false == false
////        }
////
////        let task2 = client.queryGraphWith(query, retryHandler: retry) { response, error in
////            let updatedCheckout = response?.node as? Storefront.Checkout
////           //print("nything")
////            print(updatedCheckout?.id)
////        }
////        task2.resume()
////
//
//
//    }
        
}
        
        
        
    
//    @IBAction func toCart(_ sender: Any) {
//       func prepare(segue: UIStoryboardSegue, sender: AnyObject) {
//           if segue.identifier == "DetailVC" {
//               segue.destination as! CartVC
//                  // destination.receivedImage = postingImage.image
//               }
//        }
//    }
    


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.productImage?.layer.cornerRadius = (cell.productImage?.frame.size.width ?? 0.0) / 2
        cell.productImage?.clipsToBounds = true
        cell.productImage?.layer.borderWidth = 2.0
        cell.productImage?.layer.borderColor = UIColor.black.cgColor
        
        let titleKey = filteredData[indexPath.row]
        cell.productTitle.text = titleKey

        
       let imageKey = imgArr[indexPath.row]
        cell.productImage.setImageFrom(imageKey, placeholder: nil)
        

        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC {
            vc.titleD = titleArr[indexPath.row]
            
            let imageKey = imgArr[indexPath.row]
            let img =  URL(string: "\(imgArr[indexPath.row])")!
            let data = try? Data(contentsOf: img)

            if let imageDatas = data {
                let image = UIImage(data: imageDatas)
                DispatchQueue.main.async {
                    vc.productImageDVC.image =  image
                }
                
            }
            
           // vc.productImageDVC?.setImageFrom(imageKey, placeholder: nil)
            
            vc.descriptionD = descriptionArr[indexPath.row]
            
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension UIImageView {
  func setImageFrom(_ url: URL?, placeholder: UIImage? = nil) {
    /* ---------------------------------
     ** If the url is provided, kick off
     ** the image request and update the
     ** current data task.
     */
    if let url = url {
      self.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: [.scaleDownLargeImages,.refreshCached], completed: { (image,err, _,url) in
      })
    } else {
      self.image       = placeholder
     }
  }


}
extension ViewController: UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = []
        if searchText == " " {
            filteredData = titleArr
        } else {
        for tilte in titleArr {
            if tilte.lowercased().contains(searchText.lowercased()) {
                filteredData.append(tilte)
            }
        }
        self.tableView.reloadData()
    }
    }
}
