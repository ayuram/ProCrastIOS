//
//  CardView.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 10/28/20.
//

import SwiftUI

extension View{
    func format() -> AnyView{
        AnyView(self)
    }
    func card(color: Color = .white)-> some View{
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(color.opacity(0.4))
                .shadow(radius: 8)
            self
        }
    }
}
struct CardView: View {
    var view: () -> AnyView
    var color: Color = .white
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(color.opacity(0.4))
                .shadow(radius: 8)
            view()
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(){
            Text("Hello World!")
                .bold()
                .format()
        }
    }
}
