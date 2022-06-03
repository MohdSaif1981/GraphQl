//
//  CollectionViewController.swift
//  GraphqL2
//
//  Created by cedcoss on 10/05/22.
//

import UIKit
import MobileBuySDK
import SDWebImage

class CollectionViewController: UIViewController {

    
    @IBOutlet weak var collectionTableView: UITableView!
    var colTitleArr = [String]()
    var colImageArr = [URL]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionTableView.dataSource = self
        collectionTableView.delegate = self
        
        forCollections()
        print(colTitleArr)
    }
    
    func forCollections() {
//        onlineteststore7.myshopify.com
//        fcdf9a4be5da8f9d6ffecaa1aacd48dc
        let client =  Graph.Client(shopDomain: "onlineteststore7.myshopify.com", apiKey: "fcdf9a4be5da8f9d6ffecaa1aacd48dc")
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
                self.colTitleArr.append(i.node.title)
                
                self.colImageArr.append(i.node.image!.url)
            })
        }
        task.resume()
        
    }
    
    
}

extension CollectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colTitleArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let colCell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath) as! CollectionTVC
        
        let titleKey = colTitleArr[indexPath.row]
        colCell.colTitle.text = titleKey
        
        let imageKey = colImageArr[indexPath.row]
        colCell.colmage.setImageFrom(imageKey, placeholder: nil)
        
        return colCell
    }


}

extension CollectionViewController: UITableViewDelegate {

}
