//
//  AddFolderView.swift
//  VoiceMemoApp
//
//  Created by 千葉陽乃 on 2024/12/28.
//

import SwiftUI

struct AddFolderView: View {
    @Binding var textFieldText: String 
    @Binding var isAddFolder: Bool
    var body: some View {
        ZStack {
            Rectangle()
                .opacity(0.4)
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color("AddFolder"))
                .frame(width: 300, height: 200)
            
            VStack{
                Spacer()
                    .frame(height: 25)
                Text("新規フォルダ")
                    .bold()
                Text("このフォルダの名前を入力します")
                Spacer()
                    .frame(height: 25)
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.white)
                    .frame(width: 250, height: 40)
                Spacer()
                    .frame(height: 1)
                ZStack{
                    Rectangle()
                        .foregroundColor(Color("DataCount"))
                        .frame(width: 300, height: 1)
                        .offset(y: 10)
                    TextField("名前", text: $textFieldText)
                        .offset(x:80, y: -33)
                }
                
                HStack{
                    Text("キャンセル")
                        .bold()
                        .offset(x: -43, y: -5)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            isAddFolder = false // キャンセルで閉じる
                        }
                    
                    Rectangle()
                        .foregroundColor(Color("DataCount"))
                        .frame(width: 1, height: 50)
                        .offset(x:-17, y: -7)
                    Text("保存")
                        .bold()
                        .foregroundColor(Color("DataCount"))
                        .offset(x:28,y: -5)
                        .onTapGesture {
                            isAddFolder = false // 保存して閉じる
                        }
                }
            }
        }
    }
}

