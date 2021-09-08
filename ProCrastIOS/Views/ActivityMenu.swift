//
//  ActivityMenu.swift
//  ProCrast
//
//  Created by Ayush Raman on 10/23/20.
//  Copyright © 2020 Answer Key. All rights reserved.
//

import SwiftUI
import Combine

enum WhichSheet {
    case book, generic
}
struct ActivityMenu: View {
    @State public var show = false
    @State var type = WhichSheet.book
    @State var acSheet = false
    @EnvironmentObject var activities: Model
    @State var actname: String = ""
    var body: some View {
        ZStack{
            NavigationView {
                List{
                    ForEach(activities.activities) { activity in
                        ActivityNav(activity)
                            .listRowBackground(activity.color)
                    }.onDelete(perform: deleteItems)
                }
                .navigationBarTitle("Activities")
                .navigationBarItems(trailing: Button(action: {
                    self.acSheet.toggle()
                }){
                    Image(systemName: "plus.circle.fill")
                    }
                
                .contentShape(Circle())
                )
                .accentColor(Color("accent"))
            }.sheet(isPresented: $show){
                type == .generic ? AnyView(newAct()) : AnyView(newTextBook())
            }
            .actionSheet(isPresented: $acSheet){
                ActionSheet(title: Text("Choose Activity Type"), buttons: [
                    .default(Text("Generic").foregroundColor(.red)) { self.show.toggle()
                        type = .generic
                    },
                    .default(Text("Textbook")) { self.show.toggle()
                        type = .book
                    },
                    .cancel()
                ])
            }
        }
    }
    func deleteItems(at offsets: IndexSet){
        activities.activities.remove(atOffsets: offsets)
    }
    func newAct() -> some View{
        NavigationView{
            VStack {
                TextField("Activity Name", text: $actname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
            }
            .navigationBarTitle("Add Activity")
            .navigationBarItems(leading: Button("Cancel"){
                self.actname = ""
                self.show = false
            },trailing: Button("Save"){
                self.activities.activities.append(Activity(self.actname))
                self.actname = ""
                self.show = false
            })
            
        }
    }
    @State var ISBN = ""
    func newTextBook() -> some View{
        NavigationView{
            VStack {
                HStack{
                    TextField("Course Name", text: $actname)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                    TextField("ISBN-13", text: $ISBN)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .onReceive(Just(ISBN), perform: { newValue in
                            let filtered = newValue.filter {"0123456789".contains($0)}
                            ISBN = filtered != newValue ? filtered : ISBN
                        })
                }
            }
            .navigationBarTitle("Add Course")
            .navigationBarItems(leading: Button("Cancel"){
                self.actname = ""
                self.ISBN = ""
                self.show = false
            },trailing: Button("Save"){
                let act = Activity(actname)
                act.textbook = Textbook(id: ISBN, pages: .none)
                activities.activities.append(act)
                self.actname = ""
                self.ISBN = ""
                self.show = false
            })
            
        }
    }
}

struct ActivityMenu_Previews: PreviewProvider {
    static var previews: some View {
        ActivityMenu()
            .environmentObject(Model())
    }
}
