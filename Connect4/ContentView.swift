//
//  ContentView.swift
//  Connect4
//
//  Created by 陳昕喬 on 2022/4/6.
//

import SwiftUI

struct ContentView: View {
    @State private var playerData: [PlayerData] = [PlayerData(name: "Player1", color: .pink), PlayerData(name: "Player2", color: .orange)]
    @State private var showGameView = false
    @State private var showSheet = false
    var body: some View
    {
        NavigationView{
            VStack{
                Image("connect4Title")
                    .resizable()
                    .scaledToFit()
                    .padding()
                NavigationLink {
                    GameView(playerData: $playerData)
                } label: {
                    HStack{
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .padding()
                        Text("V.S.")
                            .font(.title)
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                    .frame(width: 200, height: 80)
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(30)
                }
            }
            .sheet(isPresented: $showSheet, content: {
                
            })
            .toolbar {
                ToolbarItem{
                    Button {
                        showSheet = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.black)
                    }

                }
            }
        }
    }
}

struct TestView: View {
    var body: some View {
        VStack{
            Image("TakoYaki1")
                .resizable()
                .hueRotation(Angle(degrees: 30))
            
            
            Image("TakoYaki1")
                .resizable()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

