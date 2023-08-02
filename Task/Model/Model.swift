//
//  Model.swift
//  Task
//
//  Created by DineshM on 27/07/23.
//

import Foundation

struct ProductDetails: Codable {
    var products: [Product]?
}
struct Product: Codable {
    var id: Int?
    var title: String?
    var description: String?
    var price: Int?
    var discountPercentage: Double?
    var rating: Double?
    var stock: Int?
    var brand: String?
    var category: String?
    var thumbnail: String?
    var images: [String]?
}


