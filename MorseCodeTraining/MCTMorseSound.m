//
//  MCTMorseSound.m
//  MorseCodeTraining
//
//  参考:
//  https://github.com/JonathanAnderson/Aviation-Morse-Code-Tutor
//
//  Created by Suzuki Kouhei on 2014/01/18.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTMorseSound.h"

#import "NSString+MorseCode.h"

static const NSInteger kSapmleRate = 44100;
static const NSInteger kDefalutFrequency = 1020;
static const NSInteger kDefalutWpm = 20;

@interface MCTMorseSound ()

@property (nonatomic, readwrite) NSString *string;
@property (nonatomic, readwrite) NSString *morseCodeString;
@property (nonatomic, readwrite) NSData *soundData;

@property (nonatomic) NSArray *riseTable;

@property (nonatomic) NSInteger morseSoundFrequency; // [Hz]
@property (nonatomic) NSInteger morseSoundDitLength; // [ms]
@property (nonatomic) NSInteger morseSoundDahLength; // [ms]
@property (nonatomic) NSInteger morseSoundSpaceLength; // [ms]
@property (nonatomic) NSInteger morseSoundEndLength; // [ms]

@end

@implementation MCTMorseSound

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initSharedInstance
{
    if (self = [super init]) {
        _string = nil;
        _morseCodeString = nil;
        _soundData = nil;

        _morseSoundFrequency = kDefalutFrequency;
        self.wpm = kDefalutWpm;
    }
    return self;
}

+ (MCTMorseSound *)sharedSound
{
    static MCTMorseSound *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MCTMorseSound alloc] initSharedInstance];
    });
    return sharedInstance;
}

#pragma mark - Setter

- (void)setWpm:(NSInteger)wpm
{
    NSLog(@"wpm : %ld", (long)wpm);
    // WPM は 1分間に PARIS がいくつ入るかを表す指標
    // 1WPM = .--.   .-   .-.   ..   ...
    //      = 11   3 5  3 7   3 3  3 5   7
    //      = 43短点分
    // 60s = 60000ms で43短点なので、
    // 1短点 = ceil(60000 / 50) ms
    self.morseSoundDitLength   = ceil(60000.f     / 50 / wpm);
    self.morseSoundDahLength   = ceil(60000.f * 3 / 50 / wpm);
    self.morseSoundSpaceLength = ceil(60000.f     / 50 / wpm);
    self.morseSoundEndLength   = ceil(60000.f * 6 / 50 / wpm);
}

#pragma mark - public

- (NSData *)soundDataWithString:(NSString *)string
{
    NSString *morseCodeString = [string morseCodeStringWithString];

    unsigned int length = 0;
    NSRange range;
    range.length = 1;
    range.location = 0;
    for (int i = 0; i < [morseCodeString length]; ++i) {
        range.location = i;
        NSString *nextChar = [morseCodeString substringWithRange:range];
        if ([nextChar isEqualToString:@"."]) {
            if (i) length += self.morseSoundSpaceLength;
            length += self.morseSoundDitLength;
        } else if ([nextChar isEqualToString:@"-"]) {
            if (i) length += self.morseSoundSpaceLength;
            length += self.morseSoundDahLength;
        } else if ([nextChar isEqualToString:@" "]) {
            if (i) length += self.morseSoundSpaceLength;
            length += self.morseSoundSpaceLength;
        }
    }
    length += self.morseSoundEndLength;

    unsigned int frames = kSapmleRate * length / 1000.f;
    unsigned int offset = 0;
    double *ptr = malloc(frames * sizeof(double));
    if (ptr == NULL) {
        NSLog(@"Error: Memory buffer could not be allocated.");
        return nil;
    }

    for (int i = 0; i < [morseCodeString length]; ++i) {
        range.location = i;
        NSString *nextChar = [morseCodeString substringWithRange:range];
        if (i) offset += kSapmleRate * self.morseSoundSpaceLength / 1000;
        if ([nextChar isEqualToString:@"."]) {
            int f_length = kSapmleRate * self.morseSoundDitLength / 1000;
            for (int j = 0; j < f_length; ++j) {
                ptr[offset + j] = [self sinfValue:j totalLength:f_length];
            }
            offset += f_length;
        } else if ([nextChar isEqualToString:@"-"]) {
            int f_length = kSapmleRate * self.morseSoundDahLength / 1000;
            for (int j = 0; j < f_length; ++j) {
                ptr[offset + j] = [self sinfValue:j totalLength:f_length];
            }
            offset += f_length;
        } else if ([nextChar isEqualToString:@" "]) {
            offset += kSapmleRate * self.morseSoundSpaceLength / 1000;
        }
    }
    offset += kSapmleRate * self.morseSoundEndLength / 1000;
    NSLog(@"frames(%i) offset(%i)",frames,offset);

    self.string = string;
    self.morseCodeString = morseCodeString;
    self.soundData = [[self class] wavDataFromBuffer:ptr size:frames];
    return self.soundData;
}

#pragma mark - private

+ (double)blackmanHarrisWindow:(double)x
{
	double a0 = 0.35875;
	double a1 = 0.48829;
	double a2 = 0.14128;
	double a3 = 0.01168;
	double seg1 = a1 * cos(2.0 * M_PI * x);
	double seg2 = a2 * cos(4.0 * M_PI * x);
	double seg3 = a3 * cos(6.0 * M_PI * x);

	return a0 - seg1 + seg2 - seg3;
}

- (NSArray *)riseTable
{
    // @ref https://github.com/snakehand/softrockcw/blob/master/Source/CwGen.cpp

    if (_riseTable) return _riseTable;

	double riseTime = 0.005; // 5ms
	unsigned int riseTableSize = (unsigned int)((double)kSapmleRate * riseTime * 2.7);
	if (riseTableSize == 0) {
		riseTableSize = 1;
	}

    double *tmpRiseTable = malloc(riseTableSize * sizeof(double));
    if (tmpRiseTable == NULL) {
        NSLog(@"Error: Memory buffer could not be allocated.");
        return nil;
    }

	/* Create impulse response */
	double f = 1.0 / ((double)riseTableSize - 1.0);
	for (int i = 0; i < riseTableSize; i++) {
		tmpRiseTable[i] = [MCTMorseSound blackmanHarrisWindow:f * (double)i];
	}

	/* integrate to create step response */
	double sum = 0.0;
	for (int i = 0; i < riseTableSize; i++) {
		sum += tmpRiseTable[i];
		tmpRiseTable[i] = sum;
	}

	/* normalize step response */
    NSMutableArray *riseTable = [NSMutableArray array];
	for (int i = 0; i < riseTableSize; i++) {
		riseTable[i] = @(tmpRiseTable[i] / sum);
	}
    free(tmpRiseTable);

    _riseTable = [riseTable copy];
    return _riseTable;
}

- (double)sinfValue:(int)time totalLength:(int)total
{
    // envelope
    int pos = time;
    if (time >= self.riseTable.count) pos = self.riseTable.count - 1;
    if (time >= total - self.riseTable.count) pos = total - time - 1;
    double envelope = [self.riseTable[pos] floatValue];

    return sinf((double)time * 2 * M_PI * self.morseSoundFrequency / kSapmleRate) * envelope;
}

+ (NSData *)wavDataFromBuffer:(double *)buffer size:(int)frames {
    // AVAudioPlayer will only play formats it knows. It cannot play raw
    // audio data, so we will convert the raw floating point values into
    // a 16-bit WAV file.

    unsigned int payloadSize = frames * sizeof(SInt16);  // byte size of waveform data
    unsigned int wavSize = 44 + payloadSize;           // total byte size

    // Allocate a memory buffer that will hold the WAV header and the
    // waveform bytes.
    SInt8 *wavBuffer = (SInt8 *)malloc(wavSize);
    if (wavBuffer == NULL) {
        NSLog(@"Error allocating %u bytes", wavSize);
        return nil;
    }

    // Fake a WAV header.
    SInt8 *header = (SInt8 *)wavBuffer;
    header[0x00] = 'R';
    header[0x01] = 'I';
    header[0x02] = 'F';
    header[0x03] = 'F';
    header[0x08] = 'W';
    header[0x09] = 'A';
    header[0x0A] = 'V';
    header[0x0B] = 'E';
    header[0x0C] = 'f';
    header[0x0D] = 'm';
    header[0x0E] = 't';
    header[0x0F] = ' ';
    header[0x10] = 16;    // size of format chunk (always 16)
    header[0x11] = 0;
    header[0x12] = 0;
    header[0x13] = 0;
    header[0x14] = 1;     // 1 = PCM format
    header[0x15] = 0;
    header[0x16] = 1;     // number of channels
    header[0x17] = 0;
    header[0x18] = 0x44;  // samples per sec (44100)
    header[0x19] = 0xAC;
    header[0x1A] = 0;
    header[0x1B] = 0;
    header[0x1C] = 0x88;  // bytes per sec (88200)
    header[0x1D] = 0x58;
    header[0x1E] = 0x01;
    header[0x1F] = 0;
    header[0x20] = 2;     // block align (bytes per sample)
    header[0x21] = 0;
    header[0x22] = 16;    // bits per sample
    header[0x23] = 0;
    header[0x24] = 'd';
    header[0x25] = 'a';
    header[0x26] = 't';
    header[0x27] = 'a';

    *((SInt32 *)(wavBuffer + 0x04)) = payloadSize + 36;   // total chunk size
    *((SInt32 *)(wavBuffer + 0x28)) = payloadSize;        // size of waveform data

    // Convert the floating point audio data into signed 16-bit.
    SInt16 *payload = (SInt16 *)(wavBuffer + 44);
    for (int t = 0; t < frames; ++t) {
        payload[t] = buffer[t] * 0x7fff;
    }

    // Put everything in an NSData object.
    NSData *data = [[NSData alloc] initWithBytesNoCopy:wavBuffer length:wavSize freeWhenDone:YES];
    return data;
}

@end
