//
//  RoomViewController.swift
//  CanvaTakeHome
//
//  Created by Dean Parreno on 16/12/16.
//  Copyright © 2016 Dean Parreno. All rights reserved.
//

import UIKit
import TakeHomeTask

class RoomViewController: UIViewController {
    
    @IBOutlet weak var squareView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var roomIds: [RoomId] = []
    var x: CGFloat = 0.0
    var y: CGFloat = 400.0
    var tileSize: CGFloat = 10.0

    
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
                self.squareView.translatesAutoresizingMaskIntoConstraints = false
                let newView = UIView()
                newView.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(newView)

                newView.backgroundColor = UIColor.green
                
       
                let width = NSLayoutConstraint(item: newView,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: self.squareView,
                                                     attribute: .width,
                                                     multiplier: 1.0,
                                                     constant: 0.0)
                
                let height = NSLayoutConstraint(item: newView,
                                               attribute: .height,
                                               relatedBy: .equal,
                                               toItem: self.squareView,
                                               attribute: .height,
                                               multiplier: 1.0,
                                               constant: 0.0)

                
                let yConstraint = NSLayoutConstraint(item: newView,
                                                     attribute: .bottom,
                                                     relatedBy: .equal,
                                                     toItem: self.squareView,
                                                     attribute: .top,
                                                     multiplier: 1.0,
                                                     constant: 0.0)
                
                let xConstraint = NSLayoutConstraint(item: newView,
                                                     attribute: .leadingMargin,
                                                     relatedBy: .equal,
                                                     toItem: self.squareView,
                                                     attribute: .leadingMargin,
                                                     multiplier: 1.0,
                                                     constant: 0.0)
             
                self.view.addConstraint(width)
                self.view.addConstraint(height)
                self.view.addConstraint(xConstraint)
                self.view.addConstraint(yConstraint)


                // TODO: update initial room position
                //self.loadRoomsRecursively(roomIdentifier: roomIdentifier, relativeDirection: .north, relatedTileImage: self.imageView )
                
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
                 if !self.roomIds.contains(roomIdentifier) {

                    print(roomIdentifier)
                    
                    switch relativeDirection {
                    case .north :
                        self.x = relatedTileImage.frame.origin.x
                        self.y = relatedTileImage.frame.origin.y + relatedTileImage.frame.height
                        if self.y <= self.view.frame.origin.y {
                            self.shiftTiles(direction: .north)
                        }
                    case .south:
                        self.x = relatedTileImage.frame.origin.x
                        self.y = relatedTileImage.frame.origin.y - relatedTileImage.frame.height
                        if self.y > self.view.frame.origin.y + self.view.frame.height {
                          self.shiftTiles(direction: .south)
                        }
                    case .east:
                        self.x = relatedTileImage.frame.origin.x + relatedTileImage.frame.width
                        self.y = relatedTileImage.frame.origin.y
                        if self.x > self.view.frame.origin.x + self.view.frame.width {
                           self.shiftTiles(direction: .east)
                        }
                    case .west:
                        self.x = relatedTileImage.frame.origin.x - relatedTileImage.frame.width
                        self.y = relatedTileImage.frame.origin.y
                        if self.x <= self.view.frame.origin.x {
                            self.shiftTiles(direction: .west)
                        }
                    }
                   
                    
                    
                    let tileImage = UIImageView.init(frame: CGRect(x: self.x, y: self.y, width: self.tileSize, height: self.tileSize))
                    tileImage.translatesAutoresizingMaskIntoConstraints = true
                    tileImage.downloadedFrom(url: room.tileURL)
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
                } else {
                    // TODO: handle error.

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
                    subview.frame.origin.y += subview.frame.height
                case .south:
                    self.view.setNeedsLayout()
                 //   subview.frame.origin.y -= self.tileSize
                case .east:break
                    self.shrinkTiles()
                   // subview.frame.origin.x -= self.tileSize
                case .west:
                    subview.frame.origin.x += subview.frame.width
               // case .south: for subview in self.view.subviews {subview.frame.origin.y -= self.tileSize}
                //case .east: for subview in self.view.subviews {subview.frame.origin.x -= self.tileSize}
                //case .west: for subview in self.view.subviews {subview.frame.origin.x += self.tileSize}
                }
            }
        }
        
    }
    
    func shrinkTiles() {
        DispatchQueue.main.async() { () -> Void in

        for subview in self.view.subviews {
            subview.frame.size.width = subview.frame.size.width * 0.7
            subview.frame.size.height = subview.frame.size.width * 0.7
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

