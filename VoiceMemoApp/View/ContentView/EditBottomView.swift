//
//  EditBottomView.swift
//  VoiceMemoApp
//
//  Created by 千葉陽乃 on 2024/12/19.
//

import SwiftUI
import CoreData

struct EditBottomView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \VoiceMemoEntities.createdAt, ascending: false)],
        animation: .default
    ) private var voiceMemos: FetchedResults<VoiceMemoEntities>
    @Binding var selectedMemos: Set<NSManagedObjectID>
    @State private var isSelectFolderViewPresented = false
    
    var deleteAction: () -> Void
    
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width: 400, height: 65)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color("RecordingBottomColor"))
            HStack{
                Button(action: {
                    withAnimation {
                        isSelectFolderViewPresented.toggle()
                    }
                }){
                    Image(systemName: "folder.badge.plus")
                        .padding(.leading, 35)
                        .font(.system(size: 25))
                        .foregroundColor(selectedMemos.isEmpty ? Color("RecordingSFSymbleColor") : Color.blue)
                }.sheet(isPresented: $isSelectFolderViewPresented) {
                    SelectFolderView(isPresented: $isSelectFolderViewPresented)
                }
                Spacer()
                Button(action: moveSelectedMemosToDeletedFolder) {
                    Image(systemName: "trash")
                        .padding(.trailing, 35)
                        .font(.system(size: 25))
                        .foregroundColor(selectedMemos.isEmpty ? Color("RecordingSFSymbleColor") : Color.blue)
                    
                }
                .disabled(selectedMemos.isEmpty)
            }
            
        }
    }
    
     func moveSelectedMemosToDeletedFolder() {
        selectedMemos.forEach { objectID in
            if let memo = voiceMemos.first(where: { $0.objectID == objectID }) {
                memo.isDelete = true // 削除フラグを立てる
            }
        }
        do {
            try context.save()
            selectedMemos.removeAll() // 選択をクリア
        } catch {
            print("削除済みフォルダへの移動中にエラー: \(error)")
        }
    }
}
