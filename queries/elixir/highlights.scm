; extends
;; (unary_operator
;;   operator: "@"
;;   operand: (call
;;              ((arguments (_) @comment .) @comment)
;;              ) @comment
;;   ) @comment

;; (unary_operator
;;   operator: "@"
;;   operand: (call
;;              ((arguments (
;;                           (binary_operator
;;                             left: (_) @comment
;;                             right: (_) @comment
;;                             ) @comment
;;                           ) @comment .) @comment)
;;              ) @comment
;;   ) @comment
