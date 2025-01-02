//
//  VoiceMemoFolderView.swift
//  VoiceMemoApp
//
//

import SwiftUI

struct VoiceMemoFolderView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var textFieldText: String = ""
    @State private var isAddFolder: Bool = false
    @State private var isEditingFolder: Bool = false
    @State private var selectedFolderID: UUID?
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \VoiceMemoEntities.createdAt, ascending: false)],
        animation: .default
    ) private var voiceMemos: FetchedResults<VoiceMemoEntities>
    
    @FetchRequest(
        entity: FolderEntities.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FolderEntities.title, ascending: true)]
    ) private var folders: FetchedResults<FolderEntities>
    
    var body: some View {
        ZStack{
            NavigationStack{
                VStack {
                    
                    headerArea
                    titleArea
                    
                    Spacer()
                    
                    ScrollView {
                        
                        topFolderListArea
                        bottomFolderListArea
                        
                    }
                    footerArea
                }
                .background(Color("Background"))
                .navigationBarBackButtonHidden(true)
            }
            if isAddFolder {
                AddFolderView(
                    selectedFolderID: $selectedFolderID, 
                    textFieldText: $textFieldText,
                    isAddFolder: $isAddFolder
                )
                     .onTapGesture {
                         // 背景タップでモーダルを閉じる
                         isAddFolder = false
                     }
            }
        }
    }
//    関数ハンドル
    @ViewBuilder
    private func destinationView(for index: Int) -> some View {
        switch index {
        case 0:
            ContentView()
                .navigationBarBackButtonHidden(true)
        case 1:
            OftenUsedFolderView()
                .navigationBarBackButtonHidden(true)
        case 2:
            DeletedFolderView()
                .navigationBarBackButtonHidden(true)
        default:
            EmptyView()
        }
    }
}
#Preview {
    VoiceMemoFolderView()
}




extension VoiceMemoFolderView {
    private var headerArea: some View {
        Button(action: {
            isEditingFolder.toggle() // 編集モードを切り替える
        }){
            Text(isEditingFolder ? "完了" : "編集")
                .font(.system(size: 20))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(.blue)
                .padding(.trailing, 20)
                .bold()
        }
    }
    
    private var titleArea: some View {
        Text("ボイスメモ")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.largeTitle)
            .padding(.leading, 20)
            .padding([.top, .bottom], 5)
            .bold()
            .font(.system(size: 100))
    }
    
    private var topFolderListArea: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.white)
                .frame(width: 350, height: 180)
            HStack{
                VStack(spacing: 20){
                    Image(systemName: "waveform")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 40)
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                    
                    Image(systemName: "heart")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 40)
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                    
                    Image(systemName: "trash")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 42)
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                }
                VStack{
                    let n = ["すべての録音","よく使う項目","最近削除した項目"]
                    let favCount = voiceMemos.filter { !$0.isDelete && $0.isFav }.count
                    let deleteCount = voiceMemos.filter { $0.isDelete && !$0.isFav }.count

                    ForEach(0..<3){ index in
                        NavigationLink(
                            destination: destinationView(for: index)
                        ){
                            HStack{
                                Text("\(n[index])")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, -50)
                                    .foregroundColor(.black)
                                
                                switch index {
                                case 0:
                                    Text("\(voiceMemos.count)")
                                        .foregroundColor(Color("DataCount"))
                                case 1:
                                    Text("\(favCount)")
                                        .foregroundColor(Color("DataCount"))
                                case 2:
                                    Text("\(deleteCount)")
                                        .foregroundColor(Color("DataCount"))
                                    
                                default:
                                    Text("N/A")
                                        .foregroundColor(Color.gray)
                                }
                                    
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("ListLine"))
                                    .bold()
                            }
                        }
                        if index <= 1 {
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
    }
    
    private var bottomFolderListArea: some View {
        Group {
        if isEditingFolder{
            EditFolderRowView()
        } else {
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
                            NavigationLink(destination: FolderDetailView(folderID: folder.id, folderTitle: folder.title)){
                                HStack {
                                    Image(systemName: "folder")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 40)
                                        .font(.system(size: 30))
                                        .foregroundColor(.blue)
                                    Text(folder.title)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, -80)
                                        .foregroundColor(.black)
                                    Text("3")
                                        .foregroundColor(Color("DataCount"))
                                        .offset(x:-50)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color("ListLine"))
                                        .offset(x:-45)
                                        .bold()
                                }
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
        }
    }
        private var footerArea: some View {
            Button {
                isAddFolder.toggle()
            } label: {
                Image(systemName: "folder.badge.plus")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 30)
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
            }
            
        }
        
    }
    
