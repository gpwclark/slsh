(defn lists= (list1 list2)
    (if (not (= (length list1)(length list2)))
        nil
        (if (= (length list1) 0)
            t
            (if (not (= (first list1)(first list2)))
                nil
                (recur (rest list1) (rest list2))))))
                

(let ((l1 '(1 2 3)) (l2 '(a b c)) (l3 '(1 2 (a b c) 3)) (l4))
    (if (and (= (first l1) 1) (lists= l1 '(1 2 3)))
        (println "PASS") (println "FAIL"))
    (if (and (lists= (rest l1) '(2 3)) (lists= l1 '(1 2 3)))
        (println "PASS") (println "FAIL"))
    (if (= (length l1) 3)
        (println "PASS") (println "FAIL"))
    (if (and (= (last l1) 3) (lists= l1 '(1 2 3)))
        (println "PASS") (printnl "FAIL"))
    (if (and (lists= (butlast l1) '(1 2)) (lists= l1 '(1 2 3)))
        (println "PASS") (println "FAIL"))
    (if (and (= (vnth 1 l1) 2) (lists= l1 '(1 2 3)))
        (println "PASS") (println "FAIL"))
    (if (and (lists= (vsetnth! 1 'x l1) '(1 x 3)) (lists= l1 '(1 x 3)))
        (println "PASS") (println "FAIL"))
    (if (and (lists= (append l1 l2) '(1 x 3 a b c)) (lists= l1 '(1 x 3)) (lists= l2 '(a b c)))
        (println "PASS") (println "FAIL"))
    (if (and (lists= (push! l1 4) '(1 x 3 4)) (lists= l1 '(1 x 3 4)))
        (println "PASS") (println "FAIL"))
    (setq l4 (vnth 2 l3))
    (push! l4 'd)
    (if (and (lists= (vnth 2 l3) '(a b c d)) (lists= l4 (vnth 2 l3)))
        (println "PASS") (println "FAIL"))
    (if (and (= (pop! l1) 4) (lists= l1 '(1 x 3)))
        (println "PASS") (println "FAIL"))
    (if (and (lists= (vremove-nth! 1 l1) '(1 3)) (lists= l1 '(1 3)))
        (println "PASS") (println "FAIL"))
    (if (not (is-empty l1))
        (println "PASS") (println "FAIL"))
    (if (and (lists= (vclear! l1) '()) (lists= l1 '()))
        (println "PASS") (println "FAIL"))
    (if (is-empty l1)
        (println "PASS") (println "FAIL"))
    (if (and (lists= (vinsert-nth! 0 2 l1) '(2)) (lists= l1 '(2)))
        (println "PASS") (println "FAIL"))
    (if (and (lists= (vinsert-nth! 0 1 l1) '(1 2)) (lists= l1 '(1 2)))
        (println "PASS") (println "FAIL"))
    (if (and (lists= (vinsert-nth! 2 3 l1) '(1 2 3)) (lists= l1 '(1 2 3)))
        (println "PASS") (println "FAIL"))
    (if (and (lists= (vinsert-nth! 1 'a l1) '(1 a 2 3)) (lists= l1 '(1 a 2 3)))
        (println "PASS") (println "FAIL" l1))
    )

