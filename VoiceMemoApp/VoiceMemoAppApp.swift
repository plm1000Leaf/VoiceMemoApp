import SwiftUI
import CoreData
@main
struct VoiceMemoAppApp: App {
    // Core Dataのコンテナ
    let persistentContainer = NSPersistentContainer(name: "Model") // モデル名
    init() {
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.viewContext) // 環境にコンテキストを追加
        }
    }
}

