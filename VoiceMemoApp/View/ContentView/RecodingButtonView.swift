//
//  RecodingButtonView.swift
//  VoiceMemoApp
//
//  Created by 千葉陽乃 on 2024/11/26.
//

import SwiftUI
import CoreData
import AVFoundation


struct RecodingButtonView: View {
    let context: NSManagedObjectContext
    let addVoiceMemoWithLocation: () -> Void
    
    typealias vmM = VoiceMemoModel

    @State private var showTab: Bool = false
    @State private var isRecording: Bool = false
    @StateObject private var locationManager = LocationManager()
    
    @State private var recordingDuration: Double = 0
    @State private var timer: Timer? = nil
    @State private var audioRecorder: AVAudioRecorder? = nil
    
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
                Text(locationManager.location ?? "位置情報を取得中...")
                    .bold()
                    .font(.system(size: 20))
                Spacer().frame(height: 30)
                Text(formatTime(from: recordingDuration))
                Spacer().frame(height: 50)
                Text("録音中....")
                    .bold()
                    .font(.system(size: 20))
                
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
        recordingDuration = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            recordingDuration += 1
        }

        let fileName = UUID().uuidString + ".m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: filePath, settings: settings)
            audioRecorder?.record()
            print("録音開始")
        } catch {
            print("録音開始エラー: \(error)")
        }
    }


    // 録音を終了する
    private func stopRecording() {
        timer?.invalidate()
        timer = nil

        audioRecorder?.stop()
        let recordedFilePath = audioRecorder?.url.path
        audioRecorder = nil

        let currentLocation = locationManager.location ?? "不明な場所"
        vmM.addVoiceMemo(
            title: "初期",
            duration: recordingDuration,
            context: context,
            location: currentLocation,
            filePath: recordedFilePath
        )
        print("録音終了")
    }

    // ドキュメントディレクトリのパスを取得
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    
    // 時間をフォーマットする
    private func formatTime(from duration: Double) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }


    }

