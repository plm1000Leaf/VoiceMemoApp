//
//  EditBottomView.swift
//  VoiceMemoApp
//
//  Created by 千葉陽乃 on 2024/12/19.
//

import SwiftUI
import CoreData

struct EditBottomView: View {
    
    @Binding var selectedMemos: Set<NSManagedObjectID>
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \VoiceMemoEntities.createdAt, ascending: false)],
        predicate: NSPredicate(format: "isDelete == NO"), // 非削除データのみ取得
        animation: .default
    ) private var voiceMemos: FetchedResults<VoiceMemoEntities>
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
                    SelectFolderView(isPresented: $isSelectFolderViewPresented, selectedMemos: $selectedMemos)
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
    
    private func moveSelectedMemosToDeletedFolder() {
        VoiceMemoModel.moveSelectedMemosToDeletedFolder(
            selectedMemos: selectedMemos,
            voiceMemos: voiceMemos,
            context: context
        )
        selectedMemos.removeAll() // 選択をクリア
        
        do {
            try context.save() // データベースの変更を確定
        } catch {
            print("Error saving context: \(error)")
        }
    }

}
