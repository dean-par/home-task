//
//  MazeTile.h
//  MazeServer
//
//  Created by Andrew Bennett on 26/9/16.
//  Copyright © 2016 TeamBnut. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,MazeTile) {
    MazeTileEmpty,
    MazeTileWall,
    MazeTileDoor,
    MazeTileExit
};

NSString * _Nonnull MazeTileToString(MazeTile tile);
NSString * _Nonnull MazeTileToType(MazeTile tile);
