import SwiftUI

struct SelectFolderView: View {
    @Binding var isPresented: Bool
    @State private var textFieldText: String = ""
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \VoiceMemoEntities.createdAt, ascending: false)],
        animation: .default
    ) private var voiceMemos: FetchedResults<VoiceMemoEntities>
    
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
                        ForEach(0..<3){ index in

                                HStack{
                                    Text("\(n[index])")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, -50)
                                        .foregroundColor(.black)
                                    Text("\(voiceMemos.count)")
                                        .foregroundColor(Color("DataCount"))
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color("ListLine"))
                                        .bold()
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
                        .frame(width: 350, height: 60)
                        .foregroundColor(.white)
                    HStack{
                        Image(systemName: "folder")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 40)
                            .font(.system(size: 25))
                            .foregroundColor(.blue)
                        Text("あいうえお")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("3")
                            .foregroundColor(Color("DataCount"))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, -30)
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color("ListLine"))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 50)
                            .bold()
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
    
