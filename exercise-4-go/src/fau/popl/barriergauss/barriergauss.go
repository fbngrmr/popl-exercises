package main

import (
    "fmt"
    "time"
)

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

    fileName_in := "/Users/fg/Documents/len_full.pgm"
    fileName_out := "/Users/fg/Documents/len_full_out.pgm"

    numThreads := 2
    runs = 5
    barrier := NewCyclicBarrier(numThreads)

    src, err_in := readGrayImage(fileName_in)

    if err_in == nil {
        width := len(src)
        height := len(src[0])

        // Kopiere Rand, da dieser nicht bearbeitet wird
        // 2-dimensional array
        dest := make([][]int, width)
        for i := range dest {
            dest[i] = make([]int, height)
        }

        for i := 0; i < height; i++ {
            dest[0][i] = src[0][i]
            dest[width -1][i] = src[width - 1][i]
        }

        for i := 0; i < width; i++ {
            dest[i][0] = src[i][0]
            dest[i][height -1] = src[i][height - 1]
        }

        before := time.Now().Unix()
        start = 1
        step := width / numThreads
        end = start + step

        for i := 0; i < numThreads; i++ {
            go func(start int) {
                run(barrier)
            }(i)
        }

        err_out := writeGrayImage(fileName_out, src)

        if err_out != nil {
             fmt.Println("Error 1:")
        } else {
            after := time.Now().Unix()
            fmt.Println("Running " + string(after - before) + "ms")
        }
    } else {
        fmt.Println(err_in)
    }
}

func run(b *CyclicBarrier) {
    for i := 0; i < runs; i++ {
        for x:= start; x < end; x++ {
            
        }
        println("round:", i)
        // ... do image manipulation ...
        //time.Sleep(100 * time.Millisecond)

        b.Await() //all goroutines go through this in the same time

        //println("switchImgs")

        if start == 1 {
            // the first thread switches the images for the next iteration step
            //switchImgs(src, dest)
        }

        b.Await()
    }
}