//
//  ProfileCardView.swift
//  DatingAppAnimation
//
//  Created by Meenal Mahajan on 30/06/25.
//

import SwiftUI

struct ProfileCardView: View {
    
    
    let imageName: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
       Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: width,height: height)
            .clipShape(RoundedRectangle(cornerRadius: 32))
    }
}

#Preview {
    ProfileCardView(imageName: "img1", width: 300, height: 533)
}
