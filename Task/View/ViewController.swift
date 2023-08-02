//
//  ViewController.swift
//  Task
//
//  Created by DineshM on 27/07/23.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    //MARK: Constants
    let apiResponse = ApiIntegration()
    var jsonValue: ProductDetails?
    var index = 0
    var count = 0
    var swipe = ""
    
    //Mark: Outlets
    @IBOutlet weak var productsTableview: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCall()
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        productsTableview.isHidden = true
        if internet == false {
            let alert = UIAlertController(title: "No Internet!", message: "Please check your internet connection and try again.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default))
            self.present(alert, animated: true)
        }
        // Do any additional setup after loading the view.
    }
    
    //MARK: Apicall
    func apiCall() {
        apiResponse.getApi(urlString: urlConstants.url, oncompletion: { (result) in
            self.jsonValue = result
            DispatchQueue.main.async {
                self.productsTableview.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.productsTableview.isHidden = false
            }
        }, onerror: {
            (error) in
            self.apiCall()
        })
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    //Mark: DatasourceMethods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (jsonValue?.products?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productsTableview.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath) as! ProductsTableViewCell
        cell.selectionStyle = .none
        cell.titleLabel.text = jsonValue?.products?[indexPath.row].title ?? ""
        cell.descriptionLabel.text = jsonValue?.products?[indexPath.row].description ?? ""
        let price = jsonValue?.products?[indexPath.row].price
        cell.priceLabel.text = "Price: \(price ?? 0)"
        let discount = jsonValue?.products?[indexPath.row].discountPercentage
        cell.discountLabel.text =  "Discount: \(discount ?? 0.0)%"
        let rating = jsonValue?.products?[indexPath.row].rating
        cell.ratingLabel.text = "Rating: \(rating ?? 0.0)"
        let stock = jsonValue?.products?[indexPath.row].stock
        cell.stockLabel.text =  "Stock Left: \(stock ?? 0)"
        cell.brandLabel.text = jsonValue?.products?[indexPath.row].brand ?? ""
        cell.categoryLabel.text = jsonValue?.products?[indexPath.row].category ?? ""
        let thumbnail = jsonValue?.products?[indexPath.row].thumbnail
        cell.productImage.sd_setImage(with: URL(string: thumbnail ?? ""), placeholderImage: UIImage(named: "placeholder.png"))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        cell.productImage.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        cell.productImage.addGestureRecognizer(swipeLeft)
        cell.productImage.isUserInteractionEnabled = true
        
        return cell
    }
    
    //MARK: DelegateMethods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        productsTableview.reloadData()
        index = indexPath[1]
        count = 0
        swipe = ""
    }
    //
    //MARK: SwipeGestureMethod
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            let indexpath = IndexPath(row: index, section: 0)
            var imageArray = jsonValue?.products?[indexpath.row].images
            let thumbnail = jsonValue?.products?[indexpath.row].thumbnail
            
            switch swipeGesture.direction {
            case .right:
                
                if let cell = self.productsTableview.cellForRow(at: indexpath) as? ProductsTableViewCell {
                    if ((imageArray?.count) != nil) {
                        if count > imageArray?.count ?? 0 {
                            count = (imageArray?.count ?? 0) - 1
                        }
                    }
                    if swipe == "left" {
                        count = count - 2
                        
                    }else {
                        count = count - 1
                        
                    }
                    
                    print(count)
                    if count < 0 {
                        cell.productImage.sd_setImage(with: URL(string: thumbnail ?? ""), placeholderImage: UIImage(named: "placeholder.png"))
                        count += 1
                        
                    }else {
                        cell.productImage.sd_setImage(with: URL(string: jsonValue?.products?[indexpath.row].images?[count] ?? ""), placeholderImage: UIImage(named: "placeholder.png"))
                        
                    }
                }
                print("Swiped right")
                swipe = "right"
                
            case .left:
                print("Swiped left")
                if let cell = self.productsTableview.cellForRow(at: indexpath) as? ProductsTableViewCell {
                    if cell.productImage.image == UIImage(named: jsonValue?.products?[indexpath.row].thumbnail ?? "") {
                        count += 1
                        cell.productImage.image = UIImage(named: jsonValue?.products?[indexpath.row].images?[count] ?? "")
                    } else {
                        if count == imageArray?.count {
                            
                        } else {
                            cell.productImage.sd_setImage(with: URL(string: jsonValue?.products?[indexpath.row].images?[count] ?? ""), placeholderImage: UIImage(named: "placeholder.png"))
                            count += 1
                            print(count)
                        }
                    }
                }
                swipe = "left"
                
            default:
                break
            }
        }
    }
    
}

