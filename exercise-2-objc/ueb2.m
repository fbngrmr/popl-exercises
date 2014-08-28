#import <Foundation/Foundation.h>
 
@interface Animal : NSObject

{
    NSString *animalName;
    NSInteger animalId;
    _Bool animalCarnivore;
}

- (id)initWithName:(NSString *)name andCarnivore:(_Bool)carnivore;
- (void)print;
@end

@implementation Animal

- (id)initWithName:(NSString *)name andCarnivore:(_Bool)carnivore {
    animalName = name;
    animalCarnivore = carnivore;
    animalId = 5;

    return self;
}

- (void)print{
    NSLog(@"name: %@", animalName);
    NSLog(@"carnivore: %ld", animalCarnivore);
}

@end

@interface Mammal : Animal
{

}
@end

@implementation Mammal

- (id)initWithName:(NSString *)name andCarnivore:(_Bool)carnivore {
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
    Animal *animal = [[Animal alloc]initWithName:@"Raj" andAge:5];
    [animal print];
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