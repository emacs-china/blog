---
title: "Sort Sexps"
author: "Chunyang Xu"
created_at: "2017-08-19T20:44:23+08:00"
---

最近碰到一个需要排序代码的情况，在给 Org Babel 添加了很多语言之后，顺序完全没规律，看起来不方便，给语言按照字母表排个序就好了：

~~~el
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (sh         . t)
   (lisp       . t)
   (org        . t)
   (perl       . t)
   (R          . t)
   (ruby       . t)
   (python     . t)
   (scheme     . t)
   (C          . t)
   (ditaa      . t)
   (latex      . t)
   (awk        . t)
   (lua        . t)))
~~~

这个格式已经很整齐了，稍微再整理下用 `M-x sort-lines` 或 `C-u M-| sort` 就能达到目的，但是如果排序的单元不以行为单位，比如：

~~~el
((emacs-lisp . t) (sh . t) (lisp . t) (org . t) (perl . t) (ruby . t))
~~~

这种方法无能为力了。受到网上一些讨论的启发，用 `sort-subr` 结合 Emacs Syntax Table 能解决问题：

- `sort-subr` 函数是排序 Buffer 的内容的底层函数，调用者可以设置排序的元素的范围和如何比较它们
- `(skip-syntax-forward "-.>")` 分别跳过 Sexps 之间的空白字符(`-`)、标点符号(`.`)和换行符号(`>`)

~~~el
(defun sort-sexps (reverse beg end)
  "Sort sexps in the Region."
  (interactive "*P\nr")
  (save-restriction
    (narrow-to-region beg end)
    (goto-char (point-min))
    (let ((nextrecfun (lambda () (skip-syntax-forward "-.>")))
          (endrecfun  #'forward-sexp))
      (sort-subr reverse nextrecfun endrecfun))))
~~~

Emacs 把 Lisp 的 Sexp 的概念扩展到了其他的语言

> Basically, a sexp is either a balanced parenthetical grouping, a string, or a
> symbol


比方说同一个段文字 `3 + 2 + 1`，在下面的 C 代码中，其中 `3`, `2` `1` 分别都是 Sexp，而剩余的空格和操作符号 `+` 不是，从而导致了 `M-x sort-sexps` 只排序 `3`, `2`, `1`

~~~c
/* -*- mode: c; -*- */
int x = 3 + 2 + 1;
/* M-x sort-sexps */
int x = 1 + 2 + 3;
~~~

而在 Emacs Lisp 代码中，`3`, `+`, `2`, `+`, `1` 都是 Sexp，所以它们都会被排序。

~~~el
;; -*- mode: emacs-lisp; -*-
(setq x '(3 + 2 + 1))
;; M-x sort-sexps
(setq x '(+ + 1 2 3))
~~~

排序一个 C 字符串数组也能得到预期的结果：

~~~c
/* -*- mode: c; -*- */
char *characters[] = { "Tom", "Jerry", "Nibbles", "Quacker" };
/* M-x sort-sexps */
char *characters[] = { "Jerry", "Nibbles", "Quacker", "Tom" };
~~~

`sort-sexps` 用的是 `sort-subr` 默认的比较方法（即用 `string<` 比较整个 Record），通过设置 `sort-subr` 的参数可以做调整。比如按照数字的大小

~~~el
(defun sort-numbers (reverse beg end)
  "Sort numbers in the Region."
  (interactive "*P\nr")
  (save-restriction
    (narrow-to-region beg end)
    (goto-char (point-min))
    (let ((nextrecfun (lambda () (skip-syntax-forward "-.>")))
          (endrecfun  #'forward-sexp)
          (startkeyfun (lambda ()
                         (or (number-at-point)
                             (user-error "Sexp doesn't looks like a number")))))
      (sort-subr reverse nextrecfun endrecfun startkeyfun))))


'(3 1 4 10 2)

;; sort-sexps
'(1 10 2 3 4)

;; sort-numbers
'(1 2 3 4 10)
~~~
