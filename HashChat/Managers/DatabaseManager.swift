//
//  DatabaseManager.swift
//  HashChat
//
//  Created by Shilan on 14/03/2025.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class DatabaseManager {
    static let shared = DatabaseManager()
    private init() {}
    
    let db = Firestore.firestore()

    var storage = Storage.storage()
    private let cache = NSCache<NSString,UIImage>()

    // Create a storage reference from our storage service

    func fetchChats(completed: @escaping ([ChatRoom]) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        db.collection("users").document(currentUser.uid).collection("chats").order(by: "lastMessageTime", descending: true).addSnapshotListener { querySnapshpt, error in
            guard error == nil else { return completed([]) }
            guard let documents = querySnapshpt?.documents else { return completed([]) }
            
            var chats: [ChatRoom] = []
            for document in documents {
                do{
                    let chat = try document.data(as: ChatRoom.self)
                    chats.append(chat)
                }
                catch{
                  print(error)
                }
            }
            return completed(chats)
        }
    }
    
    
    
    func fetchRegisteredUsers(from contacts: [Contact]) async -> [User] {
        var registeredUsers: [User] = []
        for contact in contacts {
            guard let email = contact.emails.first?.lowercased() else { continue }
            do{
                let querySnapshot = try await db.collection("users")
                    .whereField("email", isEqualTo: email)
                    .getDocuments()
                
                let users = try querySnapshot.documents.compactMap { document -> User? in
                    var user = try document.data(as: User.self)
                    user.name = contact.fullName ?? contact.givenName
                    return user
                }
                registeredUsers.append(contentsOf: users)
            }catch{
                print(error)
                return []
            }
        }
        return registeredUsers
    }
    
    
    
    func addChatRoom(chatRoom: ChatRoom) async throws {
        do {
            guard let currentUser = Auth.auth().currentUser else { return }
            try db.collection("users").document(currentUser.uid).collection("chats").document(chatRoom.id).setData(from: chatRoom)
            print("Document added with ID: \(chatRoom.id)")
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
    
    
    func addChatRoom(chatRoom: ChatRoom,with friendId: String) async throws {
        do {
            guard let currentUser = Auth.auth().currentUser else { return }
            try db.collection("users").document(friendId).collection("chats").document(chatRoom.id).setData(from: chatRoom)

            print("Document added with ID: \(chatRoom.id)")
        } catch {
          print("Error adding document: \(error)")
        }
    }

    
    
    func deleteChat(withId id: ChatRoom.ID) async {
        do {
            guard let currentUser = Auth.auth().currentUser else { return }

            var messages = try await db.collection("users").document(currentUser.uid).collection("chats").document(id).collection("messages").getDocuments()
            for message in messages.documents {
                try await db.collection("users").document(currentUser.uid).collection("chats").document(id).collection("messages").document(message.documentID).delete()
            }
            try await db.collection("users").document(currentUser.uid).collection("chats").document(id).delete()
          print("Document successfully removed!")
        } catch {
          print("Error removing document: \(error)")
        }
    }
    
    
    
    func deleteFriendChat(){
    
    }
    
    
    
    func addMessage(userId: String, chatRoomId: String, message: Message) {
        Task { @MainActor in
            do {
                try db.collection("users").document(userId).collection("chats").document(chatRoomId).collection("messages").addDocument(from: message)
                print("messages added suceessfully.")
            } catch {
                print("Error adding document: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    func deleteMessage(){
        
    }
    
    
    
    func quaryDatabase(for user: User) async -> ChatRoom? {
        guard let currentUser = Auth.auth().currentUser else { return nil}
        
        let chatsRef = db.collection("users").document(currentUser.uid).collection("chats")
        var chat: ChatRoom? = nil
        do {
            let querySnapshot = try await chatsRef.whereField("name", isEqualTo: user.name).getDocuments()
            for document in querySnapshot.documents {
                chat = try document.data(as: ChatRoom.self)
                return chat
            }
        } catch {
            print("Error getting documents: \(error)")
            return nil
        }
        return chat
    }
    
    
      
    func update(chatRoom: ChatRoom , forUserId userId: String) {
        let chatRoomRef = db.collection("users").document(userId).collection("chats").document(chatRoom.id)
        do {
            try chatRoomRef.setData(from: chatRoom)
        } catch let error {
          print("Error updating chat room: \(error)")
        }
    }
    
    
    
    func updateRecipient(chatRoom: ChatRoom , forUserId userId: String) {
        let chatRoomRef = db.collection("users").document(userId).collection("chats").document(chatRoom.id)
        do {
            try chatRoomRef.setData(from: chatRoom)
        } catch let error {
          print("Error updating chat room: \(error)")
        }
    }
    
    
    
    func fetchMessagesWithListener(from chat: ChatRoom,completed: @escaping (Result<[Message], ChatAppError>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let listener = db.collection("users").document(currentUser.uid).collection("chats").document(chat.id).collection("messages").order(by:"timestamp", descending: false).addSnapshotListener({ [weak self] querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else {
                completed(.failure(.errorGettingDocumentsFromDatabase))
                return
            }
            if documents.isEmpty {
                completed(.success([])) // I should handle the empty array later in the caller
                //self?.tableViewState = .empty
            }else{
                let messages = documents.compactMap { queryDocumentSnapshot -> Message? in
                    do {

                        let message = try queryDocumentSnapshot.data(as: Message.self)
                        //self?.tableViewState = .dataLoaded
                        return message
                    }catch{
                        print("Error updating messages array.")
                        return nil
                    }
                }
                completed(.success(messages))
            }
        })
    }
    
    
    
    func fetchMessages(from chat: ChatRoom) async {
        guard let currentUser = Auth.auth().currentUser else { return }
        do {
            let querySnapshot = try await db.collection("users").document(currentUser.uid).collection("chats").document(chat.id).collection("messages").order(by:"timestamp", descending: false).getDocuments()
            for document in querySnapshot.documents {
                //print("\(document.documentID) => \(try document.data(as: Message.self))")
            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }
  
    
    
    func uploadProfilePhoto(local urlString: String) {
        storage = Storage.storage(url:"gs://hashchat-7d31f.firebasestorage.app")
        let storageRef = storage.reference()
        guard let user = Auth.auth().currentUser else {
            print("There is no logged in user to upload image for")
            return }
        let avatarRef = storageRef.child("images/\(user.uid).jpg")
        
        let localUrl = URL(string: urlString)
        guard let localUrl = localUrl else { return }
        let uploadTask = avatarRef.putFile(from: localUrl, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                //alert
                return
            }
            avatarRef.downloadURL { (url, error) in
                Task{
                    guard let downloadURL = url else {
                        return
                    }
                    await self.updateUser(user: user, with: ["imageUrl": "images/\(user.uid).jpg"])
                }
            }
        }
    }
   
    
    private var downloadingUrls: [String: Task<UIImage?, Never>] = [:]
    private let stateQ = DispatchQueue(label: "imageloader.state") // serialize state
    
    func downloadImage(from url: String, maxBytes: Int64 = 4 * 1024 * 1024) async -> UIImage? {
        if let cachedImage = cache.object(forKey: url as NSString) {
            return cachedImage
        }
        storage = Storage.storage(url:"gs://hashchat-7d31f.firebasestorage.app")
        let storageRef = storage.reference()
        let avatarRef = storageRef.child(url)
        
        
        let task: Task<UIImage?, Never> = stateQ.sync {
             if let existing = downloadingUrls[url] { return existing }

             let newTask = Task<UIImage?, Never> {
                 let ref: StorageReference = url.hasPrefix("http")
                     ? Storage.storage().reference(forURL: url)
                     : Storage.storage(url: "gs://hashchat-7d31f.firebasestorage.app")
                         .reference().child(url)

                 let img: UIImage? = await withCheckedContinuation { cont in
                     ref.getData(maxSize: maxBytes) { [weak self] data, error in
                         var result: UIImage? = nil
                         if error == nil, let data { result = UIImage(data: data) }
                         if let result { self?.cache.setObject(result, forKey: url as NSString) }
                         cont.resume(returning: result)
                     }
                 }
                 return img
             }

            downloadingUrls[url] = newTask
             return newTask
         }
        
//        if let image = await enqueueWaiterOrStart(url, maxBytes: maxBytes) { return image }
//        let image: UIImage? = await withCheckedContinuation { continuation in
//            
//            avatarRef.getData(maxSize: maxBytes) { [weak self] data, error in
//                let img: UIImage?
//                if error == nil, let data = data {
//                    img = UIImage(data: data)
//                } else {
//                    img = nil
//                }
//                if let img = img {
//                    self?.cache.setObject(img, forKey: url as NSString)
//                }
//                continuation.resume(returning: img)
//            }
//        }
        let image = await task.value
        stateQ.async {
            self.downloadingUrls[url] = nil
        }
        return image
    }
    
    
    
//    func downloadImage(from url: String, completed: @escaping (UIImage?) -> Void)  {
//        
//        
//        if let cachedImage = cache.object(forKey: url as NSString) {
//            DispatchQueue.main.async{
//                completed(cachedImage)
//                return
//            }
//        }
//        
//        if downloadingUrls.contains(url) { return }       // prevents duplicate fetch for same key
//        downloadingUrls.insert(url)
//        
//        storage = Storage.storage(url:"gs://hashchat-7d31f.firebasestorage.app")
//        let storageRef = storage.reference()
//        let avatarRef = storageRef.child(url)
//        
//        //var image: UIImage?
//        avatarRef.getData(maxSize: 1 * 1024 * 1024) { [weak self] data, error in
//            DispatchQueue.main.async {
//                guard let self = self else {return}
//                self.downloadingUrls.remove(url)
//                
//                if let error = error {
//                    print("Image download error:", error)
//                    completed(nil)
//                    return
//                }
//                guard let data = data, let image = UIImage(data: data) else {
//                    completed(nil)
//                    return
//                }
//                
//                self.cache.setObject(image, forKey: url as NSString)
//                completed(image)
//            }
//        }
//    }
    

    
    func currentCustomUser() async -> User? {
        if Auth.auth().currentUser != nil {
            guard let  currentUser = Auth.auth().currentUser else { return nil }
            let ref = db.collection("users").document(currentUser.uid)
            
            do {
                let user = try await ref.getDocument(as: User.self)
                return user
            } catch {
                print("Error decoding: \(error)")
                return nil
            }
        } else {
            return nil
        }
    }


    
    func addUserToFirestore(user: User) {
        Task{
            do {
                let ref = db.collection("users").document(user.id)
                try ref.setData(from: user)
                print("User added with ID: \(ref.documentID) \(user.id)")
            } catch {
                print("Error adding user to firestore: \(error)")
            }
        }
    }
    
    
    
    func updateUser(user: FirebaseAuth.User, with data: [String: Any]) async {
        do {
          try await db.collection("users").document(user.uid).setData(data, merge: true)
          print("Document successfully written!")
        } catch {
          print("Error writing document: \(error)")
        }
    }
    
}
