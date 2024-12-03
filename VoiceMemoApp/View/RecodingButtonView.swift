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
    @State private var showTab: Bool = false
    @State private var isRecording: Bool = false
    
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
                            addVoiceMemo()
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

#Preview {
    // コンテキストのモックを渡す
    let previewContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    return RecodingButtonView(context: previewContext)
}

extension RecodingButtonView {
    
    private func addVoiceMemo() {
        // VoiceMemoEntitiesを作成
        guard let entity = NSEntityDescription.entity(forEntityName: "VoiceMemoEntities", in: context) else {
            print("VoiceMemoEntitiesのエンティティが見つかりません")
            return
        }
        
        // 正しい初期化を使用
        let newMemo = VoiceMemoEntities(entity: entity, insertInto: context)
        
        newMemo.id = UUID()
        newMemo.title = "New Memo \(Date())"
        newMemo.filePath = "/path/to/new_memo.m4a"
        newMemo.createdAt = Date()
        newMemo.duration = Double.random(in: 60...300)
        newMemo.location = "Unknown"
        
        // 保存処理
        do {
            try context.save()
            print("新しいVoiceMemoが追加されました: \(newMemo.title ?? "No Title")")
        } catch {
            print("VoiceMemo追加中にエラーが発生しました: \(error)")
        }
    }
    
    
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

