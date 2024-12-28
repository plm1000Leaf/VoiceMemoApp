//
//  RecodingButtonView.swift
//  VoiceMemoApp
//
//  Created by 千葉陽乃 on 2024/11/26.
//

import SwiftUI
import CoreData


struct RecodingButtonView: View {
    let context: NSManagedObjectContext
    let addVoiceMemoWithLocation: () -> Void
    
    typealias vmM = VoiceMemoModel

    @State private var showTab: Bool = false
    @State private var isRecording: Bool = false
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        VStack(spacing: 0){
            if showTab {
                showTabArea
            }
            
            ZStack{
                
                buttonBackArea
                
                Button(action: {
                    withAnimation {
                        if isRecording{
                            vmM.addVoiceMemo(title: "初期", duration: 120, context: context)
                            
                        }
                        isRecording.toggle()
                        showTab.toggle()
                    }
                })
                {
                    buttonArea
                }
            }
        }
    }
}


extension RecodingButtonView {
    
    
    private var showTabArea: some View {
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
    
    private var buttonArea: some View {
        ZStack{
            Circle()
                .stroke(Color("RecordingButtonLineColor"), lineWidth: 5)
                .frame(width:80, height: 80)
            if isRecording {
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color("RecordingButtonColor"))
                    .frame(width: 30, height: 30)
                
            } else {
                    Circle()
                        .foregroundColor(Color("RecordingButtonColor"))
                        .frame(width:65, height: 65)
                }
            }
        }
    
        
        private var buttonBackArea: some View {
            Rectangle()
                .frame(width: 400, height: 130)
                .foregroundColor(Color("RecordingBottomColor"))
        }


    }

