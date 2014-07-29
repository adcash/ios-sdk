//
//  ACLogging.m
//  Adcash
//
//  Created by Andrew He on 2/10/11.
//  Copyright (c) 2014, Adcash OU and MoPub Inc.
//

#import "ACLogging.h"
#import "ACIdentityProvider.h"

static ACLogLevel ACLOG_LEVEL = ACLogLevelTrace;

ACLogLevel ACLogGetLevel()
{
    return ACLOG_LEVEL;
}

void ACLogSetLevel(ACLogLevel level)
{
    ACLOG_LEVEL = level;
}

void _ACLog(NSString *format, va_list args)
{
    static NSString *sIdentifier;
    static NSString *sObfuscatedIdentifier;

    if (!sIdentifier) {
        sIdentifier = [[ACIdentityProvider identifier] copy];
    }

    if (!sObfuscatedIdentifier) {
        sObfuscatedIdentifier = [[ACIdentityProvider obfuscatedIdentifier] copy];
    }

    NSString *logString = [[[NSString alloc] initWithFormat:format arguments:args] autorelease];

    // Replace identifier with a obfuscated version when logging.
    logString = [logString stringByReplacingOccurrencesOfString:sIdentifier withString:sObfuscatedIdentifier];

    NSLog(@"%@", logString);
}

void _ACLogTrace(NSString *format, ...)
{
    if (ACLOG_LEVEL <= ACLogLevelTrace)
    {
        format = [NSString stringWithFormat:@"ADCASH: %@", format];
        va_list args;
        va_start(args, format);
        _ACLog(format, args);
        va_end(args);
    }
}

void _ACLogDebug(NSString *format, ...)
{
    if (ACLOG_LEVEL <= ACLogLevelDebug)
    {
        format = [NSString stringWithFormat:@"ADCASH: %@", format];
        va_list args;
        va_start(args, format);
        _ACLog(format, args);
        va_end(args);
    }
}

void _ACLogWarn(NSString *format, ...)
{
    if (ACLOG_LEVEL <= ACLogLevelWarn)
    {
        format = [NSString stringWithFormat:@"ADCASH: %@", format];
        va_list args;
        va_start(args, format);
        _ACLog(format, args);
        va_end(args);
    }
}

void _ACLogInfo(NSString *format, ...)
{
    if (ACLOG_LEVEL <= ACLogLevelInfo)
    {
        format = [NSString stringWithFormat:@"ADCASH: %@", format];
        va_list args;
        va_start(args, format);
        _ACLog(format, args);
        va_end(args);
    }
}

void _ACLogError(NSString *format, ...)
{
    if (ACLOG_LEVEL <= ACLogLevelError)
    {
        format = [NSString stringWithFormat:@"ADCASH: %@", format];
        va_list args;
        va_start(args, format);
        _ACLog(format, args);
        va_end(args);
    }
}

void _ACLogFatal(NSString *format, ...)
{
    if (ACLOG_LEVEL <= ACLogLevelFatal)
    {
        format = [NSString stringWithFormat:@"ADCASH: %@", format];
        va_list args;
        va_start(args, format);
        _ACLog(format, args);
        va_end(args);
    }
}
