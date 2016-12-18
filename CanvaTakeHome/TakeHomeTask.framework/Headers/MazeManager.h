//
//  MazeManager.h
//  MazeServer
//
//  Created by Andrew Bennett on 26/9/16.
//  Copyright © 2016 TeamBnut. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MazeRoom;

/**
 A callback providing either a MazeRoom, or an error.

 @param room  A MazeRoom.
 @param error An error, if the call was unsucessful.
 */
typedef void(^MazeRoomResponse)(MazeRoom * _Nullable room, NSError * _Nullable error);

/**
 A callback providing either a MazeRoom, or an error.
 
 @param identifier  A MazeRoom identifier.
 @param error An error, if the call was unsucessful.
 */
typedef void (^MazeRoomIdentifierResponse)(NSString * _Nullable identifier, NSError * _Nullable error);

/**
 A Maze manager, able to create a new maze, and explore existing mazes.
 */
@interface MazeManager: NSObject

/**
 Instantiate a new MazeManager.

 @return a new maze manager.
 */
-(_Nonnull instancetype)init;

/**
 Generates a new maze providing a room identifier or error from the server.
 
 @param callback   Either a room, or an error.
 */
-(void) fetchStartRoomWithCallback: (MazeRoomIdentifierResponse _Nonnull)callback
    NS_SWIFT_NAME(_fetchStartRoom(callback:));

/**
 Fetches a room description from the server.

 @param identifier A string identifying the room to be fetched, passing null will find a room in a new maze.
 @param callback   Either a room, or an error.
 */
-(void) fetchRoomWithIdentifier: (NSString * _Nonnull)identifier
                       callback: (MazeRoomResponse _Nonnull)callback
    NS_SWIFT_NAME(_fetchRoom(identifier:callback:));

/**
 Unlock a room with the given lock, this is computationally expensive.

 @param lock An opaque string representing the lock
 */
-(NSString * _Nonnull) unlockRoomWithLock: (NSString * _Nonnull)lock
    NS_SWIFT_NAME(_unlockRoom(lock:));

@end
