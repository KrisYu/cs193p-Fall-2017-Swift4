# lecture 4


Paul Hegarty continues his coverage of Swift. 

- protocol: Swift本身自带很多协议，你可以让你的类/struct遵循某些协议。比如 Hashable，只有遵循了 Hashable，某个类/struct才可以做dictionary的key,并且发现这个类/struct可以直接比较是否相等。
- 写了一个Collection extension，collection包本身是协议，是array,dictionary,set遵循的协议，感觉协议的好处是我们遵循协议，而不用继承，因为有的时候继承不是特别合适，协议就可以跳出来，protocol programming也是一种编程范式吧
- closure: 虽说closure就是匿名函数，但是要注意它的close周围变量的特性，同时closure可以各种简写
- NSAttributedString: 就是有属性的String, NS一般是OC的类
- struct: 把concentration-game logic变成了struct，struct改变自身的函数需要加上mutating