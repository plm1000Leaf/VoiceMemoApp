//
//  ContentView.swift
//  VoiceMemoApp
//
//

import SwiftUI
import CoreData

struct OftenUsedFolderView: View {

    @Environment(\.managedObjectContext) private var context

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \VoiceMemoEntities.createdAt, ascending: false)],
        predicate: NSPredicate(format: "isDelete == NO AND isFav == YES"),
        animation: .default
    ) private var voiceMemos: FetchedResults<VoiceMemoEntities>
    
    @State private var textFieldText: String = ""
    @State private var expandedIndex: Int? = nil
    @State private var isEditing: Bool = false
    @State private var editingMemoID: NSManagedObjectID? = nil
//    @State private var isEditingTitle: Bool = false
    @State private var editableText: String = ""
    @State private var selectedMemos: Set<NSManagedObjectID> = []
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        NavigationStack{
            VStack {
                
                headerArea
                titleArea
                Spacer()
                ScrollViewReader { proxy in
                    scrollArea
                        .onAppear {
                            proxy.scrollTo(0, anchor: .top)
                        }
                    
                    if isEditing {
                        EditBottomView(selectedMemos: $selectedMemos,deleteAction: editModeDeleteMemos)
                    } else {
                        RecodingButtonView(context: context, addVoiceMemoWithLocation: addVoiceMemoWithLocation)

                    }

                }
            }
        }
    }
}

   

#Preview {
    ContentView()
}




extension OftenUsedFolderView {
    
    private var headerArea: some View {
        HStack{
            NavigationLink(destination: VoiceMemoFolderView()) {
                Image(systemName: "chevron.backward")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
                    .bold()
            }
            .navigationBarBackButtonHidden(true)
            
            Button(action: {
                isEditing.toggle() // 編集モードを切り替える
            }){
                Text(isEditing ? "キャンセル" : "編集")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                    .padding(.trailing, 20)
                    .bold()
            }
        }
    }
    
    private var titleArea: some View {
        if isEditing{
            Text("\(selectedMemos.count)件選択")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.largeTitle)
                .padding(.leading, 20)
                .padding([.top, .bottom], 5)
                .bold()
                .font(.system(size: 100))
            
        } else {
            Text("よく使う項目")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.largeTitle)
                .padding(.leading, 20)
                .padding([.top, .bottom], 5)
                .bold()
                .font(.system(size: 100))
        }
    }
    
    private var scrollArea: some View{
        ScrollView {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 350, height: 50)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .foregroundColor(Color("RecordingSearchColor"))
                    .bold()
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .frame(width: 20, height: 30)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 10)
                        .padding(.leading, 45)
                        .foregroundColor(Color("RecordingSFSymbleColor"))
                    TextField("検索", text: $textFieldText)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 15)
                        .padding(.leading, 5)
                        .foregroundColor(Color("RecordingSFSymbleColor"))
                    Spacer()
                    Image(systemName: "mic.fill")
                        .frame(width: 20, height: 30)
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 10)
                        .padding(.trailing, 45)
                        .foregroundColor(Color("RecordingSFSymbleColor"))
                }
            }
            .padding(.bottom, 5)
            
            VStack(spacing: 27) {
                ForEach(voiceMemos, id: \.self) { memo in
                    
                    if isEditing {
                        Button(action: {
                            toggleSelection(for: memo.objectID)
                        }){
                        
                            EditMemoRowView(memo: memo, isSelected: selectedMemos.contains(memo.objectID)).contentShape(Rectangle())
                    }
                    } else {
                        Button(action: {
                            withAnimation {
                                expandedIndex = (expandedIndex == memo.objectID.hashValue) ? nil : memo.objectID.hashValue
                            }
                        }){
                            VStack {
                                Rectangle()
                                    .frame(width: 370, height: 1)
                                    .frame(maxHeight: .infinity, alignment: .trailing)
                                    .foregroundColor(Color("RecordingMemoLine"))
                                    .padding(.top, 15)
                                if editingMemoID == memo.objectID {
                                            TextField(
                                                "タイトルを入力してください",
                                                text: $editableText,
                                                        onCommit: {
                                                            saveEditedTitle(for: memo)
                                                            editingMemoID = nil
                                                        }
                                                    )
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .padding(.leading, 20)
                                        } else {
                                    Text(memo.title ?? "不明な場所")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .bold()
                                        .font(.system(size: 20))
                                        .padding(.leading, 20)
                                        .foregroundColor(.black)
                                        .onTapGesture {
                                            if !isEditing && expandedIndex == memo.objectID.hashValue {
                                                editingMemoID = memo.objectID
                                                editableText = memo.title ?? ""
                                            }
                                        }
                                }
                                
                                Spacer()
                                HStack{
                                    Text(VoiceMemoModel.formattedDate(from: memo.createdAt ?? Date()))
                                        .padding(.leading, 20)
                                        .foregroundColor(Color("RecordingSFSymbleColor"))
                                    Spacer()
                                    Text(VoiceMemoModel.formatTime(from: memo.duration ))
                                        .padding(.trailing, 20)
                                        .foregroundColor(Color("RecordingSFSymbleColor"))
                                }
                                .padding(.bottom, -60)
                                
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    if expandedIndex == memo.objectID.hashValue  {
                        VStack {
                            SeekBarView(voiceMemo: memo)
                        }
                        
                    }
                }
            }
        }
    }
    
    
    private func toggleSelection(for id: NSManagedObjectID) {
        if selectedMemos.contains(id) {
            selectedMemos.remove(id)
        } else {
            selectedMemos.insert(id)
        }
    }
        
        
    private func addVoiceMemoWithLocation() {
        // LocationManagerから位置情報を取得
        let location = locationManager.location ?? "不明な場所"
        let title = location
        
        // Core Dataに新しいメモを追加
        VoiceMemoModel.addVoiceMemo(
            title: title,
            duration: 120.0, // 仮の録音時間
            context: context,
            location: location
        )
    }

    private func saveEditedTitle(for memo: VoiceMemoEntities) {
        memo.title = editableText
        do {
            try context.save()
            print("タイトル編集成功: \(editableText)")
        } catch {
            print("タイトル編集中にエラーが発生しました: \(error)")
        }
    }

    private func editModeDeleteMemos() {
        selectedMemos.forEach { objectID in
            if let memo = voiceMemos.first(where: { $0.objectID == objectID }) {
                context.delete(memo)
            }
        }
        do {
            try context.save()
            selectedMemos.removeAll() // 削除後に選択をクリア
        } catch {
            print("削除中にエラーが発生しました: \(error)")
        }
    }
}


