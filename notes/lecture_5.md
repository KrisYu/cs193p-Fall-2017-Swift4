# lecture 5


Paul Hegarty covers error handling, special types any and anyobject, and casting. He then introduces views.

- error handling: 有些函数是要throw的，这种我们要配合 do/catch 或者try使用
- Any： Any是遗留问题，可以不用的时候尽量避免它
- type cast： 除了最常见的用括号直接来type cast，我们可以用 as? 来转换
- view： view多种init方式，比如直接从stroyboard拖拽放在另一个view上，或者我们programmatically addsubview,这种initializer要写好，免得fatalError|||
- enum： 它可以有关联值，可以有函数
- ...更多notes在demo中