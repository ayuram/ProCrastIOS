//
//  ThemedButton.swift
//  ProCrast
//
//  Created by Ayush Raman on 10/23/20.
//  Copyright © 2020 Answer Key. All rights reserved.
//

import SwiftUI

struct ThemedButton: View {
    var text: String = "Button"
    var buttonColor: Color = Color("accent")
    var textColor: Color = Color.white
    var width: CGFloat = 90
    var height: CGFloat = 55
    var action: () -> Void
    
    var body: some View {
       
            
            Button(action: action) {
                Text(text).font(.system(size: 14))
                    //.font(.system(.headline, design: .rounded))
                    
                    .font(.system(.headline))
                    .fontWeight(.bold)
                    .foregroundColor(textColor)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: width, height: height)
            }
            .background(buttonColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
                //.overlay(Capsule().stroke(Color.black, lineWidth: 1.0))
                .shadow(radius: 5.0)
                
            
        
    }
}

struct ThemedButton_Previews: PreviewProvider {
    static var previews: some View {
        ThemedButton(text: "Hello"){}
    }
}
