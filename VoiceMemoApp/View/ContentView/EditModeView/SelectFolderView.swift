import SwiftUI
import CoreData

struct SelectFolderView: View {
    @Environment(\.managedObjectContext) private var context
    @Binding var isPresented: Bool
    @Binding var selectedMemos: Set<NSManagedObjectID>
    @State private var textFieldText: String = ""
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \VoiceMemoEntities.createdAt, ascending: false)],
        animation: .default
    ) private var voiceMemos: FetchedResults<VoiceMemoEntities>
    
    @FetchRequest(
        entity: FolderEntities.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FolderEntities.title, ascending: true)]
    ) private var folders: FetchedResults<FolderEntities>
    
    var body: some View {
        NavigationStack{
            VStack {
                
                headerArea
                
                Spacer().frame(height: 60)
                
                ScrollView {
                    
                    topFolderListArea
                    bottomFolderListArea
                    
                }
                footerArea
            }
            .background(Color("Background"))
            .navigationBarBackButtonHidden(true)
        }
    }
}

    
    extension SelectFolderView {
        private var headerArea: some View {
            
            HStack{
                Spacer()
                    .frame(width: 100)
                Text("フォルダを選択")
                    .font(.system(size: 20))
                    .bold()
                Spacer()
                Button("キャンセル"){
                    isPresented = false
                }
                .font(.system(size: 15))
                .foregroundColor(.blue)
                .padding(.trailing, 10)
                .bold()
            }
            .padding()
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
                                .contentShape(Rectangle()) // タップ領域を広げる
                                .onTapGesture {
                                    switch index {
                                    case 0:
                                        print("Number is 0")
                                        fallthrough
                                    case 1:
                                        
                                        VoiceMemoModel.moveSelectedMemosToFavFolder(
                                            selectedMemos: selectedMemos,
                                            voiceMemos: voiceMemos,
                                            context: context
                                        )
                                        
                                        isPresented = false
                                        
                                    case 2:
                                        VoiceMemoModel.moveSelectedMemosToDeletedFolder(
                                            selectedMemos: selectedMemos,
                                            voiceMemos: voiceMemos,
                                            context: context
                                        )
                                        
                                        isPresented = false
                                    default:
                                        print("Default case")
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
                                        Image(systemName: "folder")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, 40)
                                            .font(.system(size: 30))
                                            .foregroundColor(.blue)
                                        Text(folder.title)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, -80)
                                            .foregroundColor(.black)
                                        Text("\(folder.numberOfData)")
                                            .foregroundColor(Color("DataCount"))
                                            .offset(x:-50)
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color("ListLine"))
                                            .offset(x:-45)
                                            .bold()
                                    }
                                    .onTapGesture {
                                        VoiceMemoModel.moveSelectedMemosToFolder(selectedFolder: folder, selectedMemos: selectedMemos, context: context, voiceMemos: voiceMemos
                                        )
                                    isPresented = false // モーダルを閉じる
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
        
        private var footerArea: some View {
            Image(systemName: "folder.badge.plus")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 30)
                .font(.system(size: 30))
                .foregroundColor(.blue)
        }
        
    }
    
