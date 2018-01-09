# lecture 3


Paul Hegarty begins with a demonstration of making Concentration's button layout dynamic. He then reviews the first two lectures and continues diving into Swift.


- internal : default， 在app和framework中都可用
- private : “only callable from within this object“
- private(set) : readable outside this object，not settable，好神奇，private是within object，但是居然加上set之后readable outside this object
- fileprivate : access by any code in this source file
- public/open : 这是给framework用的，暂时我们在写framework之前都用不到

