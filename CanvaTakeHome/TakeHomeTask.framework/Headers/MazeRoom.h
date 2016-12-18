//
//  MazeRoom.h
//  MazeServer
//
//  Created by Andrew Bennett on 26/9/16.
//  Copyright © 2016 TeamBnut. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MazeConnection;

/**
 A Maze room. It describes a room, and those adjacent to it.
 */
@interface MazeRoom : NSObject

/**
 An opaque string uniquely representing the room
 */
@property (nonatomic, readonly, nonnull) NSString * identifier;

/**
 A connection representing the room to the north (if it exists).
 */
@property (nonatomic, readonly, nullable) MazeConnection * north;
/**
 A connection representing the room to the south (if it exists).
 */
@property (nonatomic, readonly, nullable) MazeConnection * south;
/**
 A connection representing the room to the east (if it exists).
 */
@property (nonatomic, readonly, nullable) MazeConnection * east;
/**
 A connection representing the room to the west (if it exists).
 */
@property (nonatomic, readonly, nullable) MazeConnection * west;

/**
 A url to an image that can be used to represent the room in UI
 */
@property (nonatomic, readonly, nonnull) NSURL * tileURL;

/**
 A string representing the type of the room, for debug purposes.
 */
@property (nonatomic, readonly, nonnull) NSString * type;

@end
