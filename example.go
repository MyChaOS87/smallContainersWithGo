package main

import (
	"fmt"
	"net/http"
	"time"
)

func main()  {
	fmt.Println("Hello World!")

	t := time.Now()

	loc := "America/New_York"

	if locNY, err := time.LoadLocation(loc); err != nil{
		fmt.Printf("Error loading location %s: %s\n", loc, err.Error())
	} else {
		fmt.Printf("Time in New York: %s\n", t.In(locNY))
	}

	loc = "Europe/Berlin"
	if locMuc, err := time.LoadLocation(loc); err != nil{
		fmt.Printf("Error loading location %s: %s\n", loc, err.Error())
	} else {
		fmt.Printf("Time in Berlin: %s\n", t.In(locMuc))
	}

	if resp, err := http.Get("https://google.com"); err != nil {
		fmt.Println(err.Error())
	} else {
		fmt.Printf("response from https://google.com %s\n", resp.Status)
	}
}