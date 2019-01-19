## Eclipse 常用快捷键

## 编辑

| 快捷键          | 用途                                 |
| ------------ | ---------------------------------- |
| Ctrl+1       | 快速修复                               |
| Ctrl+Shift+F | 格式化当前代码                            |
| Ctrl+Shift+M | 添加类的import导入                       |
| Ctrl+Shift+O | 组织类的import导入（有添加导入作用，又可以帮你去除没用的导入) |
| Ctrl+Y       | 重做（与撤销Ctrl+Z相反）                    |
| Alt+/        | 内容辅助（帮你省了多少次键盘敲打，太常用了）             |
| Ctrl+D       | 删除当前行或者多行                          |
| Alt+↓        | 当前行和下面一行交互位置（特别实用,可以省去先剪切,再粘贴了）    |
| Alt+↑        | 当前行和上面一行交互位置（同上）                   |
| Ctrl+Alt+↓   | 复制当前行到下一行（复制增加）                    |
| Ctrl+Alt+↑   | 复制当前行到上一行（复制增加）                    |
| Shift+Enter  | 在当前行的下一行插入空行（这时鼠标可以在当前行的任一位置）      |
| Ctrl+/       | 注释当前行,再按则取消注释                      |

## 选择

| 快捷键          | 用途           |
| ------------ | ------------ |
| Alt+Shift+↑  | 选择封装元素       |
| Alt+Shift+←  | 选择上一个元素      |
| Alt+Shift+→  | 选择下一个元素      |
| Shift+←      | 从光标处开始往左选择字符 |
| Shift+→      | 从光标处开始往右选择字符 |
| Ctrl+Shift+← | 选中光标左边的单词    |
| Ctrl+Shift+→ | 选中光标又边的单词    |

## 移动

| 快捷键    | 用途                   |
| ------ | -------------------- |
| Ctrl+← | 光标移到左边单词的开头，相当于vim的b |
| Ctrl+→ | 光标移到右边单词的末尾，相当于vim的e |

## 搜索

| 快捷键          | 用途                                       |
| ------------ | ---------------------------------------- |
| Ctrl+K       | 参照选中的Word快速定位到下一个                        |
| Ctrl+Shift+K | 参照选中的Word快速定位到上一个                        |
| Ctrl+J       | 正向增量查找（按下Ctrl+J后,你所输入的每个字母编辑器都提供快速匹配定位到某个单词,如果没有,则在状态栏中显示没有找到了,查一个单词时,特别实用,要退出这个模式，按escape建） |
| Ctrl+Shift+J | 反向增量查找（和上条相同,只不过是从后往前查）                  |
| Ctrl+Shift+U | 列出所有包含字符串的行                              |
| Ctrl+H       | 打开搜索对话框                                  |
| Ctrl+G       | 工作区中的声明                                  |
| Ctrl+Shift+G | 工作区中的引用                                  |

## 导航

| 快捷键                  | 用途                                  |
| -------------------- | ----------------------------------- |
| Ctrl+Shift+T         | 搜索类（包括工程和关联的第三jar包）                 |
| Ctrl+Shift+R         | 搜索工程中的文件                            |
| Ctrl+E               | 快速显示当前Editer的下拉列表（如果当前页面没有显示的用黑体表示） |
| F4                   | 打开类型层次结构                            |
| F3                   | 跳转到声明处                              |
| Alt+←                | 前一个编辑的页面                            |
| Alt+→                | 下一个编辑的页面（当然是针对上面那条来说了）              |
| Ctrl+PageUp/PageDown | 在编辑器中，切换已经打开的文件                     |

## 调试

| 快捷键          | 用途                  |
| ------------ | ------------------- |
| F5           | 单步跳入                |
| F6           | 单步跳过                |
| F7           | 单步返回                |
| F8           | 继续                  |
| Ctrl+Shift+D | 显示变量的值              |
| Ctrl+Shift+B | 在当前行设置或者去掉断点        |
| Ctrl+R       | 运行至行(超好用，可以节省好多的断点) |

## 重构

| 快捷键         | 用途                       |
| ----------- | ------------------------ |
| Alt+Shift+R | 重命名方法名、属性或者变量名           |
| Alt+Shift+M | 把一段函数内的代码抽取成方法           |
| Alt+Shift+C | 修改函数结构                   |
| Alt+Shift+L | 抽取本地变量                   |
| Alt+Shift+F | 把Class中的local变量变为field变量 |
| Alt+Shift+I | 合并变量（可能这样说有点不妥Inline）    |
| Alt+Shift+V | 移动函数和变量（不怎么常用）           |
| Alt+Shift+Z | 重构的后悔药（Undo）             |

## 其他

| 快捷键       | 用途                      |
| --------- | ----------------------- |
| Alt+Enter | 显示当前选择资源的属性             |
| Ctrl+↑    | 文本编辑器 上滚行               |
| Ctrl+↓    | 文本编辑器 下滚行               |
| Ctrl+M    | 最大化当前的Edit或View （再按则反之） |
| Ctrl+O    | 快速显示 OutLine            |
| Ctrl+T    | 快速显示当前类的继承结构            |
| Ctrl+W    | 关闭当前Editer              |
| Ctrl+L    | 文本编辑器 转至行               |
| F2        | 显示工具提示描述                |

![eclipse-keys](http://www.znsd.com/znsd/courses/uploads/25056dd3a906571a5b49c55c8283152d/eclipse-keys.png)


### eclipse解决xml配置文件没有提示

-  以struts2配置文件为例

```xml
 <!DOCTYPE struts PUBLIC
       "-//Apache Software Foundation//DTD Struts Configuration 2.0//EN"
       "http://struts.apache.org/dtds/struts-2.0.dtd">
```

- 找到struts-2.0.dtd约束文件所在位置

![20180531201128](http://www.znsd.com/znsd/courses/uploads/1e90f0ed924b16501cf5296dc2ce4602/20180531201128.png)

- 打开eclipse –> Preferences –> 左上角数据`xml catalog`选择，右边点击add 

![20180531201321](http://www.znsd.com/znsd/courses/uploads/7f5129d1e1ddcc7fdf167b322d39e335/20180531201321.png)

- 点击File System选择之前struts2的dtd文件  `Key type`选择为URI  `Key`复制之前<http://struts.apache.org/dtds/struts-2.0.dtd>进去 

![20180531201611](http://www.znsd.com/znsd/courses/uploads/c572b989d9cfbf80ae2e1da37087b788/20180531201611.png)

1. 点击`ok`保存再重新打开的配置文件按下eclipse的代码提示快捷键(Alt+/)就可以看到提示了！
