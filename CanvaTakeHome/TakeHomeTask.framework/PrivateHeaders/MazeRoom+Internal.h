//
//  MazeRoom+Internal.h
//  MazeServer
//
//  Created by Andrew Bennett on 26/9/16.
//  Copyright © 2016 TeamBnut. All rights reserved.
//

#import "MazeRoom.h"

@interface MazeRoom (Internal)

-(instancetype _Nonnull) initWithIdentifier: (NSString * _Nonnull) identifier
                                       type: (NSString * _Nonnull) type
                                      north: (MazeConnection * _Nullable) north
                                      south: (MazeConnection * _Nullable) south
                                       east: (MazeConnection * _Nullable) east
                                       west: (MazeConnection * _Nullable) west
                                    tileURL: (NSURL * _Nonnull)tileURL;

@end
