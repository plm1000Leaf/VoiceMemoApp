//
//  ContentView.swift
//  VoiceMemoApp
//
//  Created by 千葉陽乃 on 2024/11/14.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HStack{
                Image(systemName: "chevron.backward")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
                    .bold()
                Text("編集")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                    .padding(.trailing, 20)
            }
                Text("すべての録音")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.largeTitle)
                    .padding(.leading, 20)
                    .padding([.top, .bottom], 5)
                    .bold()
                Spacer()
            ScrollView{
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width:350, height: 50)
                        .foregroundColor(.gray)
                        .frame(maxHeight: .infinity, alignment: .top)
                    HStack{
                        Circle()
                            .frame(width:20, height: 30)
                            .frame(maxHeight: .infinity, alignment: .top)
                            .padding(.top,  10)
                            .padding(.leading, 30)
                        Text("検索")
                            .frame(maxHeight: .infinity, alignment: .top)
                            .padding(.top,  15)
                            .padding(.leading, 5)
                        Spacer()
                        Circle()
                            .frame(width:20, height: 30)
                            .frame(maxHeight: .infinity, alignment: .top)
                            .padding(.top,  10)
                            .padding(.trailing, 30)
                    }
                }
                .padding( .bottom , 15)
                VStack(spacing: 0){
                    ForEach(0..<30) { _ in
                        Rectangle()
                            .stroke(Color.blue, lineWidth: 2)
                            .frame(width:350, height: 70)
                            .frame(maxHeight: .infinity, alignment: .top)
                    }
                }
            }
            ZStack{
                Rectangle()
                    .frame(width:400, height: 130)
                    .frame(alignment: .bottom)
                    .foregroundColor(.gray)
                Circle()
                    .frame(width:80, height: 80)
            }
        }
    }
}

#Preview {
    ContentView()
}
