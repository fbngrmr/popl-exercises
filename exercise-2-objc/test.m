#import <Foundation/Foundation.h>
#import <objc/runtime.h>

static int idCounter = 0;

@interface Animal : NSObject {
    NSString* name;
    BOOL carnivore;

    @protected
        int ID;
}

@property (retain) NSString* name;
@property (nonatomic, assign) BOOL carnivore;

- (void) setName: (NSString*)input;
- (void) setCarnivore: (BOOL)input;
- (id) init;
- (NSString *) description;
+ (int) generateId;
@end

@implementation Animal
- (void) setName: (NSString*)input
{
    name = input;
}

- (void) setCarnivore: (BOOL)input
{
    carnivore = input;
}

- (NSString*) name {
    return name;
}

- (BOOL) carnivore {
    return carnivore;
}

- (id)initWithName:(NSString *)name andCarnivore:(BOOL)carnivore {
    if ( (self = [super init]) )
    {
        [self setCarnivore: carnivore];
        [self setName: name];
        ID = [Animal generateId];
    }
    return self;
}

- (NSString *) description {
    NSLog(@"%d", ID);
    return @"test";
}

+ (int) generateId {
    return idCounter++;
}
@end

@interface Mammal : Animal
@end

@implementation Mammal
@end

@interface Bird : Animal {
    double wingSpan;
}

@property (nonatomic, assign) double wingSpan;

- (void) setWingSpan: (double)input;
@end

@implementation Bird
- (void) setWingSpan: (double)input
{
    wingSpan = input;
}

- (double) wingSpan {
    return wingSpan;
}

- (id) init
{
    if ( (self = [super init]) )
    {
        [self setWingSpan: 5.0];
    }
    return self;
}
@end

@interface Reptile : Animal {
    double bodyTemperature;
}

@property (nonatomic, assign) double bodyTemperature;

- (void) setBodyTemperature: (double)input;
@end

@implementation Reptile
- (void) setBodyTemperature: (double)input
{
    bodyTemperature = input;
}

- (double) bodyTemperature {
    return bodyTemperature;
}

- (id) init
{
    if ( (self = [super init]) )
    {
        [self setBodyTemperature: 5.0];
    }
    return self;
}
@end

int main(int argc, const char * argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    /*unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([Photo class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        fprintf(stdout, "%s %s\n", property_getName(property), property_getAttributes(property));
    }*/

    Bird *bird = [[Bird alloc]initWithName:@"Raj" andCarnivore: NO];
    NSLog(@"%@", bird.name);
    NSLog(@"%f", [bird description]);

    Bird *bird1 = [[Bird alloc]initWithName:@"Raj1" andCarnivore: NO];
    NSLog(@"%@", bird1.name);
    NSLog(@"%f", [bird1 description]);

    [pool drain];
    return 0;
}