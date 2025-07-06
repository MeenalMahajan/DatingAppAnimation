//
//  DatingView.swift
//  DatingAppAnimation
//
//  Created by Meenal Mahajan on 30/06/25.
//

import SwiftUI

struct DatingView: View {
    
    @GestureState private var dragOffset: CGSize = .zero
    var body: some View {
      
        ZStack {
            ForEach(0...9,id: \.self){ i in
                
                let imageName = "img\(i+1)"
                
                switch i {
                case 9:
                    ProfileCardView(imageName: imageName, width: 300, height: 533.3)
                        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 4)
                        .offset(y: -10 * CGFloat(9-i))
                        .offset(x: dragOffset.width,y: dragOffset.height)
                        .rotationEffect(.degrees(-10 * dragOffset.width / 150.0))
                        .opacity(Double(max(0, 1 - 0.3 * Double(6-i))))
                        .gesture(
                            DragGesture()
                                .updating($dragOffset) { value, state, transaction in
                                    state = value.translation
                            }
                        )
                        .animation(.snappy(duration:0.25),value: dragOffset)
                default:
                    
                    ProfileCardView(imageName: imageName, width: 300, height: 533.3)
                        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 4)
                        .offset(y: -10 * CGFloat(9-i))
                        .rotationEffect(.degrees(1 * Double(9-i)))
                        .opacity(Double(max(0, 1 - 0.3 * Double(6-i))))
                      
                }
                
            }
        }


    }
}

#Preview {
    DatingView()
}
