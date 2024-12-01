//
//  DeletedFolderView.swift
//  VoiceMemoApp
//
//  Created by 千葉陽乃 on 2024/11/29.
//

import SwiftUI

struct DeletedFolderView: View {
    @State private var textFieldText: String = ""
    @State private var expandedIndex: Int? = nil
    
    var body: some View {
        NavigationStack{
            VStack {
                headerArea

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
            NavigationLink(destination: VoiceMemoFolderView()){
                Image(systemName: "chevron.backward")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
                    .bold()
            }
            Text("編集")
                .font(.system(size: 20))
                .foregroundColor(.blue)
                .padding(.trailing, 20)
                .bold()
        }
    }
    
    private var titleArea: some View {
        Text("最近削除された項目")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.largeTitle)
            .padding(.leading, 20)
            .padding([.top, .bottom], 5)
            .bold()
            .font(.system(size: 100))
    }
    
    private var scrollArea: some View {
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
                ForEach(0..<1, id: \.self) { index in
                    Button(action: {
                        withAnimation {
                            // 同じ場所をタップしたら閉じる
                            if expandedIndex == index {
                                expandedIndex = nil
                            } else {
                                expandedIndex = index
                            }
                        }
                    }){
                        VStack {
                            Rectangle()
                                .frame(width: 370, height: 1)
                                .frame(maxHeight: .infinity, alignment: .trailing)
                                .foregroundColor(Color("RecordingMemoLine"))
                                .id(index) // IDを設定
                                .padding(.top, 15)
                            Text("新規録音\(index + 1)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .bold()
                                .font(.system(size: 20))
                                .padding(.leading, 20)
                                .foregroundColor(.black)
                            Spacer()
                            HStack{
                                Text("2024/11/14")
                                    .padding(.leading, 20)
                                    .foregroundColor(Color("RecordingSFSymbleColor"))
                                Spacer()
                                Text("00:00")
                                    .padding(.trailing, 20)
                                    .foregroundColor(Color("RecordingSFSymbleColor"))
                            }
                            .padding(.bottom, -60)
                            
                        }
                        .frame(maxWidth: .infinity)
                    }
                    if expandedIndex == index {
                        VStack {
                            SeekBarView()
                        }
                        
                    }
                }
            }

        }
    }
}
