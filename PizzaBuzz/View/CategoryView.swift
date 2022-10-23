//
//  CategoryView.swift
//  PizzaBuzz
//
//  Created by HaZe on 11/10/2022.
//

import SwiftUI

struct CategoryView: View {
    @Binding var selectedCategory: String
    @State var category: Category
    private let w : CGFloat = 140.0
    private let h : CGFloat = 45.0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(selectedCategory == category.id ?  .red : .white)
                .frame(maxWidth: w, maxHeight: h)
            RoundedRectangle(cornerRadius: 14)
                .foregroundColor(selectedCategory == category.id ? .white : .white)
                .frame(maxWidth: w - 6, maxHeight: h - 6)
            RoundedRectangle(cornerRadius: 18)
                .foregroundColor(selectedCategory == category.id ?  .green : .white)
                .frame(maxWidth: w - 10, maxHeight: h - 10)
            Button {
                withAnimation(.default) {
                    selectedCategory = category.id
                }
            } label: {
                ZStack {
                    Text(category.name)
                        .font(.title2)
                        .bold()
                        .foregroundColor( selectedCategory == category.id ?  .white : .black )
                        .blendMode(.overlay)
                }
                .compositingGroup()
            }
            .padding()
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(selectedCategory: .constant("pizza"), category: Category(id:"pizza",name: "Pizza"))
    }
}
