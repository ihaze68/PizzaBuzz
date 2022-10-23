//
//  HeaderView.swift
//  PizzaBuzz
//
//  Created by HaZe on 11/10/2022.
//

import SwiftUI

struct BadgeModifier: ViewModifier {
    var count: Int?
    
    func body(content: Content) -> some View {
        if let count,
           count > 0 {
            content
                .overlay(
                        Text("\(count)")
                            .font(.subheadline)
                            .padding(5)
                            .foregroundColor(Color.white)
                            .background(Color.red)
                            .clipShape(Circle())
                            .offset(x:+10, y: -10)
                )

        } else {
            content
        }
    }
}
/// Header
/// it contains a program title
/// and the bucket with an item counter as a badge
struct HeaderView: View {
    @StateObject var data : DataService
    
    var flags = String(repeating: "🇮🇹 ", count: 30)
    @State private var angle = 25.0
    @State private var toggle = true
    
    var body: some View {
        VStack {
            HStack {
                Text("Pizza Buzz")
                    .font(.title)
                    .bold()
                ZStack {
                    Circle()
                        .strokeBorder()
                        .zIndex(1)
                        .foregroundColor(.red)
                        .padding(2)
                    Circle()
                        .strokeBorder()
                        .foregroundColor(.white)
                        .padding(1)
                    Circle()
                        .strokeBorder()
                        .foregroundColor(.green)
                        //.padding(1)
                    
                    Text("🤌🏼")
                        .font(.title3)
                        .zIndex(2)
                        .padding(3)
                        .rotationEffect(.degrees( toggle ? 0 : 45),anchor: .bottomLeading)
                        .task {
                            withAnimation(.easeInOut(duration: 1).repeatForever()) {
                                toggle.toggle()
                            }
                        }

                }
                .frame(width: 32, height: 32)
                .zIndex(1)

                Spacer()
                
                /// Your bucket
                Button {
                } label: {
                    Image(systemName: "cart")
                }
                .accentColor(greenColor)
                .font(.title2).bold(!data.cart.isEmpty)
                .modifier(BadgeModifier(count: data.cart.products.count))
                .padding(5)
                .padding(.trailing)
            }
            .padding(.leading,3)
            HStack {
                Text( flags )
                    .font(.caption)
                    .fixedSize()
            }
        }
        .background( Color(uiColor: UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)) )
    }
}
struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(data: DataService())
    }
}
