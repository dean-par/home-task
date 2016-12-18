//
//  MazeManager.swift
//  TakeHomeTask
//
//  Created by Andrew Bennett on 27/09/2016.
//  Copyright © 2016 Canva. All rights reserved.
//

import TakeHomeTask

/// A simple closure that either produces a room, or throws an error.
typealias RoomOrError = () throws -> Room

/// A simple closure that either produces a room, or throws an error.
typealias RoomIdOrError = () throws -> RoomId

/// A generic Maze manager, able to create a new maze, and explore existing mazes.
public protocol Manager: class {
    
    /// Generates a new maze, and returns a closure producing the starting room
    ///
    /// - parameter callback: an asynchronous callback to produce the room
    func fetchStartRoom(callback: @escaping (RoomIdOrError)->Void)
    
    
    /// Fetches a room with the given identifier
    ///
    /// - parameter roomId:   an identifier for the room to be fetched
    /// - parameter callback: an asynchronus callback for the room, when it is ready
    func fetchRoom(roomId: RoomId, callback: @escaping (RoomOrError)->Void)
    
    
    /// Unlocks a room, given a locked room identifier it returns a room identifier.
    /// Typically this will be expensive, and calculated on device.
    ///
    /// - parameter lockId: an identifier for a locked room
    ///
    /// - returns: the room identifier
    func unlockRoom(lockId: LockId) -> RoomId
}


/// A connection from one room to another
///
/// - Room:            An unlocked room identifier (See Manager.fetchRoom(roomId:,callback:))
/// - LockedRoom:      A locked room identifier (See Manager.unlockRoom(lockId:))
public enum Connection: CustomStringConvertible {
    case Room(RoomId)
    case LockedRoom(LockId)

    fileprivate init?(connection: MazeConnection) {
        if let room = connection.roomIdentifier {
            self = .Room(RoomId(raw: room))
        }
        else if let lock = connection.lock {
            self = .LockedRoom(LockId(raw: lock))
        }
        else {
            return nil
        }
    }

    public var description: String {
        switch self {
        case let .Room(roomId):
            return "Connection(to: \(roomId.raw))"
        case let .LockedRoom(lock):
            return "Connection(lock: \(lock.raw))"
        }
    }
}


/// A compass direction
/// - north: North, in screen coordinates this is up
/// - south: South, in screen coordinates this is down
/// - east:  East,  in screen coordinates this is right
/// - west:  West,  in screen coordinates this is left
public enum Direction: CustomStringConvertible {
    case north, south, east, west
    
    public var description: String {
        switch self {
        case .north: return "n"
        case .south: return "s"
        case .east:  return "e"
        case .west:  return "w"
        }
    }
}

/// A Maze room. It describes a room, and those adjacent to it.
public struct Room: CustomStringConvertible {
    /// Uniquely identifies this room
    public let identifier: RoomId
    
    /// Connections representing the adjacent rooms in each direction (if they exist).
    public let connections: [Direction: Connection]
    
    /// A url to an image that can be used to represent the room in UI
    public let tileURL: URL

    /// A type representing this room, for debug purposes.
    public let type: RoomType
    
    internal init(
        identifier: RoomId,
        type: RoomType,
        connections: [Direction: Connection],
        tileURL: URL)
    {
        self.identifier = identifier
        self.type = type
        self.connections = connections
        self.tileURL = tileURL
    }
    
    fileprivate init(_ room: MazeRoom) {
        var connections: [Direction: Connection] = [:]
        if let n = room.north.flatMap(Connection.init) { connections[.north] = n }
        if let e = room.east .flatMap(Connection.init) { connections[.east]  = e }
        if let s = room.south.flatMap(Connection.init) { connections[.south] = s }
        if let w = room.west .flatMap(Connection.init) { connections[.west]  = w }
        self.init(
            identifier: RoomId(raw: room.identifier),
            type: RoomType(rawValue: room.type)!,
            connections: connections,
            tileURL: room.tileURL)
    }
    
    public var description: String {
        let connections = self.connections.map { direction, connection in "\(direction): \(connection)" }
        return "Room(id: \(self.identifier.raw), connections: [\(connections.joined(separator: ", "))]))"
    }
}


/// An opaque type representing a room
public struct RoomId: Hashable {
    internal let raw: String
    public var hashValue: Int { return raw.hashValue }
    internal init(raw: String) { self.raw = raw }
    public static func ==(lhs: RoomId, rhs: RoomId) -> Bool { return lhs.raw == rhs.raw }
}

/// An opaque type representing a locked room
public struct LockId: Hashable {
    internal let raw: String
    public var hashValue: Int { return raw.hashValue }
    internal init(raw: String) { self.raw = raw }
    public static func ==(lhs: LockId, rhs: LockId) -> Bool { return lhs.raw == rhs.raw }
}

/// The type of a room, for debug purposes
public enum RoomType: RawRepresentable {
    case room, lockedRoom, exit

    public init?(rawValue: String) {
        switch rawValue {
        case RoomType.room.rawValue: self = .room
        case RoomType.lockedRoom.rawValue:  self = .lockedRoom
        case RoomType.exit.rawValue:  self = .exit
        default: return nil
        }
    }

    public var rawValue: String {
        switch self {
        case .room: return "EMPTY"
        case .lockedRoom: return "DOOR"
        case .exit: return "EXIT"
        }
    }
}

// MARK: - MazeManager Swift Manager conformance
extension MazeManager: Manager {
    
    static let sharedInstance = MazeManager()
    
    public func fetchStartRoom(callback: @escaping (RoomIdOrError) -> Void) {
        self._fetchStartRoom { roomId, error in
            callback {
                if let roomId = roomId {
                    return RoomId(raw: roomId)
                }
                guard let error = error else {
                    fatalError("Expecting either a room identifier, or an error!")
                }
                throw error
            }
        }
    }
    public func fetchRoom(roomId: RoomId, callback: @escaping (RoomOrError) -> Void) {
        self.fetchRoom(rawIdentifier: roomId.raw, callback: callback)
    }
    
    public func unlockRoom(lockId: LockId) -> RoomId {
        let room = self._unlockRoom(lock: lockId.raw)
        return RoomId(raw: room)
    }
    
    private func fetchRoom(rawIdentifier: String, callback: @escaping (RoomOrError) -> Void) {
        self._fetchRoom(identifier: rawIdentifier) { room, error in
            callback {
                if let room = room {
                    return Room(room)
                }
                guard let error = error else {
                    fatalError("Expecting either a room identifier, or an error!")
                }
                throw error
            }
        }
    }
}
