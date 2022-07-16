package main

import "fmt"

func MtoF(m float64) (f float64) {
	f = m * 3.281
	return
}

func main() {
	fmt.Print("Input length in meters: ")
	var input float64
	fmt.Scanf("%f", &input)

	output := MtoF(input)

	fmt.Printf("Footage: %v\n", output)
}
