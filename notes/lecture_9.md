# lecture 9

Paul Hegarty delves into the view controller lifecycle – keeping track of what's happening in your Controller as it goes through its lifetime – and then demonstrates putting print()s into the multiple-MVC version of Concentration. He then covers scroll view. 

- View Controller lifecycle: 除了一般带的viewDidLoad之外，还有一大堆，viewWillAppear， viewDidAppear， 要弄清楚比如不是viewWillAppear就会真的appear的，还有一大堆负责掌管viewWillLayoutSubviews, awakeFromNib是只有从IB构建才会调用
- UIScrollView除了老师给的这个demo意外，还有一些别的class也是天生继承它的，Cassini的例子也用到了view life cycle