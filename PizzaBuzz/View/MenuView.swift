//
//  MenuView.swift
//  PizzaBuzz
//
//  Created by HaZe on 06/10/2022.
//

import SwiftUI

/// Main view
/// it contains the entire shop with categories, products
/// and the cart
/// 'DataService provide 
struct MenuView: View {
    @StateObject var data : DataService
    @State var selectedCategory: String = ""
    @State var showPizzaMaker = false
    
    var items = [GridItem(.flexible()),
                 GridItem(.flexible()),
                 GridItem(.flexible())]
    
    @ViewBuilder var makeYourOwnPizza : some View {
        Button {
            showPizzaMaker.toggle()
        } label: {
            VStack {
                HStack {
                    Image("pizza-5")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 33, maxHeight: 33)
                }
                Text("Make your own \n pizza")
                    .font(.caption)
                    .bold()
            }
        }
        .accentColor(Color.white)
        .padding()
        .background(
            greenColor
        )
        .clipShape(
            Circle()
        )
        .padding(.trailing,5)
    }
    
    var body: some View {
        
        /// Header
        /// Body
        /// Pizza maker
        VStack {
            /// + program tittle
            /// + cart
            HeaderView(data: data)
            
            /// + promotion slider
            /// + category selection
            /// + products
            VStack(spacing: 20) {
                
                /// Promotions
                PromotionView(data: data)
                
                /// Category selection
                // it changes 'selectedCategory' what causes product gridview redraw
                ScrollView(.horizontal) {
                    HStack {
                        ForEach( data.categories , id:\.self) { category in
                            CategoryView(selectedCategory: $selectedCategory,
                                         category: category)
                        }
                    }
                }
                
                /// Selected category grid view
                ScrollView(.vertical) {
                    LazyVGrid(columns: items) {
                        ForEach(data.products.filter({$0.category == selectedCategory}), id: \.id) { product in
                            ProductCellView(data: data,
                                            product: product)
                            .id(product)
                        }
                    }
                }
                
            }
            .padding()
            .ignoresSafeArea()
            
            /// Pizza maker
            .overlay(
                makeYourOwnPizza,
                alignment: .bottomTrailing
            )
        }
        .sheet(isPresented: $showPizzaMaker) {
            ZStack {
                lightGreenColor
                VStack {
                    Text("Go home and make your own pizza!")
                        .font(.largeTitle)
                        .padding()
                    
                    Button {
                        showPizzaMaker.toggle()
                    } label: {
                        Label("Back", systemImage: "chevron.backward.circle")
                    }
                    .buttonStyle(.borderedProminent)
                    .accentColor(.white)
                    .foregroundColor(greenColor)
                }
            }
            .presentationDetents([.medium])
        }
        
        .onAppear() {
            initVars()
        }
    }
    
    private func initVars() {
        selectedCategory = data.categories.count > 0 ? data.categories[0].id: ""
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(data: DataService())
    }
}
