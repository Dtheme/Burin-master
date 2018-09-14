# Burin

iOS reverse development，command line utils that uses Cycript.

### 为什么要写Burin

通过逆向的方式可以窥探和猜测别人的APP对于某些功能的实现方式，从而对自己的开发过程提供一些借鉴，使用Cycript脚本可以帮助理解别人的app。Cycript非常强大， 它是一个能够理解Objective-C语法的javascript解释器，但是在使用过程中发现经常会做一些重复的操作，写一些重复代码，不仅麻烦而且稍微不注意就容易出现拼写大小写等错误，效率比较低，没有代码补全的情况下写OC代码有多痛苦，写过的人都知道。

例如：获取沙盒document路径这样的代码，得背API：

```objective-c
NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
```

所以对一些常用API进行了封装，简化常用的一些操作，例如：获取沙盒各文件夹路径，获取当前的viewcontroller，获取当前的keywindow，隐藏/显示某个view，方便的创建CGRect、CGPoint、CGSize，查看某个类的类方法，实例方法，成员变量，属性等。

### 使用：

越狱环境下可以直接将Burin文件注入到iPhone里。非越狱环境下可以通过重签名、重新打包ipa，通过动态库的方式注入。

顺口一提，截止到目前，官方给出的数据是85%的用户在使用iOS 11，10%用户使用iOS 10，而iOS 11目前暂时还没有完美越狱，完美越狱变得越来越有难度，[这里是Apple support数据。](https://developer.apple.com/support/app-store/)



使用：命令行中引入Burin库

```js
cy# @import ../<path>/Burin
```

直接调用定义的方法进行调试：

```js
cy# lookUpBundleId
@"com.xxx.xxx"
```

在使用过程遇到觉得有必要封装的会再补充进来。

### 最后


更多关于cycript的问题可以看：[Cycript](http://www.cycript.org)。

 [Read Manual](http://www.cycript.org/manual/)里面有你想要的一切关于cycript的使用方法。
