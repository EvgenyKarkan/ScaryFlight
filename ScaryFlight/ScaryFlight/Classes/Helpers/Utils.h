//
//  Utils.h
//  ScaryFlight
//
//  Created by Evgeny Karkan on 16.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#ifndef ScaryFlight_Utils_h
#define ScaryFlight_Utils_h

CGFloat randomFloatWithMin(CGFloat min, CGFloat max)
{
    return floor(((rand() % RAND_MAX) / (RAND_MAX * 1.0)) * (max - min) + min);
}

#endif
