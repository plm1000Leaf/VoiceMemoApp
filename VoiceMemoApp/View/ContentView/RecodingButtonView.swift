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
    
    @State private var recordingDuration: Double = 0
    @State private var timer: Timer? = nil
    
    var body: some View {
        VStack(spacing: 0){
            if showTab {
                showTabArea
            }
            
            ZStack{
                
                buttonBackArea
                
                Button(action: {
                    if isRecording {
                        stopRecording()
                    } else {
                        startRecording()
                    }
                    isRecording.toggle()
                    showTab.toggle()
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
                    .bold()
                    .font(.system(size: 20))
                Spacer().frame(height: 30)
                Text(formatTime(from: recordingDuration))
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
    
    // 録音を開始する
    private func startRecording() {
        recordingDuration = 0 // 時間をリセット
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            recordingDuration += 1
        }
    }

    // 録音を終了する
    private func stopRecording() {
        timer?.invalidate() // タイマーを停止
        timer = nil
        
        // 録音データを保存
        vmM.addVoiceMemo(title: "初期", duration: recordingDuration, context: context)
    }
    
    // 時間をフォーマットする
    private func formatTime(from duration: Double) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }


    }

