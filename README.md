# Emacs China Blog 

尝试搭建一个类似 [Emacs中文网](http://emacser.com/) 的多人博客。

## Getting Started

首先需要安装 Pandoc 以支持 Org mode，之后构建：

~~~sh
bundle install
bundle exec nanoc
bundle exec nanoc view
~~~

然后访问 http://localhost:3000/ 预览结果。

## TODO

- [x] Markdown
- [x] Org mode
- [x] 代码高亮，通过 Google Code Prettify（因为它的 Emacs Lisp 支持比较好）
- [x] RSS
- [ ] 部署到 GitHub Page
- [ ] 添加评论系统，通过 Emacs China 论坛（Discourse）
- [ ] ...

## Contributing

这个项目远未完成，任何方面的帮助都非常欢迎，尤其是 Web 设计。
