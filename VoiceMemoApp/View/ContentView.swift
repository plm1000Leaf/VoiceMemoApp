//
//  ContentView.swift
//  VoiceMemoApp
//
//

import SwiftUI
import CoreData

struct ContentView: View {

    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \VoiceMemoEntities.createdAt, ascending: false)],
        animation: .default
    ) private var voiceMemos: FetchedResults<VoiceMemoEntities>
    @State private var textFieldText: String = ""
    @State private var expandedIndex: Int? = nil
    @State private var isEditing: Bool = false
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
                        EditBottomView()
                    } else {
                        RecodingButtonView(context: context)
                    }
                }
            }
        }
    }
}

   

#Preview {
    ContentView()
}




extension ContentView {
    
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
        Text("すべての録音")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.largeTitle)
            .padding(.leading, 20)
            .padding([.top, .bottom], 5)
            .bold()
            .font(.system(size: 100))
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
                        ZStack() {
                            
                            VStack {
                                Rectangle()
                                    .frame(width: 370, height: 1)
                                    .frame(maxHeight: .infinity, alignment: .trailing)
                                    .foregroundColor(Color("RecordingMemoLine"))
                                    .padding(.top, 15)
                                Text(memo.location ?? "不明な場所")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .bold()
                                    .font(.system(size: 20))
                                    .padding(.leading, 20)
                                    .foregroundColor(.black)
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
                            .padding(.leading, 60)
                            .frame(maxWidth: .infinity)
                            
                            Circle()
                                .fill(selectedMemos.contains(memo.objectID) ? Color.blue : Color.clear)
                                .overlay(
                                    Circle().stroke(Color("RecordingMemoLine"), lineWidth: 2)
                                )
                                .frame(width: 25, height: 25)
                                .offset(x: -160, y: 30)
                                .onTapGesture {
                                    toggleSelection(for: memo.objectID)
                                }
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
                                Text(memo.location ?? "不明な場所")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .bold()
                                    .font(.system(size: 20))
                                    .padding(.leading, 20)
                                    .foregroundColor(.black)
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
        let title = "新規録音 (\(location))"
        
        // Core Dataに新しいメモを追加
        VoiceMemoModel.addVoiceMemo(
            title: title,
            duration: 120.0, // 仮の録音時間
            context: context
        )
    }
}

