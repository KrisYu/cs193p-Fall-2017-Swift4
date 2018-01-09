# lecture 1


Paul Hegarty provides an overview of the lecture series and introduces the different components in iOS. He concludes with a demo of Concentration Game.



- property observer： 有willSet 和 didSet，每次值改变都会被call。demo 里面didSet写的非常优雅，每次flipCount改变，我们都可以改变flipCountLabel的值。
- implicitly unwrapped optional: flipCountLabel 的类型是 UILabel!， 因为一旦flipCountLabel被设置之后就会一直有值，为了避免一直强制解析，所以我们用 implicitly unwrapped optionals，退拽Outlet默认都是implicitly unwrapped optional.
- outlet collection： 就是outlet的array
- swift是 strong type，但是擅长于推断类型，所以可以省略很多
- @IBAction: IBOutlet是属性，这个是action， IB代表interface builder
- Argument Label: “You write an argument label before the parameter name, separated by a space” 以为这个就是外部名字和内部名字，好处是让函数读起来更优雅，比如这种: `func flipCard(withEmoji emoji: String, on button: UIButton)`
- if let 配合unwrap optional
- 正如别的语言的array一样，swift 的 array 同样有很多方法