//
//  HomeView.swift
//  Landmark ID
//
//  Created by Peter Chambers on 27/11/2020.
//  Copyright © 2020 Pete Chambers. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewRouter = ViewRouter()
    
    @State var showPopUp = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                if self.viewRouter.currentView == "home" {
                    Text("Home")
                } else if self.viewRouter.currentView == "history" {
                    Text("History")
                }
                Spacer()
                ZStack {
                    if self.showPopUp {
                       PlusMenu()
                        .offset(y: -geometry.size.height/6)
                    }
                    HStack {
                        Image(systemName: self.viewRouter.currentView == "home" ? "house.fill" : "house")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.init(top: 15, leading: 15, bottom: 25, trailing: 15))
                            .frame(width: geometry.size.width/3, height: 75)
                            .foregroundColor(self.viewRouter.currentView == "home" ? .black : .gray)
                            .onTapGesture {
                                self.viewRouter.currentView = "home"
                            }
                        ZStack {
                            Circle()
                                .shadow(radius: 5)
                                .foregroundColor(Color.white)
                                .frame(width: 75, height: 75)
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75, height: 75)
                                .foregroundColor(.purple)
                                .rotationEffect(Angle(degrees: self.showPopUp ? 90 : 0))
                        }
                            .offset(y: -geometry.size.height/10/2)
                            .onTapGesture {
                                withAnimation {
                                   self.showPopUp.toggle()
                                }
                            }
                        Image(systemName: self.viewRouter.currentView == "history" ? "clock.fill" : "clock")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.init(top: 15, leading: 15, bottom: 25, trailing: 15))
                            .frame(width: geometry.size.width/3, height: 75)
                            .foregroundColor(self.viewRouter.currentView == "history" ? .black : .gray)
                            .onTapGesture {
                                self.viewRouter.currentView = "history"
                            }
                    }
                        .frame(width: geometry.size.width, height: geometry.size.height/10)
                    .background(Color.white.shadow(radius: 2))
                }
            }.edgesIgnoringSafeArea(.bottom)
        }.background(Color(UIColor.lightGray))
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PlusMenu: View {
    var body: some View {
        HStack(spacing: 50) {
            ZStack {
                Circle()
                    .shadow(radius: 5)
                    .foregroundColor(Color.purple)
                    .frame(width: 70, height: 70)
                Image(systemName: "camera")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(20)
                    .frame(width: 70, height: 70)
                    .foregroundColor(.white)
            }
            ZStack {
                Circle()
                    .shadow(radius: 5)
                    .foregroundColor(Color.purple)
                    .frame(width: 70, height: 70)
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(20)
                    .frame(width: 70, height: 70)
                    .foregroundColor(.white)
            }
        }
            .transition(.scale)
    }
}
