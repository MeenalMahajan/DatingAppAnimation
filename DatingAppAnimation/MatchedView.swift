//
//  MatchedView.swift
//  DatingAppAnimation
//
//  Created by Meenal Mahajan on 06/07/25.
//

import SwiftUI
import Vortex

struct MatchedView: View {
    
    @State private var isActive = false
    @State private var isHeartActive = false
    @State private var vortexId = UUID()
    
    let likedItem: CardItem
    let dismiss: () -> Void
    
    var body: some View {
        ZStack{
            
           Color.lightPink
                .ignoresSafeArea()
            
            RadialGradient(
                colors: [.brightPink.opacity(0.5),.darkRed],
                center: .topLeading,
                startRadius: 100,
                endRadius: 700)
            .ignoresSafeArea()
            
            VortexView(createHeartBubble()){
                Circle()
                    .fill(.clear)
                    .tag("circle")
                    .overlay {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36)
                            .foregroundStyle(.brightPink)
                            .blur(radius: 5)
                            .opacity(0.5)
                    }
            }
            .id(vortexId)
            .ignoresSafeArea()
            
            
            VStack {
                
                Spacer()
                ZStack{
                    ProfileCardView(imageName: "img2", width: 120, height: 120)
                        .shadow(color: Color.white.opacity(0.3), radius: 4, x: 0, y: 4)
                        .offset(x:isActive ? -50 : -100)
                        .offset(y:isActive ? 0 : -30)
                        .scaleEffect(
                            x: isActive ? 1.0 : 1.1,
                            y: isActive ? 1.0 : 1.1)
                        .rotationEffect(.degrees(isActive ? -10 : -35))
                        .opacity(isActive ? 1 : 0)
                    
                    ProfileCardView(imageName: likedItem.image, width: 120, height: 160)
                        .shadow(color: Color.white.opacity(0.3), radius: 4, x: 0, y: 4)
                        .offset(x:isActive ? 70 : 110)
                        .offset(y:isActive ? 0 : -30)
                        .scaleEffect(
                            x: isActive ? 1.0 : 1.1,
                            y: isActive ? 1.0 : 1.1)
                        .rotationEffect(.degrees(isActive ? 20 : 60))
                        .opacity(isActive ? 1 : 0)
                    
                    Image(systemName: "heart.circle.fill")
                        .resizable()
                        .frame(width: 64, height: 64)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white,.brightPink)
                        .scaleEffect(
                            x: isHeartActive ? 1.0 : 0,
                            y: isHeartActive ? 1.0 : 0)
                        .offset(y: 50)
                }
                .padding(.bottom,32)
                
                Text("It's a match!")
                    .font(.system(size: 36,weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.bottom,4)
                    .opacity(isActive ? 1 : 0)
                    .offset(y:isActive ? 0 : 10)
                
                Text("You and \(likedItem.name) has liked each other.")
                    .font(.system(size: 16,weight: .bold, design: .default))
                    .foregroundStyle(.white)
                    .padding(.bottom,4)
                    .opacity(isActive ? 1 : 0)
                    .offset(y:isActive ? 0 : 10)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Capsule()
                        .frame(height: 60)
                        .foregroundStyle(.brightPink)
                        .padding(.horizontal)
                        .overlay {
                            Text("Send a Message")
                                .font(.system(size: 18,weight: .bold, design: .default))
                                .foregroundStyle(.white)
                                .padding(.bottom,4)
                        }
                        .opacity(isActive ? 1 : 0)
                        .offset(y:isActive ? 0 : 10)
                }
                
                Button {
                    dismiss()
                } label: {
                    Capsule()
                        .frame(height: 60)
                        .foregroundStyle(.ultraThinMaterial.opacity(0.5))
                        .padding(.horizontal)
                        .overlay {
                            Text("Keep Matching")
                                .font(.system(size: 18,weight: .medium, design: .default))
                                .foregroundStyle(.white)
                                .padding(.bottom,4)
                        }
                        .opacity(isActive ? 1 : 0)
                        .offset(y:isActive ? 0 : 10)
                }

            }
        }
        .onDisappear{
            isActive = false
            isHeartActive = false
        }
        .onAppear {
            
            vortexId = UUID()
            withAnimation(.spring(.smooth(duration: 1))){
                isActive.toggle()
            }
            
            withAnimation(.spring(.bouncy(duration: 1,extraBounce: 0.3))){
                isHeartActive.toggle()
            }
        }
       
    }
    
    func createHeartBubble() -> VortexSystem {
        
        let system: VortexSystem = .snow
        system.position = [0.5,1]
        system.angle = .degrees(0)
        system.emissionLimit = .none
        
        return system
    }
}

#Preview {
    MatchedView(likedItem: CardItem(image: "", name: "")){
        
    }
}
