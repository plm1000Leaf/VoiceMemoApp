//
//  SeekBarView.swift
//  VoiceMemoApp
//
//

import SwiftUI

struct SeekBarView: View {
    @Environment(\.managedObjectContext) private var context
    @State private var currentTime: Double = 0
    @State private var isPlaying: Bool = false
    @State private var timer: Timer?
    
    let voiceMemo: VoiceMemoEntities
    typealias vmM = VoiceMemoModel
    
    let totalTime: Double = 100
    let stepTime: Double = 15
    let stepInterval: TimeInterval = 1.0
    
    var body: some View {
        VStack {
            Slider(value: $currentTime, in: 0...totalTime, step: 1) {
                Text("Seek Bar")
            }
            .padding()
            
            // 時間を表示するテキスト
            HStack {
                Text(formatTime(currentTime)) // 現在の時間
                Spacer()
                Text(formatTime(totalTime))  // 全体の時間
            }
            .foregroundColor(.gray)
            .padding(.horizontal)
            .padding(.top, -20)
            .padding(.bottom, 30)
            HStack{
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 30)
                
                HStack {
                    
                    
                    Button(action: {
                        // 現在の時間を15秒戻す
                        currentTime = max(currentTime - stepTime, 0)
                    }){
                        Image(systemName: "gobackward.15")
                            .padding(.horizontal, 13)
                    }
                    
                    Button(action: {
                        isPlaying.toggle()
                    if isPlaying {
                        startTimer()
                    } else {
                        stopTimer()
                        }
                    }) {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    }
                    
                    Button(action: {
                        // 現在の時間を15秒戻す
                        currentTime = min(currentTime +  stepTime, totalTime)
                    }){
                        Image(systemName: "goforward.15")
                            .padding(.horizontal, 13)
                    }
                    
                }
                .foregroundColor(.black)
                
                Button(action: {
                    vmM.deleteVoiceMemo(voiceMemo, context: context)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 30)
                }
            }
            .font(.system(size: 27))
            
        }
    }
    
    
    
    private func startTimer() {
        stopTimer() // 既存のタイマーを停止して新しいタイマーを作成
        timer = Timer.scheduledTimer(withTimeInterval: stepInterval, repeats: true) { _ in
            if currentTime < totalTime {
                currentTime += 1
            } else {
                stopTimer()
                isPlaying = false
            }
        }
    }
   
    
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // 秒を「分:秒」の形式にフォーマットする関数
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

