#import <Foundation/Foundation.h>
#import <objc/runtime.h>
 
@interface Animal : NSObject
{
    @property (nonatomic, retain) NSString *animalName;
    @property (nonatomic, retain) NSInteger animalId;
    @property (nonatomic, retain) BOOL animalCarnivore;
}

- (id)initWithName:(NSString *)name andCarnivore:(BOOL)carnivore;
- (NSString *)description;
@end

@implementation Animal

- (id)initWithName:(NSString *)name andCarnivore:(BOOL)carnivore {
    animalName = name;
    animalCarnivore = carnivore;
    animalId = 5;

    return self;
}

- (NSString *)description {
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);

    NSMutableArray *rv = [NSMutableArray array];

    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        NSLog(@"name: %@", name);
        [rv addObject:name];
    }

    free(properties);

    return [NSString stringWithFormat: @"carnivore:%d name=%@", animalCarnivore, animalName];
}

@end

@interface Mammal : Animal
{

}
@end

@implementation Mammal

- (id)initWithName:(NSString *)name andCarnivore:(BOOL)carnivore {
    [[Animal alloc]initWithName:name andCarnivore:carnivore];

    return self;
}

- (void)print{
    NSLog(@"name: %@", animalName);
    NSLog(@"carnivore: %ld", animalCarnivore);
}

@end



int main(int argc, const char * argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];        
    NSLog(@"Base class Animal Object");
    Animal *animal = [[Animal alloc]initWithName:@"Raj" andCarnivore: NO];
    NSLog([animal description]);
    [pool drain];
    return 0;
}

/*@interface Employee : Person

{
    NSString *employeeEducation;
}

- (id)initWithName:(NSString *)name andAge:(NSInteger)age 
  andEducation:(NSString *)education;
- (void)print;

@end


@implementation Employee

- (id)initWithName:(NSString *)name andAge:(NSInteger)age 
  andEducation: (NSString *)education
  {
    personName = name;
    personAge = age;
    employeeEducation = education;
    return self;
}

- (void)print
{
    NSLog(@"Name: %@", personName);
    NSLog(@"Age: %ld", personAge);
    NSLog(@"Education: %@", employeeEducation);
}

@end
*/