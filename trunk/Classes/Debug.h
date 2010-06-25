//
//  Debug.h
//
//  Created by Tyler Neylon on 6/12/10.
//
//  Items useful for debugging.
//


extern unsigned long lastTick;
extern unsigned long tick;

#define PrintName NSLog(@"%s", __FUNCTION__)

#define Tick \
  tick = clock(); \
  NSLog(@"Tick: %s:%d, %fs since last tick", __FILE__, __LINE__, (double)(tick - lastTick) / CLOCKS_PER_SEC); \
  lastTick = tick;
