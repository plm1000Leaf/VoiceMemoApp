//
//  SeekBarView.swift
//  VoiceMemoApp
//
//

import SwiftUI
import AVFoundation

struct PlayFileView: View {
    @Environment(\.managedObjectContext) private var context
    @State private var currentTime: Double = 0
    @State private var isPlaying: Bool = false
    @State private var timer: Timer?
    @State private var audioPlayer: AVAudioPlayer? = nil
    
    let voiceMemo: VoiceMemoEntities
    typealias vmM = VoiceMemoModel
    

    let stepTime: Double = 15
    let stepInterval: TimeInterval = 1.0
    
    var body: some View {
        VStack {
            // 時間を表示するテキスト
            HStack {
                Text(VoiceMemoModel.formatListTime(from: currentTime)) // 現在の時間

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
                        togglePlayback()
                    }) {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    }
                                        
                }
                .foregroundColor(.black)
                
                Button(action: {
                    if voiceMemo.isDelete {
                        vmM.seekBarDeleteVoiceMemo(voiceMemo, context: context) // 完全削除
                    } else {
                        moveToDeletedFolder() // 削除フォルダへ移動
                    }
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
    
    
    private func togglePlayback() {
        if isPlaying {
            stopPlayback()
        } else {
            startPlayback()
        }
    }

    private func startPlayback() {
        guard let filePath = voiceMemo.filePath,
              let fileURL = URL(string: filePath) else {
            print("ファイルパスが無効です: \(voiceMemo.filePath ?? "nil")")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.play()
            isPlaying = true

            // タイマーを開始してシークバーを更新
            startTimer()
        } catch {
            print("再生エラー: \(error)")
        }
    }

    private func stopPlayback() {
        audioPlayer?.stop()
        isPlaying = false
        stopTimer()
    }

    private func startTimer() {
        stopTimer() // 既存のタイマーを停止して新しいタイマーを作成
        timer = Timer.scheduledTimer(withTimeInterval: stepInterval, repeats: true) { _ in
            if currentTime < voiceMemo.duration {
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
    
    
    private func moveToDeletedFolder() {
        VoiceMemoModel.moveToDeletedFolder(voiceMemo, context: context)
    }

    
}

