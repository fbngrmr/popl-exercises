package main

import "fmt"

func main() {

    // `os.Args` provides access to raw command-line
    // arguments. Note that the first value in this slice
    // is the path to the program, and `os.Args[1:]`
    //argsWithoutProg := os.Args[1:]

    // You can get individual args with normal indexing.
    //arg := os.Args[3]

    //fmt.Println(argsWithProg)
    //fmt.Println(argsWithoutProg)
    //fmt.Println(arg)

    fileName := "/Users/fg/Documents/len_full.pgm"

    fmt.Println(parseFileName(fileName));

    src,_ := readGrayImage(fileName)

    fmt.Println(len(src))
}