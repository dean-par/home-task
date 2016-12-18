//
//  MazeConnection+Internal.h
//  MazeServer
//
//  Created by Andrew Bennett on 26/9/16.
//  Copyright © 2016 TeamBnut. All rights reserved.
//

#import "MazeConnection.h"

@interface MazeConnection(Internal)

-(instancetype _Nonnull) initWithRoomIdentifier: (NSString * _Nullable)roomIdentifier
                                           lock: (NSString * _Nullable)lock;

@end
