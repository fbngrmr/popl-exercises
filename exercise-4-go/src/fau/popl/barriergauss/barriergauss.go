package main

import (
    "fmt"
    "time"
    "strconv"
    "os"
)

var src [][]int
var dest [][]int
var runs int

func main() {

    // `os.Args` provides access to raw command-line arguments
    argsWithoutProg := os.Args[1:]

    fileName_in := argsWithoutProg[2]
    fileName_out := argsWithoutProg[3]

    numThreads, _ := strconv.Atoi(argsWithoutProg[0])
    runs, _ = strconv.Atoi(argsWithoutProg[1])
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
            fmt.Println("running " + strconv.Itoa(int(after - before)) + "ms with " + strconv.Itoa(numThreads) + " threads")
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