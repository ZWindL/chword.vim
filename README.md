# Chinese Word 中文词汇

（开发中）

Inspired by [tumashu/pyim](https://github.com/tumashu/pyim), [targets.vim](https://github.com/wellle/targets.vim)

## 功能
1. 中文词汇文档对象，适用于 `daw` 等命令 *施工中*
2. 使用 `w`, `b`, `e` 在中文文本中跳转

### How it works?
chword.vim 使用词典文件匹配光标前/后的第一个中文词语，求出长度后进行移动。
将来（可能）支持 jieba 词库。

## 安装
推荐使用 [vim-plug](https://github.com/junegunn/vim-plug), 在 `vimrc` 中加入

``` vim-script
call plug#begin('YOUR_OWN_PATH')
    Plug 'ZWindL/chword.vim'
call plug#end()
```

## TODO
* [x] 支持固定词库
* [ ] 支持 jieba 分词工具
* [x] 支持自定义词库
* [ ] 支持自定义贪婪模式或最小词模式
* [ ] 文档

## 已知问题
### 分词不准确
是的，这个 plugin 的初衷只是为了使用户保持体验上的一致，不会在按下 w 后跳过一整句
中文。

### 计数模式（3w, 3b）现在用不了
正在支持中。

### 与 targets.vim 等 text object plugin 冲突
是的，可能会冲突，有待验证。
