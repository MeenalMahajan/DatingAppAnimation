//
//  DatingView.swift
//  DatingAppAnimation
//
//  Created by Meenal Mahajan on 30/06/25.
//

import SwiftUI

struct DatingView: View {
    
    @GestureState private var dragOffset: CGSize = .zero
    @State private var positionOffset: CGSize = .zero
    @State var activeTab: TabBarItem = .home
    
    @State private var dragProgress: Double = 0
    @State private var items: [CardItem] = [
        "Anna",
        "Cecy",
        "Lily",
        "Kitty",
        "Nicolas",
        "Andrew",
        "Ian",
        "Nick",
        "Max",
        "Lan",
    ]
        .enumerated()
        .map{ index, name in
            CardItem(image: "img\(index + 1)", name: name)
        }
    
    @State private var likedItem: CardItem?
    
    var body: some View {
        
        GeometryReader { geometry in
           
            ZStack {

                
                if items.isEmpty{
                    Button {
                        withAnimation {
                            items = [
                                "Anna",
                                "Cecy",
                                "Lily",
                                "Kitty",
                                "Nicolas",
                                "Andrew",
                                "Ian",
                                "Nick",
                                "Max",
                                "Lan",
                            ]
                                .enumerated()
                                .map{ index, name in
                                    CardItem(image: "img\(index + 1)", name: name)
                                }
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(Color.brightPink)
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .font(.system(.headline, weight: .bold))
                    }

                }
                else{
                    ForEach(Array(items.enumerated().reversed()),id:\.element){ index, item in
                        
                        let imageName = item.image
                        
                        switch index {
                        case 0:
                            ProfileCardView(
                                imageName: imageName,
                                width: geometry.size.width-64,
                                height: (geometry.size.width-100)*16/9)
                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 4)
                            .offset(y: -10 * CGFloat(index))
                            .offset(x: dragOffset.width + positionOffset.width)
                            .offset(y: dragOffset.height + positionOffset.height)
                            .rotationEffect(.degrees(-10 * dragOffset.width / 150.0))
                            .opacity(Double(max(0, 1 - 0.3 * Double(index))))
                            .gesture(
                                DragGesture()
                                    .updating($dragOffset)
                                { value, state, transaction in
                                    state = value.translation
                                }
                                    .onEnded{ value in
                                        
                                        if value.translation.width >= 0.5 * (geometry.size.width - 64) {
                                            // like
                                            // move card to right and updatelist
                                            
                                            positionOffset.width += 400
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                                items.removeFirst()
                                                dragProgress = 0
                                                positionOffset = .zero
                                            }
                                            
                                            like(item)
                                            
                                        }else if value.translation.width <= -0.5 * (geometry.size.width - 64) {
                                            
                                            // reject
                                            // move card to left
                                            positionOffset.width -= 400
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                                items.removeFirst()
                                                dragProgress = 0
                                                positionOffset = .zero
                                            }
                                        }
                                        
                                    }
                            )
                            .animation(.snappy(duration:0.25),value: dragOffset)
                            
                        case 1, 2, 3:
                            
                            ProfileCardView(
                                imageName: imageName,
                                width: geometry.size.width-64,
                                height: (geometry.size.width-100)*16/9)
                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 4)
                            .offset(y: -25 * (Double(index) - dragProgress))
                            .rotationEffect(.degrees(5 * Double(index) - dragProgress))
                            .opacity(Double(max(0, 1 - 0.33 * (Double(index)-dragProgress))))
                            .scaleEffect(
                                x: 1 - (0.05 * CGFloat(index)) + 0.05 * dragProgress,
                                y: 1 - (0.05 * CGFloat(index)) + 0.05 * dragProgress)
                        default:
                            EmptyView()
                            
                        }
                        
                    }
                    
                }
                VStack{
                    Spacer()
                    BottomTabBar()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onChange(of: dragOffset) { oldValue, newValue in
                
                if abs(newValue.width) > abs(oldValue.width) && abs(newValue.height) > abs(oldValue.height){
                    dragProgress = min(1,abs(dragOffset.width + positionOffset.width)/150.0)
                }else{
                    
                    withAnimation(.spring(.snappy(duration:0.25))){
                        dragProgress = min(1,abs(dragOffset.width + positionOffset.width)/150.0)
                    }
                }
            }
        }
        .ignoresSafeArea()
        .fullScreenCover(item: $likedItem) { item in
            MatchedView(likedItem: likedItem ?? CardItem(image: "", name: "")) {
                likedItem = nil
            }
        }
    }
    
    @ViewBuilder
    func BottomTabBar() -> some View{
        
        HStack{
            
            ForEach(TabBarItem.allCases,id: \.self) { tab in
                
                VStack {
                    
                    Image(systemName: tab.imageName)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(activeTab == tab ? .black : .white)
                        .frame(width: 20, height: 20)
                    
                    Text(tab.rawValue)
                        .foregroundStyle(activeTab == tab ? .black : .white)
                        .padding(.horizontal,12)
                        .padding(.vertical,3)
                        .background{
                            if activeTab == tab {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.5))
                            }
                        }
                        .frame(maxWidth: .infinity,alignment: .center)
                    
                }
                .onTapGesture {
                    withAnimation{
                        activeTab = tab
                    }
                }
            }
        }
        .frame(height: 60)
        .padding(.vertical,8)
        .background(
            RoundedRectangle(cornerRadius: 80, style: .continuous)
                .fill(
                    LinearGradient(colors: [.brightPink.opacity(0.5),.darkRed.opacity(0.9)], startPoint: .leading, endPoint: .trailing)
            )
        )
        .padding()
    }
    
    func like(_ item: CardItem){
        likedItem = item
    }
}


enum TabBarItem: String, CaseIterable {
    case home = "Home"
    case profile = "Profile"
    
    var imageName: String {
        switch self {
        case .home:
            return "house"
        case .profile:
            return "person.circle"
        }
    }
}

struct CardItem: Identifiable,Hashable {
    var id: UUID = UUID()
    var image: String
    var name: String
}

#Preview {
    DatingView()
}
