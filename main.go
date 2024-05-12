package main

import "fmt"

type car struct{
    noofwheels int;
   
}

func main(){
var cars car{};
fmt.Print(cars.noofwheels);

}