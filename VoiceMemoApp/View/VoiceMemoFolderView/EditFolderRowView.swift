//
//  EditFolderRowView.swift
//  VoiceMemoApp
//
//  Created by 千葉陽乃 on 2024/12/29.
//

import SwiftUI

struct EditFolderRowView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: FolderEntities.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FolderEntities.title, ascending: true)]
    ) private var folders: FetchedResults<FolderEntities>
    
    var body: some View {
        
        VStack{
            Text("マイフォルダ")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.gray)
                .padding(.leading, 50)
                .padding(.top, 70)
            
            ZStack{
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 350, height: CGFloat(65 * folders.count + 80))
                    .foregroundColor(.white)
                VStack{
                    ForEach(folders, id: \.id) { folder in
                        HStack {
                            Button(action: {
                                deleteFolder(folder)
                            }) {
                                Circle()
                                    .foregroundColor(.red)
                                    .frame(width: 25, height: 25)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 45)
                            }
                                Image(systemName: "folder")
                                //                                    .frame(maxWidth: .infinity, alignment: .leading)
                                //                                    .padding(.leading, 10)
                                    .offset(x:-50)
                                    .font(.system(size: 30))
                                    .foregroundColor(.blue)
                                Text(folder.title)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, -50)
                                    .foregroundColor(.black)
                                Text("3")
                                    .foregroundColor(Color("DataCount"))
                                    .offset(x:-50)
                                //                                .frame(maxWidth: .infinity, alignment: .trailing)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("ListLine"))
                                    .offset(x:-45)
                                //                                .frame(maxWidth: .infinity, alignment: .trailing)
                                    .bold()
                            }
                            Divider()
                                .foregroundColor(Color("ListLine"))
                                .frame(width: 270, height: 20)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 20)
                        }
                    }
                }
            }
        }
        
         func deleteFolder(_ folder: FolderEntities) {
            viewContext.delete(folder)
            do {
                try viewContext.save()
            } catch {
                print("Error deleting folder: \(error.localizedDescription)")
            }
        }
    }

#Preview {
    EditFolderRowView()
}
