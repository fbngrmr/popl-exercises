package main

import "fmt"

var src [][]int
var dest [][]int
var start int
var end int
var runs int

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

    numThreads := 2
    run := 1
    fileName_in := "/Users/fg/Documents/len_full.pgm"
    fileName_out := "/Users/fg/Documents/len_full_out.pgm"


    fmt.Println(parseFileName(fileName));

    src, err := readGrayImage(fileName)

    if err != nil {
        fmt.Println(err)
    } else {

    }

    err_out := writeGrayImage("/Users/fg/Documents/len_full_out.pgm", src)

    if err_out != nil {
         fmt.Println(err_out)
    }
}