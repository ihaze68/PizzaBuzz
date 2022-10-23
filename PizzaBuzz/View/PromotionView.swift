//
//  PromotionView.swift
//  PizzaBuzz
//
//  Created by HaZe on 10/10/2022.
//

import SwiftUI

/// Promotions
/// Infinity scorlling through the promotions

// https://picsum.photos/id/.../200/300
// useful image id's, 326, 429, 30, 488, 635, 766, 802

struct PromotionDetailView: View {
    @State var promotion: Promotion
    var body: some View {
        VStack {
            Text(promotion.name)
                .font(.title)
            Text(promotion.offer ?? "no offer")
                .font(.title)
        }
    }
}

struct PromotionCellView: View {
    @State var promotion: Promotion
    @Binding var showOffer: Bool
    
    var body: some View {
        ZStack {
            if let image = promotion.image,
               !image.isEmpty {
                
                AsyncImage(url: URL(string: image), content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }, placeholder: {
                    ProgressView()
                })
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Text(promotion.name)
                .font(.title)
                .bold()
                .blendMode(.destinationOut)
        }
        .compositingGroup()
        .frame(idealWidth: .infinity)
        
        .onTapGesture {
            showOffer.toggle()
        }
        
        .sheet(isPresented: $showOffer) {
            PromotionDetailView(promotion: promotion)
        }
    }
}

struct PromotionView: View {
    @StateObject var data : DataService
    @State var promotion: Promotion?

    @State var showOffer = false
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack(alignment: .center) {
            if let promotion {
                PromotionCellView(promotion: promotion,
                                  showOffer: $showOffer)
                    .id(promotion)
                    .transition(.slide)
            }
            Spacer()
        }
        .frame(height:120)
        
        .onAppear() {
            promotion = nextPromotion()
        }

        .onReceive(timer) { _ in
            if !showOffer {
                withAnimation {
                    promotion = nextPromotion()
                }
            }
        }
    }
    
    func nextPromotion() -> Promotion? {
        return data.promotions.randomElement()
    }
}

struct PromotionView_Previews: PreviewProvider {
    static var previews: some View {
        PromotionView(data: DataService())
    }
}
