//
//  MCTMorseSoundGenerator.m
//  MorseCodeTraining
//
//  参考:
//  https://github.com/JonathanAnderson/Aviation-Morse-Code-Tutor
//
//  Created by Suzuki Kouhei on 2014/01/18.
//  Copyright (c) 2014年 Suzuki Kouhei. All rights reserved.
//

#import "MCTMorseSoundGenerator.h"

#define SAMPLE_RATE 44100
#define FREQ 1020
#define DIT 100
#define DAH 300
#define SPACE 100
#define END_LENGTH 600

@implementation MCTMorseSoundGenerator

#pragma mark - public

+ (NSData *)generateMorseSoundData:(NSString *)morseString
{
    int length = 0;
    NSRange range;
    range.length = 1;
    range.location = 0;
    for (int i = 0; i < [morseString length]; ++i) {
        range.location = i;
        NSString *nextChar = [morseString substringWithRange:range];
        if ([nextChar isEqualToString:@"."]) {
            if (i) length += SPACE;
            length += DIT;
        } else if ([nextChar isEqualToString:@"-"]) {
            if (i) length += SPACE;
            length += DAH;
        } else if ([nextChar isEqualToString:@" "]) {
            if (i) length += SPACE;
            length += SPACE;
        }
    }
    length += END_LENGTH;

    int frames = SAMPLE_RATE * length / 1000.;
    int offset = 0;
    float *ptr = malloc(frames * sizeof(float));
    if (ptr == NULL) {
        NSLog(@"Error: Memory buffer could not be allocated.");
        return nil;
    }

    for (int i = 0; i < [morseString length]; ++i) {
        range.location = i;
        NSString *nextChar = [morseString substringWithRange:range];
        if ([nextChar isEqualToString:@"."]) {
            if (i) offset += SAMPLE_RATE * SPACE / 1000;
            int f_length = SAMPLE_RATE * DIT / 1000;
            for (int j = 0; j < f_length; ++j) {
                ptr[offset + j] = sinf((float) j * 2 * M_PI * FREQ / SAMPLE_RATE);
            }
            offset += f_length;
        } else if ([nextChar isEqualToString:@"-"]) {
            if (i) offset += SAMPLE_RATE * SPACE / 1000;
            int f_length = SAMPLE_RATE * DAH / 1000;
            for (int j = 0; j < f_length; ++j) {
                ptr[offset + j] = sinf((float) j * 2 * M_PI * FREQ / SAMPLE_RATE);
            }
            offset += f_length;
        } else if ([nextChar isEqualToString:@" "]) {
            if (i) offset += SAMPLE_RATE * SPACE / 1000;
            offset += SAMPLE_RATE * SPACE / 1000;
        }
    }
    offset += SAMPLE_RATE * END_LENGTH / 1000;
    NSLog(@"frames(%i) offset(%i)",frames,offset);

    return [MCTMorseSoundGenerator wavDataFromBuffer:ptr size:frames];
}

#pragma mark - private

+ (NSData *)wavDataFromBuffer:(float *)buffer size:(int)frames {
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
