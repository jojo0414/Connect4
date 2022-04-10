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
    @State private var color0 = Color.pink
    @State private var color1 = Color.orange
    @State private var player1Name = "player1"
    @State private var player2Name = "player2"
    var body: some View
    {
        NavigationView{
            VStack{
                Image("connect4Title")
                    .resizable()
                    .scaledToFit()
                    .padding()
                NavigationLink {
                    GameView(playerData: $playerData, gameMode: 0)
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
                NavigationLink{
                    GameView(playerData: $playerData, gameMode: 1)
                } label: {
                    HStack{
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .padding()
                        Text("V.S.")
                            .font(.title)
                        Image(systemName: "desktopcomputer")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 40)
                            .padding()
                    }
                    .frame(width: 200, height: 80)
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(30)
                }
            }
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
            .sheet(isPresented: $showSheet, content: {
                VStack(alignment: .leading){
                    HStack{
                        Text("請幫玩家一命名")
                        TextField("玩家一的名字", text: $player1Name)
                            .onChange(of: player1Name) { newValue in
                                playerData[0].name = newValue
                            }
                    }
                    .padding()
                    HStack{
                        Text("請幫玩家二命名")
                        TextField("玩家二的名字", text: $player2Name)
                            .onChange(of: player2Name) { newValue in
                                playerData[1].name = newValue
                            }
                    }
                    .padding()
                    ColorPicker("選擇\(playerData[0].name)所使用的顏色", selection: $color0)
                        .padding()
                        .onChange(of: color0) { newValue in
                            print("\(playerData[0].name)更改顏色")
                            playerData[0].color = newValue
                        }
                    ColorPicker("選擇\(playerData[1].name)所使用的顏色", selection: $color1)
                        .padding()
                        .onChange(of: color1) { newValue in
                            print("\(playerData[1].name)更改顏色")
                            playerData[1].color = newValue
                        }
                }
            })
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
