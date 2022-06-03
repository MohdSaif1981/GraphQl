//
//  CartVC.swift
//  GraphqL2
//
//  Created by cedcoss on 10/05/22.
//

import UIKit
import SafariServices
import MobileBuySDK
class CartVC: UIViewController {
    
    @IBOutlet weak var cartTV: UITableView!
    var varTitleArr = [String]()
    var varImgArr = [URL]()
    var checkoutUrl = URL(string: "")
    
    
    var vIa = [URL(string: "https://cdn.shopify.com/s/files/1/0639/6159/6140/products/URBANE.jpg?v=1651212936"), URL(string:"https://cdn.shopify.com/s/files/1/0639/6159/6140/products/BROWN.jpg?v=1651213168")]
   
    var vTa:[String] = ["S", "M"]
    var vP:[String] = ["222","299"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Checkout { url,arr1,arr2  in
            self.printData(arr1: arr1,arr2: arr2)
        }
        cartTV.dataSource = self
        cartTV.delegate = self
        print(varTitleArr)
    }
    
    
    @IBAction func checkoutBtn(_ sender: Any) {
       
        Checkout(completion: { url,arr1,arr2  in
            var strURl = url.absoluteString
            self.openWeb(contentLink: strURl )
        })
//        print(checkoutUrl)
//        self.openWeb(contentLink: "https://saifs5.myshopify.com/63961596140/checkouts/5c89e75a808008cd2937624e5fb4ea1c?key=a0ecebcc702d452a34b1b2be2669bf9a"
//)
    }
    
    func openWeb(contentLink : String){
         let url = URL(string: contentLink)!
         let controller = SFSafariViewController(url: url)
         controller.preferredBarTintColor = UIColor.darkGray
         controller.preferredControlTintColor = UIColor.groupTableViewBackground
         controller.dismissButtonStyle = .close
         controller.configuration.barCollapsingEnabled = true
         self.present(controller, animated: true, completion: nil)
         controller.delegate = self
    }
    

//MARK: Checkout
    
    func Checkout(completion : @escaping((URL, Array<String>, Array<URL>)->())) {
            
            var ID: GraphQL.ID = GraphQL.ID(rawValue: "")
            
            let client =  Graph.Client(shopDomain: "saifs5.myshopify.com", apiKey: "84349a3654445d30f855c0c8654c1aa6")
            client.cachePolicy = .cacheFirst(expireIn: 3600)
            
            let input = Storefront.CheckoutCreateInput.create(
                lineItems: .value([
                    Storefront.CheckoutLineItemInput.create(quantity: 1, variantId: GraphQL.ID(rawValue: "Z2lkOi8vc2hvcGlmeS9Qcm9kdWN0VmFyaWFudC80MjcyNDA1NjQ5ODQxMg==")),
                    Storefront.CheckoutLineItemInput.create(quantity: 1, variantId: GraphQL.ID(rawValue: "Z2lkOi8vc2hvcGlmeS9Qcm9kdWN0VmFyaWFudC80MjcyNDA0NjgzMTg1Mg==")),
                ])
            )
            
            let mutation = Storefront.buildMutation {$0
                    .checkoutCreate(input: input) {$0
                    .checkout{$0
                    .id()
                    .webUrl()
                    .lineItems(first: 10){ $0
                    .edges{$0
                    .node{$0
                    .variant{$0
                    .title()
                    .product { $0
                    .title()
                    }
                    .image{$0
                    .url()
                    }
                    .priceV2{$0
                    .amount()
                    }
                    }
                    }
                    }
                    }
                    }
                    .userErrors { $0
                    .field()
                    .message()
                    }
                    }
            }
            
          
            
            let task = client.mutateGraphWith(mutation) { [weak self] result, error in
                guard error == nil else {
                    return
                }

                guard let userError = result?.checkoutCreate?.userErrors else {
                    return
                }

                let checkoutID = result?.checkoutCreate?.checkout?.id
                let url = result?.checkoutCreate?.checkout?.webUrl
                var arr1 = [String]()
                var arr2 = [URL]()
                let variant = result?.checkoutCreate?.checkout?.lineItems.edges
                
//Amount
                for i in variant! {
                    print(i.node.variant?.priceV2.amount)
                }
        
//Title and image URL
                
                for i in variant! {
                    print(i.node.variant?.product.title)
                    print(i.node.variant?.title)
                    arr1.append(i.node.variant!.title)
                    print(i.node.variant?.image?.url)
                    arr2.append(i.node.variant?.image!.url as! URL)
                }
//                print(self?.varTitleArr)
//                print(self?.varImgArr)
                ID = checkoutID!
                print(checkoutID!)
                print(url!)
    //            self?.checkoutUrl = url!
               completion(url!,arr1,arr2)
//                print(self?.checkoutUrl)
            }
            task.resume()
            
 
        }

    func printData(arr1:[String],arr2:[URL]) {
        varTitleArr.append(contentsOf: arr1)
        varImgArr.append(contentsOf: arr2)
        print(varTitleArr)
    }
}


extension CartVC: SFSafariViewControllerDelegate
{
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension CartVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return vTa.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTV.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath ) as! CarttTableViewCell
       
        let titleKey = vTa[indexPath.row]
        cell.varTitle.text = titleKey
        
        
        let imageKey = vIa[indexPath.row]
        cell.varImage.setImageFrom(imageKey as? URL, placeholder: nil)
        
        let priceKey = vP[indexPath.row]
        cell.varPrice.text = priceKey
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 102
      }
}

extension CartVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
    }
}
