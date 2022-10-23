//
//  ProductView.swift
//  PizzaBuzz
//
//  Created by HaZe on 11/10/2022.
//

import SwiftUI


struct ProductView: View {
    @State var product: Product
    var body: some View {
        VStack {
            Image(product.image ?? "")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text(product.name)
            if let ingredients = product.ingredients {
                Text(ingredients)
            }
        }
    }
}

struct ProductCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                // grayColor
                Color.white
            )
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray, lineWidth: 0.5)
            )
            .padding(1)
    }
}

struct ProductCellView: View {
    @StateObject var data : DataService
    @State var product: Product
    @State var showProductInfo = false
    @State var redaction = false
    
    private let h : CGFloat = 190.0
    
    var body: some View {
        
        GeometryReader { geometry in
                VStack(alignment: .leading) {
                    
                    // image
                    ZStack {
                        if let image = product.image {
                            let img = UIImage(imageLiteralResourceName: image)
                            if let transparentImg = makeTransparent(image: img) {
                                Image(uiImage: transparentImg)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } else {
                                Image(image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                    }
                    .padding(4)
                    .frame(width: geometry.size.width, height: geometry.size.height / 2)
                    
                    // details + add button
                    ZStack {
                        VStack {
                            Text(product.name)
                                .font(.subheadline)
                                .bold()
                                .padding(.top,2)

                            if let ingredients = product.ingredients {
                                Text(ingredients)
                                    .font(.caption)
                            }

                            Spacer()

                            HStack {
                                Spacer()
                                Button {
                                    withAnimation(.spring()) {
                                        if data.productInCart(product: product) {
                                            data.removeProductFromCart(product: product)
                                        } else {
                                            data.addProductToCart(product: product)
                                        }
                                    }
                                } label: {
                                    Image(systemName: data.productInCart(product: product) ? "minus.circle" : "plus.circle")
                                        .font(.title)
                                        .symbolRenderingMode(.hierarchical)
                                        .accentColor(data.productInCart(product: product) ? .red : greenColor)
                                }
                                .background(.white)
                                .clipShape(Circle())

                                Spacer()
                            }
                            Spacer()
                        }
                    }
                    .background(Color.yellow)
                    .frame(width: geometry.size.width, height: geometry.size.height / 2)
                    
                }
                Spacer()
        }
        .frame(height:h)
        .modifier(
            ProductCardModifier()
        )
        .onTapGesture {
            showProductInfo.toggle()
        }
        .popover(isPresented: $showProductInfo) {
            ProductView(product: product)
        }
    }
    
    // https://stackoverflow.com/a/63594211/689964    
    func makeTransparent(image: UIImage) -> UIImage? {
        guard let rawImage = image.cgImage else { return nil}
        let colorMasking: [CGFloat] = [200, 255, 200, 255, 255, 255]
        UIGraphicsBeginImageContext(image.size)
        
        if let maskedImage = rawImage.copy(maskingColorComponents: colorMasking),
            let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: 0.0, y: image.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.draw(maskedImage, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return finalImage
        }
        
        return nil
    }
}

let demoPizza = Product(id: "id1", name: "Pizza Picante", category: "pizza", image: "pizza-1", ingredients: "Salt, Tomate, Onion", finished: true, prices: [
    Price(id: "id1", size: "S", price: 6.9),
    Price(id: "id2", size: "M", price: 8.9),
    Price(id: "id3", size: "L", price: 11.9),
])

struct ProductCellView_Previews: PreviewProvider {
    static var previews: some View {
        let data = DataService()
        let items = [GridItem(.flexible()),
                     GridItem(.flexible()),
                     GridItem(.flexible())]
        VStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: items) {
                    ForEach(data.products.filter({$0.category == "id1"}), id: \.id) { product in
                        ProductCellView(data: DataService(),
                                        product: product)
                            .id(product)
                    }
                }
            }
            .padding()
        }
    }
}
