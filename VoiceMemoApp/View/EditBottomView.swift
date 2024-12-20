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
    
    var deleteAction: () -> Void
    
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width: 400, height: 65)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color("RecordingBottomColor"))
            HStack{
                Image(systemName: "folder.badge.plus")
                    .padding(.leading, 35)
                    .font(.system(size: 25))
                    .foregroundColor(selectedMemos.isEmpty ? Color("RecordingSFSymbleColor") : Color.blue)
                Spacer()
                Button(action: deleteAction) {
                    Image(systemName: "trash")
                        .padding(.trailing, 35)
                        .font(.system(size: 25))
                        .foregroundColor(selectedMemos.isEmpty ? Color("RecordingSFSymbleColor") : Color.blue)
                        
                }
            }
            
        }
    }
}
