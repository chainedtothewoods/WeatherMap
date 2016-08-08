//
//  WMCoreDataStackManager.h
//  WeatherMap
//
//  Created by Mike Limestro on 8/7/16.
//  Copyright © 2016 Mike Lapuebla. All rights reserved.
//

@import CoreData;
@import Foundation;

@interface WMCoreDataStackManager : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedManager;

@end
