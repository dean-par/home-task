//
//  MazeConnection.h
//  MazeServer
//
//  Created by Andrew Bennett on 26/9/16.
//  Copyright © 2016 TeamBnut. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A Maze connection, either has a room identifier, or a lock (not both).
 */
@interface MazeConnection : NSObject


/**
 An opaque string uniquely representing a room
 */
@property (nonatomic, readonly, nullable) NSString * roomIdentifier;
/**
 An opaque string uniquely representing a lock
 */
@property (nonatomic, readonly, nullable) NSString * lock;

@end
