//
//  VoiceMemoFolderView.swift
//  VoiceMemoApp
//
//

import SwiftUI

struct VoiceMemoFolderView: View {
    @State private var textFieldText: String = ""
    
    var body: some View {
        
        VStack {
            Text("編集")
                .font(.system(size: 20))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(.blue)
                .padding(.trailing, 20)
                .bold()
            
            Text("ボイスメモ")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.largeTitle)
                .padding(.leading, 20)
                .padding([.top, .bottom], 5)
                .bold()
                .font(.system(size: 100))
            Spacer()
            
            ScrollView {
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.white)
                            .frame(width: 350, height: 180)
                    HStack{
                        VStack(spacing: 20){
                            Image(systemName: "waveform")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 40)
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                            
                            Image(systemName: "heart")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 40)
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                            
                            Image(systemName: "trash")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 42)
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                        }
                        VStack{
                            let n = ["すべての録音","よく使う項目","最近削除した項目"]
                            ForEach(0..<3){ index in
                                HStack{
                                    Text("\(n[index])")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, -50)
                                    Text("3")
                                        .foregroundColor(Color("DataCount"))
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color("ListLine"))
                                        .bold()
                                }
                                if index <= 1 {
                                    Divider()
                                        .foregroundColor(Color("ListLine"))
                                        .frame(width: 270, height: 20)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, 20)
                                }
                            }
                        }
                    }
                }
                VStack{
                    Text("マイフォルダ")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        .padding(.leading, 50)
                        .padding(.top, 70)
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 350, height: 60)
                        .foregroundColor(.white)
                    HStack{
                        Image(systemName: "folder")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 40)
                            .font(.system(size: 25))
                            .foregroundColor(.blue)
                        Text("あいうえお")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("3")
                            .foregroundColor(Color("DataCount"))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, -30)
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color("ListLine"))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 50)
                            .bold()
                    }
                }
            }
            Image(systemName: "folder.badge.plus")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 30)
                .font(.system(size: 30))
                .foregroundColor(.blue)
        }
        .background(Color("Background"))
    }
}

#Preview {
    VoiceMemoFolderView()
}

