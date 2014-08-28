package main

import (
    "fmt"
    "time"
    "strconv"
)

var src [][]int
var dest [][]int
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

    numThreads := 5
    runs = 5
    barrier := NewCyclicBarrier(numThreads)
    var err_in error
    src, err_in = readGrayImage(fileName_in)

    if err_in == nil {
        width := len(src)
        height := len(src[0])

        // Kopiere Rand, da dieser nicht bearbeitet wird
        // 2-dimensional array
        dest = make([][]int, width)
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
        start := 1
        step := width / numThreads

        for i := 0; i < numThreads - 1; i++ {
            go run(barrier, start, start + step)
            start += step
        }

        go run(barrier, start, width - 1)

        err_out := writeGrayImage(fileName_out, src)

        if err_out != nil {
             fmt.Println("Error 1:")
        } else {
            after := time.Now().Unix()
            fmt.Println("Running " + strconv.Itoa(int(after - before)) + "ms")
        }
    } else {
        fmt.Println(err_in)
    }
}

func run(b *CyclicBarrier, start int, end int) {
    for i := 0; i < runs; i++ {
        for x:= start; x < end; x++ {
            for y := 1; y < len(src[x]) - 1; y++ {
                    value := src[x - 1][y - 1] + src[x + 1][y - 1] + src[x - 1][y + 1] + src[x + 1][y + 1]
                    value += 2 * (src[x][y - 1] + src[x - 1][y] + src[x + 1][y] + src[x][y + 1])
                    value += 4 * src[x][y]
                    dest[x][y] = value / 16
            }
        }

        b.Await()

        if start == 1 {
            tmp := src
            src = dest
            dest = tmp
        }

        b.Await()
    }
}