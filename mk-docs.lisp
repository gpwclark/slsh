#!/usr/bin/env sl-sh

(load "docstrings-to-md.lisp")

(if (ns-exists? 'mkdocs) (ns-enter 'mkdocs) (ns-create 'mkdocs))
(core::ns-import 'core)
(ns-import 'shell)

(defn filter-undocable-forms (sym-list)
	(filter (fn (x)
		(and
			(not (= x '*ns*))
			(not (= x '*repl-settings*))
			(not (= x '*ns-exports*))
			(not (= x 'tok-slsh-form-color))
			(not (= x 'tok-slsh-fcn-color))
			(not (= x 'tok-default-color))
			(not (= x 'tok-sys-command-color))
			(not (= x 'tok-sys-alias-color))
			(not (= x 'tok-string-color))
			(not (= x 'tok-invalid-color))
			(not (= x '*last-status*))
			(not (= x '*repl-settings*))
			(not (= x 'get-doc-list-for))
			(not (= x 'make-md-file))
			(not (= x 'make-md-file-with-docstrings))
			(not (= x '__completion_hook))
			(not (= x '__line_handler))
			(not (= x '__exec_hook))
			(not (= x '__prompt))
			(not (= x 'args))))
		sym-list))

(defn list-of-all-slsh-syms () (progn
	(defq sym-list (ns-symbols 'root))
	(for a-ns (filter (fn (x) (and
						(not (= x "docmd"))
						(not (= x "docparse"))
						(not (= x "docify"))
						(not (= x "root"))
						(not (= x "user")))) (ns-list)) (progn
		(append! sym-list (eval (to-symbol (str a-ns "::*ns-exports*"))))))
	(filter-undocable-forms (qsort sym-list))))

(defn get-doc-list-for
	(target-doc-form)
	(match target-doc-form
			(:single (append '() (last (list-of-all-slsh-syms))))
			(:lang (list-of-all-slsh-syms))))

(defn make-md-file-with-docstrings (index-file docstrings)
	(docmd::make-md-file index-file docstrings))

(defn make-md-file (index-file target-doc-form)
	(docmd::make-md-file
		index-file
		(map! (fn (x) (doc (to-symbol x)))
			  (get-doc-list-for target-doc-form))))

(ns-export '(make-md-file get-doc-list-for make-md-file-with-docstrings))

(ns-pop)
