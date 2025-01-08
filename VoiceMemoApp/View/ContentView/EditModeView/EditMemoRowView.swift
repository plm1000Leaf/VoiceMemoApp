//
//  EditingModeNeni.swift
//  VoiceMemoApp
//
//  Created by 千葉陽乃 on 2024/12/23.
//

import SwiftUI
import CoreData

struct  EditMemoRowView: View {
    
    let memo: VoiceMemoEntities
    let isSelected: Bool
    
    var body: some View {
        ZStack() {
            
            VStack {
                Rectangle()
                    .frame(width: 370, height: 1)
                    .frame(maxHeight: .infinity, alignment: .trailing)
                    .foregroundColor(Color("RecordingMemoLine"))
                    .padding(.top, 15)
                Text(memo.title ?? "不明な場所")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .font(.system(size: 20))
                    .padding(.leading, 20)
                    .foregroundColor(.black)
                Spacer()
                HStack{
                    Text(VoiceMemoModel.formattedDate(from: memo.createdAt ?? Date()))
                        .padding(.leading, 20)
                        .foregroundColor(Color("RecordingSFSymbleColor"))
                    Spacer()
                    Text(VoiceMemoModel.formatListTime(from: memo.duration ))
                        .padding(.trailing, 20)
                        .foregroundColor(Color("RecordingSFSymbleColor"))
                }
                .padding(.bottom, -60)
                
            }
            .padding(.leading, 60)
            .frame(maxWidth: .infinity)
            
            Circle()
                .fill(isSelected ? Color.blue : Color.clear)
                .overlay(
                    Circle().stroke(Color("RecordingMemoLine"), lineWidth: 2)
                )
                .frame(width: 25, height: 25)
                .offset(x: -160, y: 30)
        }
    }
}

