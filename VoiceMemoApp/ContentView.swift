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
                    .bold()
            }
                Text("すべての録音")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.largeTitle)
                    .padding(.leading, 20)
                    .padding([.top, .bottom], 5)
                    .bold()
                    .font(.system(size: 100))
                Spacer()
            ScrollView{
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width:350, height: 50)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .foregroundColor(Color("RecordingSearchColor"))
                        .bold()
                    
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .frame(width:20, height: 30)
                            .frame(maxHeight: .infinity, alignment: .top)
                            .padding(.top,  10)
                            .padding(.leading, 35)
                            .foregroundColor(Color("RecordingSFSymbleColor"))
                        Text("検索")
                            .frame(maxHeight: .infinity, alignment: .top)
                            .padding(.top,  15)
                            .padding(.leading, 5)
                            .foregroundColor(Color("RecordingSFSymbleColor"))
                        Spacer()
                        Image(systemName: "mic.fill")
                            .frame(width:20, height: 30)
                            .frame(maxHeight: .infinity, alignment: .top)
                            .padding(.top,  10)
                            .padding(.trailing, 35)
                            .foregroundColor(Color("RecordingSFSymbleColor"))
                            
                    }
                }
                .padding( .bottom , 15)
                VStack(spacing: 75){
                    ForEach(0..<30) { _ in
                        Rectangle()
                            .frame(width: 330,height: 1)
                            .frame(maxHeight: .infinity, alignment: .top)
                            .foregroundColor(Color("RecordingMemoLine"))
                    }
                }
            }
            ZStack{
                Rectangle()
                    .frame(width:400, height: 130)
                    .frame(alignment: .bottom)
                    .foregroundColor(Color("RecordingBottomColor"))
                Circle()
                    .stroke(Color("RecordingButtonLineColor"), lineWidth: 5)
                    .frame(width:80, height: 80)
                Circle() 
                    .foregroundColor(Color("RecordingButtonColor"))
                    .frame(width:65, height: 65)
                
            }
        }
    }
}

#Preview {
    ContentView()
}
