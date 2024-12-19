//
//  EditBottomView.swift
//  VoiceMemoApp
//
//  Created by 千葉陽乃 on 2024/12/19.
//

import SwiftUI

struct EditBottomView: View {
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width: 400, height: 65)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color("RecordingBottomColor"))
            HStack{
                Image(systemName: "folder.badge.plus")
                    .padding(.leading, 35)
                    .font(.system(size: 25))
                    .foregroundColor(Color("RecordingSFSymbleColor"))
                Spacer()
                Image(systemName: "trash")
                    .padding(.trailing, 35)
                    .font(.system(size: 25))
                    .foregroundColor(Color("RecordingSFSymbleColor"))
            }
            
        }
    }
}

#Preview {
    EditBottomView()
}
