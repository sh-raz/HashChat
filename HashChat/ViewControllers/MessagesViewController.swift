//
//  ChatViewController.swift
//  HashChat
//
//  Created by shilani on 09/07/2024.
//

import UIKit
import AVFoundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
//    enum TableViewState {
//        case loading
//        case empty
//        case dataLoaded
//    }
    
    //Firebase Variables
    let dbManager = DatabaseManager.shared
    let db = Firestore.firestore()
    var handle: AuthStateDidChangeListenerHandle?
    var listner: ListenerRegistration?
    
    //local variables
    var messages: [Message] = []
    var reversedMessages: [Message] {
        return messages.reversed()
    }
    var currentUser: User?
    var messageSender: String?
    var friend: User?
    var hasChatRoom = false
    var chatRoom: ChatRoom? = nil
    
    //UI Variables
    var tableView = UITableView()
    let containerView = UIView()
    var messageStackView = UIStackView()
    var sendButton = UIButton(type: .custom)
    var messageTextField = MessageTextField()
    
    //var tableViewState: TableViewState = .loading
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        configureUI()
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(customBackButtonTapped))
            navigationItem.leftBarButtonItem = backButton
        
        Task{
            currentUser = await dbManager.currentCustomUser()
            getMessagesFromDatabase()
        }
    }
    
    
    
    @objc func customBackButtonTapped() {
        if let navigationController = self.navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    init(with user: User){
        super.init(nibName: nil, bundle: nil)
        self.friend = user
        
    }
    init(chatRoom: ChatRoom) {
        super.init(nibName: nil, bundle: nil)
        self.chatRoom = chatRoom
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        tableView.reloadData()
        handle = Auth.auth().addStateDidChangeListener { auth, currentUser in
            if let currentUser = currentUser {
                self.messageSender = currentUser.email
            }
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    
    
    // MARK: -Send message functions
    
    @objc func sendButtonPressed() {
        Task {
            guard let currentUser = await dbManager.currentCustomUser() else { return }
            if chatRoom == nil, let friend = friend {
                let message = Message(text: messageTextField.text!, sender: currentUser, recipient: friend, timestamp: Date())
                
                self.chatRoom = ChatRoom(chatImage: friend.imageUrl , recipient: friend, lastMessage: message.text, lastMessageTime: message.timestamp)
                add(chatRoom: chatRoom!)
                
                guard let chatRoom = chatRoom else {return}
                var friendChatRoom = chatRoom
                friendChatRoom.chatImage = currentUser.imageUrl
                friendChatRoom.recipient = currentUser
                addFriendChat(chatRoom: friendChatRoom, with: friend.id)
                
                messages.append(message)
                addMessage(toUserWithId: currentUser.id, chatRoomId: chatRoom.id, message: message)
                addMessage(toUserWithId: friend.id, chatRoomId: chatRoom.id, message: message)
                
            }else if let chatRoom = chatRoom {
                let message = Message(text: messageTextField.text!, sender: currentUser, recipient: chatRoom.recipient, timestamp: Date())
                self.chatRoom?.lastMessage = message.text
                self.chatRoom?.lastMessageTime = message.timestamp
                dbManager.update(chatRoom: self.chatRoom!, forUserId: currentUser.id)

                var recipientChatRoom = self.chatRoom
                recipientChatRoom?.chatImage = currentUser.imageUrl
                recipientChatRoom?.recipient = currentUser
                dbManager.updateRecipient(chatRoom: recipientChatRoom!, forUserId: chatRoom.recipient.id)

                messages.append(message)
                addMessage(toUserWithId: currentUser.id, chatRoomId: chatRoom.id, message: message)
                addMessage(toUserWithId: chatRoom.recipient.id, chatRoomId: chatRoom.id, message: message)
            }
            DispatchQueue.main.async{
                self.updateUIOnTheMainThread()
            }
        }
    }
   


        
   
//        Task{
//            if let currentUser = await dbManager.currentCustomUser() {
//
//                if chatRoom == nil {
//                    var message = Message(text: messageTextField.text!, sender: currentUser, recipient: friend?.email, timestamp: Date())
//                    
//                    chatRoom = ChatRoom(chatImage: friend.imageUrl , name: friend.name, sender: currentUser, recipient: friend, lastMessage: message.text, lastMessageTime: message.timestamp)
//                    add(chatRoom: chatRoom!)
//                    
//                    let friendChatRoom = ChatRoom(chatImage: currentUser.imageUrl , name: currentUser.name, sender: currentUser, recipient: currentUser, lastMessage: message.text, lastMessageTime: message.timestamp)
//                    addFriendChat(chatRoom: friendChatRoom, with: friend.id)
//                    hasChatRoom = true
//                    messages.append(message)
//                    guard let chatRoom = chatRoom else {return}
//                    addMessages(message: message, toChatRoomWithId: chatRoom.id)
//                }else if friend == nil {
//                     var message = Message(text: messageTextField.text!, sender: messageSender!, recipient: chatRoom!.participent, timestamp: Date())
//                    messages.append(message)
//                    guard let chatRoom = chatRoom else {return}
//                    addMessages(message: message, toChatRoomWithId: chatRoom.id)
//                }
//            }
//        }
//        messages.append(message)
//        guard let chatRoom = chatRoom else {return}
//        addMessages(message: message, toChatRoomWithId: chatRoom.id)
//        updateUIOnTheMainThread()
//    }
    
   
    
    func add(chatRoom: ChatRoom){
        Task{ @MainActor in
            do{
                try await dbManager.addChatRoom(chatRoom: chatRoom)
                print("Room added suceessfully.")
            }catch{
                print("Error adding Room document: \(error.localizedDescription)")
            }
        }
    }
    
    func addFriendChat(chatRoom: ChatRoom, with friendId: String){
        Task{ @MainActor in
            do{
                try await dbManager.addChatRoom(chatRoom: chatRoom, with: friendId)
                print("Room added suceessfully.")
            }catch{
                print("Error adding Room document: \(error.localizedDescription)")
            }
        }
    }
    
    
    func addMessage(toUserWithId id: String, chatRoomId: String, message: Message){
        dbManager.addMessage(userId: id, chatRoomId: chatRoomId, message: message)
    }
    
    
//    func addFriendMessage(userId: String, chatRoomId: String, message: Message){
//        dbManager.addMessage(userId: userId, chatRoomId: chatRoomId, message: message)
//    }
    
    
    @objc func logOutButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    //MARK: - Fetch data from Firestore
    
    func queryForDocumentExistence() async throws {
        //tableViewState = .loading
        tableView.reloadData()
        do{
            guard let id = chatRoom?.id else { return }
            print(id)
            let document = try await db.collection("chats").document(id).getDocument()
            if document.data() == nil {
                print("messages document.data() == nil")
                hasChatRoom = false
                self.updateUIOnTheMainThread()
            }else{
                hasChatRoom = true
                getMessagesFromDatabase()
            }
        }catch{
            print(error)
            throw error
        }
    }
    
    
    func getMessagesFromDatabase() {
        messages = []
        guard let chatRoom = chatRoom else {return}
        dbManager.fetchMessagesWithListener(from: chatRoom) { result in
            switch result {
            case .success(let messages):
                self.messages = messages
                if messages.isEmpty {
                }
            case .failure( _):
                self.showAlertVCOnTheMainThread(title: "Error Fetching Messages", message: "Error fetching messages From Database", buttonTitle: "OK")
            }
            DispatchQueue.main.async{
                self.updateUIOnTheMainThread()
            }
        }
        
    }
    
    
    func updateUIOnTheMainThread() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
            if !self.messages.isEmpty{
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
            }
            self.messageTextField.text = ""
            self.messageTextField.placeholder = "Message"
        }
    }
    
    
    
    //MARK: -TableView delegate and dataSource methods
    
    func configureTableView(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(LoadingCell.self, forCellReuseIdentifier: "LoadingCell")
        tableView.register(EmptyCell.self, forCellReuseIdentifier: "EmptyMessagesCell")
        tableView.register(RightMessageCell.self, forCellReuseIdentifier: RightMessageCell.reuseID)
        tableView.register(LeftMessageCell.self, forCellReuseIdentifier: LeftMessageCell.reuseID)
        tableView.showsVerticalScrollIndicator = false
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(deleteMessage))
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    
    @objc func deleteMessage() {
        print("deleteMessage")
        tableView.isEditing = true
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch tableViewState {
//        case .loading:
//            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.reuseID, for: indexPath) as! LoadingCell
//            cell.setIndicatoreViewPosition(constant: keyboardHeight)
//            return cell
//
//        case .empty:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyMessagesCell", for: indexPath) as! EmptyCell
//            cell.setEmptyViewPosition(constant: keyboardHeight)
//            tableView.transform = CGAffineTransform(scaleX: 1, y: 1)
//            return cell
//
//        case .dataLoaded:

        let newIndex = -(1 + (indexPath.row - messages.count)) // 2 1 0
        let newIndexPath = IndexPath(row: newIndex, section: 0)
        tableView.transform = CGAffineTransformMakeScale(1, -1)
        
        if newIndex >= 0 && newIndex < messages.count {
            guard let sender = messages[newIndexPath.row].sender else {return UITableViewCell()}
            if sender == currentUser {
                let cell = tableView.dequeueReusableCell(withIdentifier: RightMessageCell.reuseID, for: newIndexPath) as! RightMessageCell
                cell.set(messageText: messages[newIndexPath.row].text)
                let intended = newIndexPath

                if let profileImageUrl = sender.imageUrl {
                    Task{
                        guard let img = await dbManager.downloadImage(from: profileImageUrl) else { return }
                        await MainActor.run {
                            cell.setImage(image: img)
                        }
                    }
                    
//                    dbManager.downloadImage(from: profileImageUrl) { image in
//                        if let image = image {
//                            cell.setImage(image: image)
//                        }else{
//                            cell.setImage(image: UIImage(resource: .profile))
//                        }
//                    }
                }else {
                    cell.setImage(image: UIImage(resource: .profile))
                }
                cell.transform = CGAffineTransformMakeScale(1, -1)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: LeftMessageCell.reuseID, for: newIndexPath) as! LeftMessageCell
                cell.set(messageText: messages[newIndexPath.row].text)
                if let profileImageUrl = messages[newIndexPath.row].sender!.imageUrl {
                    Task{
                        guard let img = await dbManager.downloadImage(from: profileImageUrl) else { return }
                        await MainActor.run {
                            cell.setImage(image: img)
                        }
                    }
//                    dbManager.downloadImage(from: profileImageUrl) { image in
//                        if let image = image {
//                            cell.setImage(image: image)
//                        }else{
//                            cell.setImage(image: UIImage(resource: .profile))
//                        }
//                    }
                }else {
                    cell.setImage(image: UIImage(resource: .profile))
                }
                cell.transform = CGAffineTransformMakeScale(1, -1)
                return cell
            }
        }
        return UITableViewCell()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch tableViewState {
//        case .loading:
//            return 1
//        case .empty:
//            return 1
//        case .dataLoaded:
            return messages.count
      //  }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch tableViewState {
//        case .loading:
//            return tableView.bounds.height
//        case .empty:
//            return tableView.bounds.height
  //      case .dataLoaded:
            return UITableView.automaticDimension
  //      }
    }
    
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return !messages.isEmpty
    }
   

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        <#code#>
//    }
//    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        <#code#>
//    }
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        
//    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.isEditing = false
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
            completion(true)
        }
        if let trashImage = UIImage(systemName: "trash") {
            trashImage.withTintColor(.white)
            deleteAction.image = UIImage(cgImage: trashImage.cgImage!, scale: trashImage.scale, orientation: .down)
        }
        
        var configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    
    //MARK: - keyboard methods
    
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var isKeyboardActive: Bool = false
    var keyboardHeight: CGFloat = 0
    @objc func keyboardWillShow(notification: NSNotification) {
        if let kHeight = getKeyboardHeight(from: notification) {
            isKeyboardActive = true
            keyboardHeight = kHeight
            tableView.reloadData()
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardHeight = 0
        tableView.reloadData()
    }
    
    
    private func getKeyboardHeight(from notification: NSNotification) -> CGFloat? {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return nil
        }
        let keyboardRectangle = keyboardFrame.cgRectValue
        return keyboardRectangle.height
    }
    
    // BUG: when user search for an emojy and then press the close button of the emoji search there will be a black area on top of keyboard
    private func adjustViewForKeyboardHeight(keyboardHeight: CGFloat) {
        // Example: Adjust table view content inset
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    
    private func resetViewForKeyboard() {
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    //You are the best momm ever
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
    
    
    //MARK: - UI Configeration
    
    func configureUI() {
        configureMainView()
        configureTypeAndSendView()
        configureTableView()
    }
    
    
    func configureMainView(){
        //Configure view properties
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = false
        //Add the view"s subView
        view.addSubview(tableView)
        view.addSubview(containerView)
        
        //Layout subViews
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.topAnchor),
            
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    func configureContainerView(){
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageStackView)
    }
    
    
    func configureTypeAndSendView() {
        configureContainerView()
        
        //Configure view properties
        messageStackView.axis = .horizontal
        messageStackView.distribution = .fill
        messageStackView.alignment = .bottom
        messageStackView.spacing = 5
        messageStackView.translatesAutoresizingMaskIntoConstraints = false
                
        messageStackView.addArrangedSubview(messageTextField)
        messageStackView.addArrangedSubview(sendButton)
        
        //Layout subViews
        configureSendButton()
        NSLayoutConstraint.activate([
            messageStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            messageStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            messageStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
            messageStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            messageTextField.leadingAnchor.constraint(equalTo: messageStackView.leadingAnchor, constant: 20),
            messageTextField.bottomAnchor.constraint(equalTo: messageStackView.bottomAnchor, constant: -5),
            messageTextField.heightAnchor.constraint(equalToConstant: 50),
            
            sendButton.trailingAnchor.constraint(equalTo: messageStackView.trailingAnchor, constant: -20),
            sendButton.widthAnchor.constraint(equalToConstant: 50),
            sendButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    
    func configureSendButton() {
        sendButton.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        sendButton.imageView?.contentMode = .scaleAspectFit
        sendButton.contentHorizontalAlignment = .fill
        sendButton.contentVerticalAlignment = .fill
        sendButton.tintColor = UIColor(resource: .blue)
        sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
    }
}
    
    

//AVFoundation methods
/*
extension MessagesViewController: AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    //Link: https://stackoverflow.com/questions/26472747/recording-audio-in-swift
    
    func checkRecordPermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                if allowed {
                    self.isAudioRecordingGranted = true
                } else {
                    self.isAudioRecordingGranted = false
                }
            })
            break
        default:
            break
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getFileUrl() -> URL {
        let filename = "myRecording.m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    func setup_recorder() {
        if isAudioRecordingGranted
        {
            let session = AVAudioSession.sharedInstance()
            do
            {
                try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            }
            catch let error {
                showAlertVCOnTheMainThread(title: "error", message: error.localizedDescription, buttonTitle: "OK")
            }
        }
        else
        {
            showAlertVCOnTheMainThread(title: "error", message: "Don't have access to use your microphone.", buttonTitle: "OK")
        }
    }
    
    @objc func start_recording(_ sender: UIButton) {
        if(isRecording)
        {
            finishAudioRecording(success: true)
            record_btn_ref.setTitle("Record", for: .normal)
            play_btn_ref.isEnabled = true
            isRecording = false
        }
        else
        {
            setup_recorder()
            
            audioRecorder.record()
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
            record_btn_ref.setTitle("Stop", for: .normal)
            play_btn_ref.isEnabled = false
            isRecording = true
        }
    }
    
    @objc func updateAudioMeter(timer: Timer) {
        if audioRecorder.isRecording
        {
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            recordingTimeLabel.text = totalTimeString
            audioRecorder.updateMeters()
        }
    }
    
    func finishAudioRecording(success: Bool) {
        if success
        {
            audioRecorder.stop()
            audioRecorder = nil
            meterTimer.invalidate()
            print("recorded successfully.")
        }
        else
        {
            showAlertVCOnTheMainThread(title: "Error", message: "Recording failed.", buttonTitle: "OK")
        }
    }
    
    func prepare_play() {
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        }
        catch{
            print("Error")
        }
    }
    
    @IBAction func play_recording(_ sender: Any) {
        if(isPlaying)
        {
            audioPlayer.stop()
            record_btn_ref.isEnabled = true
            play_btn_ref.setTitle("Play", for: .normal)
            isPlaying = false
        }
        else
        {
            if FileManager.default.fileExists(atPath: getFileUrl().path)
            {
                record_btn_ref.isEnabled = false
                play_btn_ref.setTitle("pause", for: .normal)
                prepare_play()
                audioPlayer.play()
                isPlaying = true
            }
            else
            {
                showAlertVCOnTheMainThread(title: "Error", message: "Audio file is missing.", buttonTitle: "OK")
            }
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag
        {
            finishAudioRecording(success: false)
        }
        play_btn_ref.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        record_btn_ref.isEnabled = true
    }
  */

