//
//  SeekBarView.swift
//  VoiceMemoApp
//
//

import SwiftUI

struct SeekBarView: View {
    @State private var currentTime: Double = 0 // 現在の再生位置
    let totalTime: Double = 100               // 全体の再生時間（仮に100秒とする）
    
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
                Image(systemName: "gobackward.15")
                    .padding(.horizontal, 13)
                Image(systemName: "play.fill")
                Image(systemName: "goforward.15")
                    .padding(.horizontal, 13)
                Image(systemName: "trash")
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 30)
            }
            .font(.system(size: 27))
            
        }
    }
    
    // 秒を「分:秒」の形式にフォーマットする関数
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct SeekBarView_Previews: PreviewProvider {
    static var previews: some View {
        SeekBarView()
    }
}

