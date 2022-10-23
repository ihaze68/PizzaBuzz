//
//  DataService.swift
//  PizzaBuzz
//
//  Created by HaZe on 08/10/2022.
//

import Foundation



struct Top: Decodable, Hashable {
    let id: String
    let name: String
    let price: Double?
}

struct Category: Decodable, Hashable {
    let id: String
    let name: String
}

struct Price: Decodable, Hashable, Identifiable {
    let id: String
    let size: String
    let price: Double
}

struct Product: Decodable, Hashable {
    let id: String
    let name: String
    let category: String?
    let image: String?
    let ingredients: String?
    let finished: Bool
    let prices: [Price]
    
    var selectedPrice: Price? = nil
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case image = "img"
        case ingredients
        case finished
        case prices
    }
}

struct Promotion: Decodable, Hashable {
    let id: String
    let name: String
    let image: String?
    let offer: String?
    let product: String?
    let specialPrice: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image = "img"
        case offer
        case product
        case specialPrice
    }
}

typealias Tops = [Top]
typealias Categories = [Category]
typealias Products = [Product]
typealias Promotions = [Promotion]

struct ProductData: Decodable {
    var promotions: Promotions = []
    var categories: Categories = []
    var products: Products = []
    var tops: Tops = []
}

struct Item {
    var product: Product?
    var top: Top?
}

struct Cart {
    var products: Products = []
    var total: Double = 0.0
    
    var isEmpty: Bool {
        products.isEmpty
    }
}

class DataService: ObservableObject {
    @Published var promotions: Promotions = []
    @Published var categories: Categories = []
    @Published var tops : Tops = []
    @Published var products: Products = []
    @Published var makeOwnProducts: Products = []
    @Published var cart = Cart()
    
    private let json = "PizzaData"
    
    init() {
        LoadDataFromJSON()
    }
    
    private func LoadDataFromJSON() {
        guard let path = Bundle.main.path(forResource: json, ofType: "json") else {
            return
        }
        
        guard let jsonData = try? String(contentsOfFile: path).data(using: .utf8) else {
            return
        }
        
        do {
            let decodedData = try JSONDecoder().decode(ProductData.self, from: jsonData)
            
            promotions = decodedData.promotions
            categories = decodedData.categories
            products = decodedData.products.filter({$0.finished})
            makeOwnProducts = decodedData.products.filter({!$0.finished})
            tops = decodedData.tops
            
        } catch {
            print("error:\(error)")
        }
    }
    
    func addProductToCart(product: Product) {
        cart.products.append(product)
    }
        
    func productInCart(product: Product) -> Bool {
        cart.products.first(where: {$0.id == product.id}) != nil
    }
    
    func removeProductFromCart( product: Product ) {
         cart.products.removeAll(where: {$0.id == product.id})
    }

    
}
