


(module
    (import "console" "log" (func $log (param i64)))
    (memory 1)
    (data (i32.const 0) "\00\00\00\00")
    (func $test
        (call $log (i32.load (i32.const 0)))
    )
    (start $test)
)
