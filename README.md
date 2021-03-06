# Simple Lisp Shell

![Rust](https://github.com/sstanfield/slsh/workflows/Rust/badge.svg?branch=master)

This is a shell built around a simple version of lisp for scripting.  The prompt
also follows this pattern (with the exception that you can leave out the outer
parentheses).  It is NOT a POSIX shell and makes no attempts to be one.

It supports quote and backquote (with , and ,@ expansion).

It supports Common Lisp style keyword symbols with colon.

The config directory is \~/.config/sl-sh.  The binary will have a built in config (lisp/slshrc),
you can put your own slshrc file the config directory (\~/.config/sl-sh).
See the file slshrc.example (at least look at this one), lisp/slshrc (this is the built in config)
or the contrib directory for example configs (contrib/gpwclark/ contains an example of using bash
completions with sl-sh as well as other handy things).  The other files in lisp/ are also built
into the binary but versions can be copied to \~/.config/sl-sh and those will be used instead.
These files contain the lisp code for the shell (anything from the tables below that is not builtin).

## Building

* `cargo build --release`

## Pre-built packages

### Arch
* sl-sh is in the AUR as `sl-sh-git`

## Tasks
- [ ] file-io and idiomatic file iteration in sl-sh
- [ ] better error reporting and debugging
- [ ] benchmarks
- [ ] better maths
- [ ] regular expressions
- [ ] add better documentation about some of the useful shell features implemented in sl-sh and goodies inherited from liner

## Examples
Currently sparse but if you grep lisp/ and contrib/ for a form you want an example of you will probably find one.

## ~/.config/sl-sh/slshrc extensions
The following section details functionality to extend and modify the behavior of
the shell.

### Prompt/PS1
The command prompt for the shell is customize-able via the `__prompt` function. The
function takes no arguments and expects a string to be returned. The canonical
prompt in sl-sh would simply be:
```
	(defn __prompt()
		(str "$ "))
```

### Command processing
sl-sh offers two "hooks" for intercepting commands being executed:
`__completion_hook` and `__exec_hook`.
- `__completion_hook` is used to aid in tab completions. It takes a varargs and
expects a list of string to be returned. For convenience 'path and 'default
are also allowable return values. 'path represents the list of paths and
'default is 'path concatenated with all valid sl-sh forms.
- `__exec_hook` is an intercept function for every command sent to sl-sh. The
function takes a string and expects a string or list to be returned. The string
returned will be evaluated as a sl-sh form and a list will just be evaluated.
This is useful if you want to check all input and modify said input if it meets
certain conditions. For instance, if one were to decide that inputting any
valid path to sl-sh should result in the shell changing the current working
directory to that directory:
```
	(defn change-dir-if-arg-is-dir (cmd)
			(if (fs-dir? cmd)
				(str "cd " cmd)
				cmd))

	(defn __exec_hook (cmd-to-execute)
		(let ((args-list (str-split " " cmd-to-execute)))
				(match (length args-list)
					(1 (change-dir-if-arg-is-dir (first args-list)))
					(nil cmd-to-execute))))
```


### Readline Functionality
sl-sh uses a readline-like library to make using the shell ergonomic. Like bash
there are two "modes" vi and emacs, the default is emacs. Setting the mode
explicitly to emacs:
```
	(hash-set! *repl-settings* :keybindings :emacs)
```
Or setting the mode explicitly to vi:
```
	(hash-set! *repl-settings* :keybindings :vi)
```
Setting the max number of history items (default 1000):
```
	(hash-set! *repl-settings* :max-history 1000)
```

#### vi mods

For the convenience of vi users the vi escape char can be changed:
```
	(hash-set! *repl-settings* :vi_esc_sequence '("jk" 200))
```
The first argument is the list of chars that indicate the esc sequence and the
seconds argument is the number of ms the readline library will wait to receive
the full escape sequence.

Because vi uses modal editing and because modal editing has state the readline
library allows modifying the last line of PS1 in any way the user desires The
following four settings apply:
```
	(hash-set! *repl-settings* :vi-insert-prompt-prefix "")
	(hash-set! *repl-settings* :vi-insert-prompt-suffix "")
	(hash-set! *repl-settings* :vi-normal-prompt-prefix "")
	(hash-set! *repl-settings* :vi-normal-prompt-suffix "")
```
In practice it is useful to extend the last line of PS1 in one or both of vi's
editing modes to be prefixed or suffixed with strings To provide context to
the user. The -suffix commands are especially useful if using foreground or
background color codes and restoration to the default is desired.

### Look and Feel
If syntax highlighting is desired it can be explicitly turned on:
```
	(syntax-on)
```
The distinction is made between, sl-sh forms, invalid commands, valid
executables, and any token that is not a sl-sh form and not the first string
input as a command.

Default colors are as follows:
```
	(defq tok-slsh-form-color shell::*fg-blue*)
	(defq tok-slsh-fcn-color shell::*fg-cyan*)
	(defq tok-default-color shell::*fg-default*)
	(defq tok-sys-command-color shell::*fg-white*)
	(defq tok-sys-alias-color shell::*fg-default*)
	(defq tok-string-color shell::*fg-magenta*)
	(defq tok-invalid-color shell::*fg-red*)
```

These symbols are exported from the shell namespace and can be set.  Example:
(setq tok-sys-alias-color shell::*fg-green*)

#### Color

The following
colors are defined in the shell namespace:
```
	(def '*fg-default* "\x1b[39m")
	(def '*fg-black* "\x1b[30m")
	(def '*fg-red* "\x1b[31m")
	(def '*fg-green* "\x1b[32m")
	(def '*fg-yellow* "\x1b[33m")
	(def '*fg-blue* "\x1b[34m")
	(def '*fg-magenta* "\x1b[35m")
	(def '*fg-cyan* "\x1b[36m")
	(def '*fg-white* "\x1b[37m")

	(def '*bg-default* "\x1b[49m")
	(def '*bg-black* "\x1b[40m")
	(def '*bg-red* "\x1b[41m")
	(def '*bg-green* "\x1b[42m")
	(def '*bg-yellow* "\x1b[43m")
	(def '*bg-blue* "\x1b[44m")
	(def '*bg-magenta* "\x1b[45m")
	(def '*bg-cyan* "\x1b[46m")
	(def '*bg-white* "\x1b[47m")
```
Functions that take rgb values are also defined `(fg-color-rgb)` and
`(bg-color-rgb)`. For example:
```
	(println
		(str
			(fg-color-rgb 255 0 0)
			(bg-color-rgb 0 0 255)
			"I have red text and a blue background"
			shell::*fg-default*
			shell::*bg-default*))
```
Prints this "truth-telling" string while also not changing any chars printed after
by setting the fg and bg back to the default.

### Error reporting
Use
```
	(error-stack-on)
```
if stack traces are desired. The default is
```
	(error-stack-off)
```

## Scripting
Sl-sh supports scripts. If you put a `#!/path/to/sl-sh` at the top
of a file and run `chmod +x` on it, it will be executable. If you pass
arguments to a sl-sh script, the parameters will be available as a vector,
`args`.


## Documentation of available forms
- [sl-sh documentation page](https://sstanfield.github.io/slsh)
- notes on building the documentation are [here](https://github.com/sstanfield/slsh/wiki/Building-the-docs)

## Cross Compiling
- notes on cross compiling for various platforms are [here](https://github.com/sstanfield/slsh/wiki/Cross-Compiling)
