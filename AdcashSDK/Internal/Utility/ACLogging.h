//
//  ACLogging.h
//  Adcash
//
//  Created by Andrew He on 2/10/11.
//  Copyright (c) 2014, Adcash OU and MoPub Inc.
//

#import <Foundation/Foundation.h>
#import "ACConstants.h"

// Lower = finer-grained logs.
typedef enum
{
    ACLogLevelAll        = 0,
    ACLogLevelTrace        = 10,
    ACLogLevelDebug        = 20,
    ACLogLevelInfo        = 30,
    ACLogLevelWarn        = 40,
    ACLogLevelError        = 50,
    ACLogLevelFatal        = 60,
    ACLogLevelOff        = 70
} ACLogLevel;

ACLogLevel ACLogGetLevel(void);
void ACLogSetLevel(ACLogLevel level);
void _ACLogTrace(NSString *format, ...);
void _ACLogDebug(NSString *format, ...);
void _ACLogInfo(NSString *format, ...);
void _ACLogWarn(NSString *format, ...);
void _ACLogError(NSString *format, ...);
void _ACLogFatal(NSString *format, ...);

#if AC_DEBUG_MODE && !SPECS

#define ACLogTrace(...) _ACLogTrace(__VA_ARGS__)
#define ACLogDebug(...) _ACLogDebug(__VA_ARGS__)
#define ACLogInfo(...) _ACLogInfo(__VA_ARGS__)
#define ACLogWarn(...) _ACLogWarn(__VA_ARGS__)
#define ACLogError(...) _ACLogError(__VA_ARGS__)
#define ACLogFatal(...) _ACLogFatal(__VA_ARGS__)

#else

#define ACLogTrace(...) {}
#define ACLogDebug(...) {}
#define ACLogInfo(...) {}
#define ACLogWarn(...) {}
#define ACLogError(...) {}
#define ACLogFatal(...) {}

#endif
