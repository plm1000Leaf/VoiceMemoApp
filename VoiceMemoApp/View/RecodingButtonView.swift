//
//  RecodingButtonView.swift
//  VoiceMemoApp
//
//  Created by 千葉陽乃 on 2024/11/26.
//

import SwiftUI

struct RecodingButtonView: View {
    
    @State private var showTab: Bool = false
    
    var body: some View {
        VStack(spacing: 0){
            
                if showTab {

                    ZStack{
                            Rectangle()
                                .frame(width: 400, height:200)
                                .foregroundColor(Color("RecordingBottomColor"))
                                .frame(maxWidth: .infinity, alignment: .bottom)
                        
                        VStack{
                            Text("東京都")
                            Text("00:00:00")
                            Spacer().frame(height: 50)
                            Rectangle()
                                .frame(width: 400, height:1)
                            
                        }
                            
                        }
                }
            
            ZStack{
                Rectangle()
                    .frame(width: 400, height: 130)
                    .foregroundColor(Color("RecordingBottomColor"))
                Button(action: {
                    withAnimation {
                        showTab.toggle()
                    }
                })
                {   ZStack{
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
    }
}

#Preview {
    RecodingButtonView()
}
