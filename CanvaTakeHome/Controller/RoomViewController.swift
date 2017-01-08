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
    let initialTile = UIImageView()
    var roomIds: [RoomId] = []
    var x: CGFloat = 0.0
    var y: CGFloat = 400.0
    var tileSize: CGFloat = 10.0
    
    var leftTopTile = UIView()
    var leftBottomTile = UIImageView()
    var righttopTile = UIImageView()
    var rightBottomTile = UIImageView()

    var topLeftTilePoint = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialTile.backgroundColor = UIColor.red
        initialTile.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(initialTile)
        
        let width = NSLayoutConstraint(item: initialTile,
                                       attribute: .width,
                                       relatedBy: .equal,
                                       toItem: nil,
                                       attribute: .notAnAttribute,
                                       multiplier: 1.0,
                                       constant: 7.0)
        
        
        let aspectRatio = NSLayoutConstraint(item: initialTile,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: initialTile,
                                             attribute: .width,
                                             multiplier: 1.0,
                                             constant: 0.0)
        
        
        let yConstraint = NSLayoutConstraint(item: initialTile,
                                             attribute: .centerY,
                                             relatedBy: .equal,
                                             toItem: self.view,
                                             attribute: .centerY,
                                             multiplier: 1.0,
                                             constant: 0.0)
        
        
        let xConstraint = NSLayoutConstraint(item: initialTile,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: self.view,
                                             attribute: .centerX,
                                             multiplier: 1.0,
                                             constant: 0.0)
        
    
        self.view.addConstraint(width)
        self.view.addConstraint(aspectRatio)
        self.view.addConstraint(xConstraint)
        self.view.addConstraint(yConstraint)

        loadStartingRoom()
        
    }
    
        func loadStartingRoom() {
        MazeManager.sharedInstance.fetchStartRoom { (roomOrError) in
            do {
                let roomIdentifier = try roomOrError()
                self.loadRoomsRecursively(roomIdentifier: roomIdentifier, relativeDirection: .north, relatedTileImage: self.initialTile )
            } catch {
                print(error)
            }
        }
    }
    
    func loadRoomsRecursively(roomIdentifier: RoomId,
                              relativeDirection: Direction,
                              relatedTileImage: UIImageView?) {
        MazeManager.sharedInstance.fetchRoom(roomId: roomIdentifier, callback: { (room) in
            do {
                let room = try room()
                 if !self.roomIds.contains(roomIdentifier) {

                    // Debug printer.
                    print(roomIdentifier)
                    
                    // Create new imageview.
                    

                    let tileImage = UIImageView()
                    tileImage.translatesAutoresizingMaskIntoConstraints = false
                    tileImage.downloadedFrom(url: room.tileURL)
                    self.view.addSubview(tileImage)
                    
                    let width = NSLayoutConstraint(item: tileImage,
                                                   attribute: .width,
                                                   relatedBy: .equal,
                                                   toItem: self.initialTile,
                                                   attribute: .width,
                                                   multiplier: 1.0,
                                                   constant: 0.0)
                    
                    let aspectRatio = NSLayoutConstraint(item: tileImage,
                                                         attribute: .height,
                                                         relatedBy: .equal,
                                                         toItem: self.initialTile,
                                                         attribute: .width,
                                                         multiplier: 1.0,
                                                         constant: 0.0)
                    self.view.addConstraint(width)
                    self.view.addConstraint(aspectRatio)
                    
                    if let relatedTileImage = relatedTileImage {
                        switch relativeDirection {
                        case .north :
                            let alignmentConstraint = NSLayoutConstraint(item: tileImage,
                                                                 attribute: .top,
                                                                 relatedBy: .equal,
                                                                 toItem: relatedTileImage,
                                                                 attribute: .bottom,
                                                                 multiplier: 1.0,
                                                                 constant: 0.0)
                            
                            let marginConstraint = NSLayoutConstraint(item: tileImage,
                                                                         attribute: .leading,
                                                                         relatedBy: .equal,
                                                                         toItem: relatedTileImage,
                                                                         attribute: .leading,
                                                                         multiplier: 1.0,
                                                                         constant: 0.0)
                            
                            self.view.addConstraint(alignmentConstraint)
                            self.view.addConstraint(marginConstraint)
                            
                            self.view.setNeedsLayout()
                            
                              //  for constraint in self.view.constraints {
//                                    if constraint.identifier == "topBoundaryConstraint" {
//                                        self.shiftTilesDown(tileImage: tileImage)
//
//                                    //    self.view.removeConstraint(constraint)
//                                        
//                                    }
//                                }
                            
                            
                            // if tiles reach outside view
                        
                            
                        case .south:
                            let alignmentConstraint = NSLayoutConstraint(item: tileImage,
                                                                         attribute: .bottom,
                                                                         relatedBy: .equal,
                                                                         toItem: relatedTileImage,
                                                                         attribute: .top,
                                                                         multiplier: 1.0,
                                                                         constant: 0.0)
                            
                            let marginConstraint = NSLayoutConstraint(item: tileImage,
                                                                      attribute: .leading,
                                                                      relatedBy: .equal,
                                                                      toItem: relatedTileImage,
                                                                      attribute: .leading,
                                                                      multiplier: 1.0,
                                                                      constant: 0.0)
                            
                            self.view.addConstraint(alignmentConstraint)
                            self.view.addConstraint(marginConstraint)
                            
                            self.view.setNeedsLayout()

                    
                        case .east:
                            
                            
                        let alignmentConstraint = NSLayoutConstraint(item: tileImage,
                                                                     attribute: .leading,
                                                                     relatedBy: .equal,
                                                                     toItem: relatedTileImage,
                                                                     attribute: .trailing,
                                                                     multiplier: 1.0,
                                                                     constant: 0.0)
                        
                        let marginConstraint = NSLayoutConstraint(item: tileImage,
                                                                  attribute: .top,
                                                                  relatedBy: .equal,
                                                                  toItem: relatedTileImage,
                                                                  attribute: .top,
                                                                  multiplier: 1.0,
                                                                  constant: 0.0)
                        self.view.addConstraint(alignmentConstraint)
                        self.view.addConstraint(marginConstraint)
                            
                        self.view.setNeedsLayout()
                            
                        if tileImage.frame.origin.y <= self.view.frame.origin.y {
                            
                            for constraint in self.view.constraints {
                                if constraint.identifier == "topBoundaryConstraint" {
                                    constraint.isActive = false
                                }
                                
                            }
                            
                        }
                            
                            
                    

   
                        case .west:

                        
                        let alignmentConstraint = NSLayoutConstraint(item: tileImage,
                                                                     attribute: .trailing,
                                                                     relatedBy: .equal,
                                                                     toItem: relatedTileImage,
                                                                     attribute: .leading,
                                                                     multiplier: 1.0,
                                                                     constant: 0.0)
                        
                        let marginConstraint = NSLayoutConstraint(item: tileImage,
                                                                  attribute: .top,
                                                                  relatedBy: .equal,
                                                                  toItem: relatedTileImage,
                                                                  attribute: .top,
                                                                  multiplier: 1.0,
                                                                  constant: 0.0)
                        self.view.addConstraint(alignmentConstraint)
                        self.view.addConstraint(marginConstraint)
                        
                        self.view.setNeedsLayout()

                        if tileImage.frame.origin.x <= self.view.frame.origin.x {

                            for constraint in self.view.constraints {
                                if constraint.identifier == "leftBoundaryConstraint" {
                                    constraint.isActive = false
                                }
                                
                            }
                            
                            // if tiles reach outside view
                          //  self.shiftTiles(tileImage: tileImage)
                            }
                        
                    
                        }
                    }


                    
//                    if tileImage.frame.origin.y <= 0.0 {
//                        let boundaryConstraint = NSLayoutConstraint(item: tileImage,
//                                                                    attribute: .top,
//                                                                    relatedBy: .equal,
//                                                                    toItem: self.view,
//                                                                    attribute: .top,
//                                                                    multiplier: 1.0,
//                                                                    constant: 0.0)
//                        boundaryConstraint.identifier = "topBoundaryConstraint"
//                        self.view.addConstraint(boundaryConstraint)}
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
                } else {
                    // TODO: handle error.

                }
            } catch {
                print(error)
            }
        })
        self.view.setNeedsLayout()
    }
    
    func shiftTiles(tileImage: UIImageView) {
        let boundaryConstraint = NSLayoutConstraint(item: tileImage,
                                                  attribute: .leading,
                                                  relatedBy: .equal,
                                                  toItem: self.view,
                                                  attribute: .leading,
                                                  multiplier: 1.0,
                                                  constant: 0.0)
        boundaryConstraint.identifier = "leftBoundaryConstraint"
        self.view.addConstraint(boundaryConstraint)
        self.view.setNeedsLayout()


    }
    
    func shiftTilesDown(tileImage: UIImageView) {
        let boundaryConstraint = NSLayoutConstraint(item: tileImage,
                                                    attribute: .top,
                                                    relatedBy: .equal,
                                                    toItem: self.view,
                                                    attribute: .top,
                                                    multiplier: 1.0,
                                                    constant: 0.0)
        boundaryConstraint.identifier = "topBoundaryConstraint"
        self.view.addConstraint(boundaryConstraint)
        
    }
    
    func unlockedRoom(lockedRoomId: LockId) -> RoomId {
        return MazeManager.sharedInstance.unlockRoom(lockId: lockedRoomId)
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

