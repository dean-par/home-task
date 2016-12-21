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
    
    @IBOutlet weak var imageView: UIImageView!
    var roomIds: [RoomId] = []
    var x: CGFloat = 0.0
    var y: CGFloat = 400.0
    var tileSize: CGFloat = 7.0

    
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
                        if self.y <= self.view.frame.origin.y {
                            self.shiftTiles(direction: .north)
                        }
                    case .south:
                        self.x = relatedTileImage.frame.origin.x
                        self.y = relatedTileImage.frame.origin.y - self.tileSize
                        if self.y > self.view.frame.origin.y + self.view.frame.height {
                          //  self.shiftTiles(direction: .south)
                        }
                    case .east:
                        self.x = relatedTileImage.frame.origin.x + self.tileSize
                        self.y = relatedTileImage.frame.origin.y
                        if self.x > self.view.frame.origin.x + self.view.frame.width {
                           // self.shiftTiles(direction: .east)
                        }
                    case .west:
                        self.x = relatedTileImage.frame.origin.x - self.tileSize
                        self.y = relatedTileImage.frame.origin.y
                        if self.x <= self.view.frame.origin.x {
                            self.shiftTiles(direction: .west)
                        }
                    }
                   
                    let tileImage = UIImageView.init(frame: CGRect(x: self.x, y: self.y, width: self.tileSize, height: self.tileSize))
                    tileImage.downloadedFrom(url: room.tileURL)
                    self.view.addSubview(tileImage)

                   
//                        self.view.addConstraint(NSLayoutConstraint(item: tileImage,
//                                                                       attribute: .bottom,
//                                                                       relatedBy: .equal,
//                                                                       toItem: self.view,
//                                                                       attribute: .top,
//                                                                       multiplier: 1.0,
//                                                                       constant: 0.0))
                        self.view.addSubview(tileImage)

                    
                    
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
    
    func shiftTiles(direction: Direction) {
        DispatchQueue.main.async() { () -> Void in

            for subview in self.view.subviews {
                switch direction {
                case .north:
                    subview.frame.origin.y += self.tileSize
                case .south:
                    subview.frame.origin.y -= self.tileSize
                case .east:
                    subview.frame.origin.x -= self.tileSize
                case .west:
                    subview.frame.origin.x += self.tileSize
               // case .south: for subview in self.view.subviews {subview.frame.origin.y -= self.tileSize}
                //case .east: for subview in self.view.subviews {subview.frame.origin.x -= self.tileSize}
                //case .west: for subview in self.view.subviews {subview.frame.origin.x += self.tileSize}
                }
            }
        }
        
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

