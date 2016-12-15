# 无限滚动模块

## InfiniteScroll()

```alert
依赖：Zepto 或 jQuery
```

### 初始化

只能手动初始化

```js
var scroller = new InfiniteScroll(wrapper, scrollHeight, scrollCallback, option);
```

|参数说明|    |
|-------|------|
|`wrapper`|需要无限滚动的容器，一个占位的元素将插在此容器最前面，类型为`原生DOM`，若用`jQuery元素`，需使用`$el[0]`获取原生DOM元素|
|`scrollHeight`|占位元素的高度，类型为`number`|
|`scrollCallback`|每次滚动将触发的回调函数，将输入一个0～1的小数，代表当前位置在整个可滚动范围的百分比，最上方为0，最下方为1，类型为`function`|
|`option`|可选，为一个object，将接收两个属性：`lowExpand`和`highExpand`，分别代表在可滚动范围之前和之后的占位高度，用以避免在最前最后的位置互相跳转时因渲染时间过长而造成的页面停顿感，默认都为输入`scrollHeight`的0.1倍|

|暴露方法|    |
|------|------|
|`setScrollHeight(height)`|用于更新可滚动范围，输入参数`height`类型为`number`|
|`travelTo(target, callback, option)`|用于定位到目标高度，`target`为`object`，可传入两个属性其中一个：`scroll`或`progress`，若两个都有定义，则按`scroll`为准。`callback`为到达目标位置之后调用的回调函数。默认滚动方向为取就近方向，如从10%到20%，将向下移动；如从10%到90%，将向上移动（10% -> 0%(100%) -> 90%），若指定了`option`中的`towards`属性为`UP`或`DOWN`，将固定为向上、向下移动；若指定了`option`的`jump`属性为`true`（或其他可以转化为true的值），则直接跳到目标位置|
