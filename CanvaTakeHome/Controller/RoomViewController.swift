//
//  RoomViewController.swift
//  CanvaTakeHome
//
//  Created by Dean Parreno on 16/12/16.
//  Copyright © 2016 Dean Parreno. All rights reserved.
//

import UIKit
import TakeHomeTask


class RoomConnection {
    var room: String
    var connection: Connection
    
    init(room: String, connection: Connection) {
        self.room = room
        self.connection = connection
    }

}

class RoomViewController: UIViewController {
    
    var roomRelativeDirection = [RoomId:String]()

    
    @IBOutlet weak var imageView: UIImageView!
    var roomIds: [RoomId] = []
    var x: CGFloat = 0.0
    var y: CGFloat = 400.0
    var tileSize: CGFloat = 15.0

    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadStartingRoom()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func loadStartingRoom() {
        MazeManager.sharedInstance.fetchStartRoom { (roomOrError) in
            do {
                let roomIdentifier = try roomOrError()
                //print(roomIdentifier)
                
                // TODO: update initial room position
                self.loadRoomsRecursively(roomIdentifier: roomIdentifier, relativeDirection: .north, relatedTileImage: self.imageView )
            } catch {
                print(error)
            }
        }
    }
    
    func loadRoomsRecursively(roomIdentifier: RoomId,
                              relativeDirection: Direction,
                              relatedTileImage: UIImageView) {
        MazeManager.sharedInstance.fetchRoom(roomId: roomIdentifier, callback: { (room) in
            do {
                let room = try room()
                if self.roomIds.isEmpty || !self.roomIds.contains(roomIdentifier) {
                    print(roomIdentifier)
                    
                    
                    
                    switch relativeDirection {
                    case .north :
                        self.x = relatedTileImage.frame.origin.x
                        self.y = relatedTileImage.frame.origin.y + self.tileSize
                    case .south:
                        self.x = relatedTileImage.frame.origin.x
                        self.y = relatedTileImage.frame.origin.y - self.tileSize
                    case .east:
                        self.x = relatedTileImage.frame.origin.x + self.tileSize
                        self.y = relatedTileImage.frame.origin.y
                    case .west:
                        self.x = relatedTileImage.frame.origin.x - self.tileSize
                        self.y = relatedTileImage.frame.origin.y
                    }
                    let tileImage = UIImageView.init(frame: CGRect(x: self.x, y: self.y, width: self.tileSize, height: self.tileSize))

                   
                    tileImage.downloadedFrom(url: room.tileURL)
                   
                    DispatchQueue.main.async() { () -> Void in
//                        self.view.addConstraint(NSLayoutConstraint(item: tileImage,
//                                                                       attribute: .bottom,
//                                                                       relatedBy: .equal,
//                                                                       toItem: self.view,
//                                                                       attribute: .top,
//                                                                       multiplier: 1.0,
//                                                                       constant: 0.0))
                        self.view.addSubview(tileImage)

                    }
                    
//                    let tileImage = UIImageView.init()
//                    self.imageView.downloadedFrom(url: room.tileURL, tileImage:)
//                    self.imageView = tileImage

                   // self.imageView.frame = self.view.bounds
                    
                    
//                    self.view.addSubview(adjacentTile)
//                    
//                    DispatchQueue.main.async() { () -> Void in
//                        let tileImage = UIImageView.init(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
//                        tileImage.downloadedFrom(url: room.tileURL)
//                        self.imageView = tileImage
//                    }
//                    
                    
                    
                    // Adds roomID to array
                    self.roomIds.append(roomIdentifier)
                    
                    // Iterate through direction and connections
                    for (direction, connection) in room.connections {
                        print(direction, connection)
                        switch connection {
                        case .Room(let adjacentRoomId):
                            self.loadRoomsRecursively(roomIdentifier: adjacentRoomId,
                                                        relativeDirection: direction,
                                                        relatedTileImage: tileImage)
                        case .LockedRoom(let lockedRoom):
                            self.loadRoomsRecursively(roomIdentifier: self.unlockedRoom(lockedRoomId: lockedRoom),
                                                        relativeDirection: direction,
                                                        relatedTileImage: tileImage)
                        }
                    }
                }
            } catch {
                print(error)
            }
        })
        self.view.setNeedsLayout()
    }
    
    func placeTile() {
        
    }
    
    func unlockedRoom(lockedRoomId: LockId) -> RoomId {
        return MazeManager.sharedInstance.unlockRoom(lockId: lockedRoomId)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
        }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

