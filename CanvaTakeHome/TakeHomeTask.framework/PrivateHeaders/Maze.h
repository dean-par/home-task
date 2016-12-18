//
//  Maze.h
//  MazeServer
//
//  Created by Andrew Bennett on 26/9/16.
//  Copyright © 2016 TeamBnut. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MazeTile.h"
#import "MazeConnection.h"
#import "MazeRoom.h"

@interface Maze : NSObject

+(uint32_t)identifierFromRoomIdentifier:(NSString* _Nonnull)roomIdentifier;
+(NSString*_Nonnull)roomIdentifierForLock:(NSString* _Nonnull)lock;

-(instancetype _Nonnull) initWithIdentifier:(uint32_t)identifier;

@property (nonatomic) NSUInteger width;
@property (nonatomic) NSUInteger height;

-(MazeRoom*_Nullable)roomWithIdentifier:(NSString*_Nonnull)identifier;

-(MazeRoom*_Nonnull)randomRoom;

-(void)generate;
-(void)debugRender;

@end
