//
//  GameView.swift
//  Connect4
//
//  Created by 陳昕喬 on 2022/4/6.
//

import SwiftUI

private var emptyIndex = [35, 36, 37, 38, 39, 40, 41]

struct GameView: View {
    @State private var nowPlayingIndex = 0
    @State private var circles: [CircleType] = [CircleType](repeating: CircleType(), count: 42)
    @State private var showWinAlert = false
    @State private var showDrawAlert = false
    @Binding var playerData: [PlayerData]
    var gameMode: Int
    
    var body: some View {
//        NavigationView{
            ZStack{
                ChessBoardView(showWinAlert: $showWinAlert, showDrawAlert: $showDrawAlert, nowPlayingIndex: $nowPlayingIndex, playerData: $playerData, circles: $circles, gameMode: gameMode)
                    .offset(x: 0, y: -70)
                PlayerView(nowPlayingIndex: $nowPlayingIndex, playerData: $playerData)
                    .offset(x: 0, y: 150)
                Text("\(playerData[nowPlayingIndex].name) 正在思考中...")
                    .font(.title)
                    .offset(x: 0, y: -250)

            }
            .toolbar(content: {
                ToolbarItem{
                    Button {
                        print("button pressed")
                        // 重新開始遊戲
                        nowPlayingIndex = 0
                        playerData = [PlayerData(name: playerData[0].name, color: playerData[0].color, useChess: 0, ownPlaceIndex: [Bool](repeating: false, count: 42), history: playerData[0].history), PlayerData(name: playerData[1].name, color: playerData[1].color, useChess: 0, ownPlaceIndex: [Bool](repeating: false, count: 42), history: playerData[1].history)]
                        circles = [CircleType](repeating: CircleType(), count: 42)
                        emptyIndex = [35, 36, 37, 38, 39, 40, 41]
                    } label: {
                        Image(systemName: "goforward")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .scaledToFit()
                    }
                }
            })
            .padding()
            .alert("\(playerData[(nowPlayingIndex + 1) % 2].name) 贏得了這場遊戲，要再來一局嗎？", isPresented: $showWinAlert, actions: {
                Button("YES") {
                    playerData[nowPlayingIndex].history[1] += 1
                    playerData[(nowPlayingIndex + 1) % 2].history[0] += 1

                    // 重新開始遊戲
                    nowPlayingIndex = 0
                    playerData = [PlayerData(name: playerData[0].name, color: playerData[0].color, useChess: 0, ownPlaceIndex: [Bool](repeating: false, count: 42), history: playerData[0].history), PlayerData(name: playerData[1].name, color: playerData[1].color, useChess: 0, ownPlaceIndex: [Bool](repeating: false, count: 42), history: playerData[1].history)]
                    circles = [CircleType](repeating: CircleType(), count: 42)
                    emptyIndex = [35, 36, 37, 38, 39, 40, 41]
                }
                Button("No")
                {
                    playerData[nowPlayingIndex].history[1] += 1
                    playerData[(nowPlayingIndex + 1) % 2].history[0] += 1

                    //挑回選單

                }
            })
            .alert("平手，再來一局嗎？", isPresented: $showDrawAlert, actions: {
                Button("YES") {
                    playerData[0].history[2] += 1
                    playerData[1].history[2] += 1
                    
                    // 重新開始遊戲
                    nowPlayingIndex = 0
                    playerData = [PlayerData(name: playerData[0].name, color: playerData[0].color, useChess: 0, ownPlaceIndex: [Bool](repeating: false, count: 42), history: playerData[0].history), PlayerData(name: playerData[1].name, color: playerData[1].color, useChess: 0, ownPlaceIndex: [Bool](repeating: false, count: 42), history: playerData[1].history)]
                    circles = [CircleType](repeating: CircleType(), count: 42)
                    emptyIndex = [35, 36, 37, 38, 39, 40, 41]
                }
                Button("NO")
                {
                    playerData[0].history[2] += 1
                    playerData[1].history[2] += 1
                    
                    //跳回選單
                }
            })
        }
//    }
}

struct PlayerView: View {
    @Binding var nowPlayingIndex: Int
    @Binding var playerData: [PlayerData]
    var body: some View {
        HStack{
            VStack{
                Circle()
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundColor(playerData[0].color)
                    .frame(width: 50)
                VStack(alignment: .leading){
                    Text("\(playerData[0].name)")
                        .font(.title2)
                    Text("剩下：\(21 - playerData[0].useChess)")
                        .font(.title3)
                    Text("\(playerData[0].history[0])：\(playerData[0].history[1])：\(playerData[0].history[2])")
                        .font(.title3)
                }
                .scaledToFill()
            }
            .padding()
            Text("VS")
                .font(.title)
            VStack {
                Circle()
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundColor(playerData[1].color)
                    .frame(width: 50)
                VStack(alignment: .trailing) {
                    Text("\(playerData[1].name)")
                        .font(.title2)
                    Text("剩下：\(21 - playerData[1].useChess)")
                        .font(.title3)
                    Text("\(playerData[1].history[0])：\(playerData[1].history[1])：\(playerData[1].history[2])")
                        .font(.title3)
                }
                .scaledToFill()
            }
            .padding()
        }
    }
}

struct ChessBoardView: View {
    @State private var showFullAlert = false
    @Binding var showWinAlert: Bool
    @Binding var showDrawAlert: Bool
    @Binding var nowPlayingIndex: Int
    @Binding var playerData: [PlayerData]
    @Binding var circles: [CircleType]
    var gameMode: Int
    
    var body: some View {
        VStack {
            let columns = Array(repeating: GridItem(spacing: 0), count: 7)
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(0..<42) { index in
                    ZStack{
                        CircleView(circles: $circles, index: index)
                        MaskView()
                    }
                    .onTapGesture {
                        let actualChessIndex = calcChessPlace(index: index)
                        if actualChessIndex < 0
                        {
                            showFullAlert = true
                        }
                        else{
                            circles[actualChessIndex].ownerIndex = nowPlayingIndex
                            circles[actualChessIndex].color = playerData[nowPlayingIndex].color
                            playerData[nowPlayingIndex].useChess += 1
                            playerData[nowPlayingIndex].ownPlaceIndex[actualChessIndex] = true
                            if nowPlayingIndex == 1 && playerData[nowPlayingIndex].useChess == 21
                            {
                                showDrawAlert = true
                            }
                            let lineChess = checkWin(ownPlaceIndex: playerData[nowPlayingIndex].ownPlaceIndex)
                            if lineChess[0] != -1
                            {
                                for i in lineChess
                                {
                                    circles[i].color = Color.black
                                }
                                showWinAlert = true
                            }
                            nowPlayingIndex = (nowPlayingIndex + 1) % 2
                            if gameMode == 1
                            {
                                var computerPlaceIndex = Int.random(in: 0...6)
                                while emptyIndex[computerPlaceIndex] < 0
                                {
                                    computerPlaceIndex = Int.random(in: 0...6)
                                }
                                circles[emptyIndex[computerPlaceIndex]].ownerIndex = nowPlayingIndex
                                circles[emptyIndex[computerPlaceIndex]].color = playerData[nowPlayingIndex].color
                                playerData[nowPlayingIndex].useChess += 1
                                playerData[nowPlayingIndex].ownPlaceIndex[emptyIndex[computerPlaceIndex]] = true
                                emptyIndex[computerPlaceIndex] -= 7
                                if nowPlayingIndex == 1 && playerData[nowPlayingIndex].useChess == 21
                                {
                                    showDrawAlert = true
                                }
                                let lineChess = checkWin(ownPlaceIndex: playerData[nowPlayingIndex].ownPlaceIndex)
                                if lineChess[0] != -1
                                {
                                    for i in lineChess
                                    {
                                        circles[i].color = Color.black
                                    }
                                    showWinAlert = true
                                }
                                nowPlayingIndex = (nowPlayingIndex + 1) % 2
                            }
                        }
                    }
                }
            }
            .alert("已經放不下了歐", isPresented: $showFullAlert, actions: {
                Button("OK") { }
            })
            .scaledToFill()
        }
    }
}

func checkWin(ownPlaceIndex: [Bool]) -> [Int]
{
    for i in 0...41
    {
        var lineArray = [Int]()
        if ownPlaceIndex[i] == true
        {
            //            print("in check line index = \(i)")
            lineArray.append(i)
            var checkArray = [Int]()
            
            //check horizontal
            var horizontalIndex = i + 1
            while horizontalIndex < 42 && ownPlaceIndex[horizontalIndex] == true && i / 7 == horizontalIndex / 7
            {
                //                print("in horizontal")
                checkArray.append(horizontalIndex)
                horizontalIndex += 1
                //                print(checkArray)
            }
            if checkArray.count >= 3
            {
                lineArray.append(contentsOf: checkArray)
            }
            //            print("lineArray new = \(lineArray)")
            checkArray = [Int]()
            //            print("lineArray new = \(lineArray)")
            
            //check vertical
            var verticalIndex = i + 7
            while verticalIndex < 42 && ownPlaceIndex[verticalIndex] == true
            {
                checkArray.append(verticalIndex)
                verticalIndex += 7
            }
            if checkArray.count >= 3
            {
                lineArray.append(contentsOf: checkArray)
            }
            checkArray = [Int]()
            
            //check leftSlash
            var leftSlashIndex = i + 7 - 1
            while leftSlashIndex < 42 && ownPlaceIndex[leftSlashIndex] == true
            {
                checkArray.append(leftSlashIndex)
                leftSlashIndex = leftSlashIndex + 7 - 1
            }
            if checkArray.count >= 3
            {
                lineArray.append(contentsOf: checkArray)
            }
            checkArray = [Int]()
            
            //check rightSlash
            var rightSlashIndex = i + 7 + 1
            while rightSlashIndex < 42 && ownPlaceIndex[rightSlashIndex] == true
            {
                checkArray.append(rightSlashIndex)
                rightSlashIndex = rightSlashIndex + 7 + 1
            }
            if checkArray.count >= 3
            {
                lineArray.append(contentsOf: checkArray)
            }
            
        }
        if lineArray.count >= 4
        {
            return lineArray
        }
    }
    return [-1]
}

func calcChessPlace(index:Int) -> Int{
    let placeIndex: Int = emptyIndex[index % 7]
    emptyIndex[index % 7] -= 7
    return placeIndex
}

struct CircleView: View {
    @Binding var circles: [CircleType]
    let index: Int
    var body: some View {
            Circle()
                .aspectRatio(4/3 ,contentMode: .fit)
                .foregroundColor(circles[index].color)
    }
}

struct MaskView: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.blue)
            .aspectRatio(4/3 ,contentMode: .fit)
            .mask {
                Image("mask")
                    .resizable()
                    .scaledToFit()
            }
    }
}

struct GameView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

