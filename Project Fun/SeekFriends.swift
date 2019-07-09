//
//  SeekFriends.swift
//  CubeKing
//
//  Created by Maxwell Smith on 12/26/18.
//  Copyright © 2018 Maxwell Smith. All rights reserved.
//


import UIKit
import Cartography
import MultiPeer
final class SeekFriends: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
    // MARK: Properties
    fileprivate let startGameButton = UIButton(type: .system)
    fileprivate let backButton = UIButton(type: .system)
    fileprivate let separator = UIView()
    fileprivate let collectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        setupNavigationBar()
        setupLaunchImage()
        setupStartGameButton()
        setupSeparator()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MultiPeer.instance = MultiPeer()
       connectionHandler.ConnectionManager.start()
      connectionHandler.ConnectionManager.waitingPage = self
        Global.global.isOnline = true
          let wifi =  UserDefaults.standard.bool(forKey: "wifi")
        if !(wifi){
       UserDefaults.standard.set(true, forKey: "wifi") //Bool
        let alert = UIAlertController(title: "Enable Wifi/Bluetooth", message: "Enable Wifi/Bluetooth to match with players easier", preferredStyle: .alert)
      
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
        // connectionHandler.ConnectionManager.end()
        connectionHandler.ConnectionManager.waitingPage = nil
   
        MultiPeer.instance.stopSearching()
         // Global.global.isOnline = true
        super.viewWillDisappear(animated)
    }
    
    // MARK: UI
    fileprivate func setupNavigationBar() {
       
    }
    
    fileprivate func setupLaunchImage() {
        view.addSubview(UIImageView(image: UIImage(named: "man")))
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.frame = view.bounds
        view.addSubview(blurView)
    }
    
    fileprivate func setupStartGameButton() {
        // Button
        startGameButton.translatesAutoresizingMaskIntoConstraints = false
        startGameButton.titleLabel!.font = startGameButton.titleLabel!.font.withSize(25)
        startGameButton.setTitle("Waiting For Players", for: .disabled)
        startGameButton.setTitle("Start Game", for: UIControl.State())
       startGameButton.addTarget(self, action: #selector(startBtn), for: .touchUpInside)
        startGameButton.isEnabled = false
        view.addSubview(startGameButton)
        
        // Layout
        constrain(startGameButton) { button in
            button.top == button.superview!.top + 60
            button.centerX == button.superview!.centerX
        }
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.titleLabel!.font = startGameButton.titleLabel!.font.withSize(15)

        backButton.setTitle("Back", for: UIControl.State())
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        backButton.tintColor = .gray
        view.addSubview(backButton)
        
        // Layout
        constrain(backButton) { button in
            button.top == button.superview!.top + 10
            button.left == (button.superview?.leftMargin)!
            button.width == 60
            
           
        }
    }
    @objc func back(){
        performSegue(withIdentifier: "home", sender: nil)
    }
    
    fileprivate func setupSeparator() {
        // Separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.gray
        view.addSubview(separator)
        
        // Layout
        constrain(separator, startGameButton) { separator, startGameButton in
            separator.top == startGameButton.bottom + 10
            separator.centerX == separator.superview!.centerX
            separator.width == separator.superview!.width - 40
            separator.height == 1 / UIScreen.main.scale
        }
    }
    @objc func startBtn(){
         MultiPeer.instance.stopSearching()
        MultiPeer.instance.send(object: "Test", type: DataType.start.rawValue)
        self.performSegue(withIdentifier: "start", sender: self)
    }
    
    func start(){
          MultiPeer.instance.stopSearching()
        self.performSegue(withIdentifier: "start", sender: self)
    }
    fileprivate func setupCollectionView() {
        // Collection View
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PlayerCell.self, forCellWithReuseIdentifier: PlayerCell.reuseID)
        collectionView.alwaysBounceVertical = true
        view.addSubview(collectionView)
        
        // Layout
        constrain(collectionView, separator) { collectionView, separator in
            collectionView.top == separator.bottom
            collectionView.left == separator.left
            collectionView.right == separator.right
            collectionView.bottom == collectionView.superview!.bottom
        }
    }
    

    
 
    
    func updatePlayers() {
        startGameButton.isEnabled = (MultiPeer.instance.connectedDeviceNames.count > 0)
        collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MultiPeer.instance.connectedDeviceNames.count
    }
    
    @objc func collectionView(_ collectionView: UICollectionView,
                              cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayerCell.reuseID,
                                                      for: indexPath) as! PlayerCell
        
        cell.label.text = MultiPeer.instance.connectedDeviceNames[indexPath.row]
        return cell
    }
    
    @objc func collectionView(_ collectionView: UICollectionView,
                              layout collectionViewLayout: UICollectionViewLayout,
                              sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 32, height: 50)
    }
}
