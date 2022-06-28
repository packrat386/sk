sk
---

`sk` is a tool for collecting and running scripts

### Usage

```
 [packrat386] ~ > sk h
sk r(un)? <script> <args...> to run <script> with <args...>
sk l(ist)? to show the list of availble scripts
sk c(at)? <script> to print the named script
sk s(ave)? <file> to save the file as a script for sk to run (must be executable)
sk h(elp)? to show this usage message

the variable SK_SCRIPT_DIR should point to a directory where the scripts live and it defaults to ~/sk

sk home page: https://github.com/packrat386/sk
```

### Installation

Put `sk.sh` somewhere on your computer and then `source` it. Probably somewhere in your shell rc.

### FAQ

__Q: What does the name mean?__

A: `sk` stands for script kiddie.

__Q: What shells/platforms is this compatible with__

A: `sk` has been tested exclusively on my mac with whatever version of `bash` happened to be installed (I cba to check).

__Q: This seems like overkill for what's basically a directory of scripts__

A: That's not a question.

__Q: Why didn't you use `$OTHER_TOOL`?__

A: No good reason.

__Q: Has anybody ever actually asked any of the questions in the FAQ section?__

A: ...
