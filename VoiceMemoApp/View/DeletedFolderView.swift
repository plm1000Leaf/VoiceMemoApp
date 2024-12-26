//
//  ContentView.swift
//  VoiceMemoApp
//
//

import SwiftUI

struct DeletedFolderView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \VoiceMemoEntities.createdAt, ascending: false)],
        animation: .default
    ) private var voiceMemos: FetchedResults<VoiceMemoEntities>
    @State private var textFieldText: String = ""
    @State private var expandedIndex: Int? = nil
    
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
            
                }
            }
        }
    }
}

   

#Preview {
    DeletedFolderView()
}




extension DeletedFolderView {
    
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
            Text("編集")
                .font(.system(size: 20))
                .foregroundColor(.blue)
                .padding(.trailing, 20)
                .bold()
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
                        .padding(.leading, 35)
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
                        .padding(.trailing, 35)
                        .foregroundColor(Color("RecordingSFSymbleColor"))
                }
            }
            .padding(.bottom, 5)
            
            VStack(spacing: 27) {
                ForEach(voiceMemos, id: \.self) { memo in
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
                            Text(memo.title ?? "新規録音")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .bold()
                                .font(.system(size: 20))
                                .padding(.leading, 20)
                                .foregroundColor(.black)
                            Spacer()
                            HStack{
                                Text(memo.createdAt?.formatted() ?? "N/A")
                                    .padding(.leading, 20)
                                    .foregroundColor(Color("RecordingSFSymbleColor"))
                                Spacer()
                                Text("\(Int(memo.duration))秒")
                                    .padding(.trailing, 20)
                                    .foregroundColor(Color("RecordingSFSymbleColor"))
                            }
                            .padding(.bottom, -60)
                            
                        }
                        .frame(maxWidth: .infinity)
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
    
}

