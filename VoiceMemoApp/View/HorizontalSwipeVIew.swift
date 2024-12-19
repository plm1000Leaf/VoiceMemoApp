//
//  HorizontalSwipeVIew.swift
//  VoiceMemoApp
//
//  Created by 千葉陽乃 on 2024/12/06.
//

import SwiftUI

struct HorizontalSwipeVIew: View {
    var body: some View {
        HStack(spacing: 0){
            ZStack{
                Rectangle()
                    .frame(width: 90, height: 80)
                    .foregroundColor(Color("RecordingButtonLineColor"))
                Image(systemName: "ellipsis")
                    .foregroundColor(.white)
            }
            ZStack{
                Rectangle()
                    .frame(width: 90, height: 80)
                    .foregroundColor(Color("SwipeFolderColor"))
                Image(systemName: "folder.fill")
                    .foregroundColor(.white)
            }
            ZStack{
                Rectangle()
                    .frame(width: 90, height: 80)
                    .foregroundColor(Color("RecordingButtonColor"))
                Image(systemName: "trash.fill")
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    HorizontalSwipeVIew()
}
