import SwiftUI

struct Test_View: View {
    
    @State private var showTab: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // 背景
            Color("RecordingBottomColor")
                .ignoresSafeArea()
            
            // 上方向に広がるアニメーション部分
            if showTab {
                VStack(spacing: 0) {
                    // 広がる領域
                    Rectangle()
                        .frame(height: 200) // 高さは適宜調整
                        .foregroundColor(Color("ExpandedAreaColor"))
                        .cornerRadius(10, corners: [.topLeft, .topRight]) // 上端のみ角丸
                        .transition(.move(edge: .top)) // 上方向にスライドするアニメーション
                    
                    Spacer()
                }
                .animation(.easeInOut, value: showTab)
            }
            
            // 録音ボタン（固定）
            Button(action: {
                withAnimation {
                    showTab.toggle()
                }
            }) {
                ZStack {
                    Circle()
                        .stroke(Color("RecordingButtonLineColor"), lineWidth: 5)
                        .frame(width: 80, height: 80)
                    Circle()
                        .foregroundColor(Color("RecordingButtonColor"))
                        .frame(width: 65, height: 65)
                }
            }
            .padding(.bottom, 30) // ボタンを画面下端から少し浮かせる
        }
    }
}

// 角丸カスタマイズ用の拡張
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    Test_View()
}

