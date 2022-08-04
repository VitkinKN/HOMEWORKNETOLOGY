# HOMEWORK_GOLANG_BASIC_7_5_(VITKIN_K_N)

### 1. Установите golang.. 
```
konstantin@konstantin-forever ~/Загрузки $ sudo tar -C /usr/local -xzf go1.18.4.linux-amd64.tar.gz
[sudo] пароль для konstantin: 
konstantin@konstantin-forever ~/Загрузки $ export PATH=$PATH:/usr/local/go/bin
konstantin@konstantin-forever ~/Загрузки $ go version
go version go1.18.4 linux/amd64
konstantin@konstantin-forever ~/Загрузки $ 
```


___
### 2. Написание кода.
- *Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные у пользователя, а можно статически задать в коде. Для взаимодействия с пользователем можно использовать функцию Scanf:*
```
package main

import "fmt"

func main() {
	var meters float64
	meters = 1
	fmt.Println("В метрах: ", meters)
	var feet = 3.281 * meters
	fmt.Println("В футах: ", feet)
}

```

- *Напишите программу, которая найдет наименьший элемент в любом заданном списке, например:*
```
x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
```
```
package main

import "fmt"

func main() {
	x := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
	var minimum int = x[1]
	for a := 1; a < len(x); a++ {
		if x[a] < minimum {
			minimum = x[a]
		}
	}
	fmt.Println("Minimum ", minimum)
}

```
- *Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть (3, 6, 9, …)*
```
package main

import "fmt"

func main() {
	for i := 1; i <= 100; i++ {
		if (i % 3) == 0 {
			fmt.Print(" ", i)
		}
	}
	fmt.Println()
}
```
___
