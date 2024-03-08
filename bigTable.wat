(module
    (import "thing" "logbits" (func $log (param i64)))
    (memory 1)
    ;; TOD0: make bigger to reduce itterations
    (data (i32.const 0)
        "\00\20\01\00\03\30\02\00\03\38\00\28\02\08\01\08\02\10\03\20\01\10\00\30\01\18\02\18\00\38\03\28\00\00\03\10\01\20\02\20\01\28\00\08\02\28\03\18\02\30\01\30\03\00\00\10\03\08\02\38\00\18\01\38")

    (func $hilbyss (export "hilbyss") (param $x f64) (param $y f64) (result f64)
        (local $xh i64)
        (local $yh i64)
        (local $state i64)
        (local $top i64)
        (local $v i64)
        (local.set $xh
            (i64.shr_u
                (i64.reinterpret_f64
                    (f64.add
                        (f64.const 1)
                        (f64.mul
                            (local.get $x)
                            (f64.const 0.9999999999999998))))
                (i64.const 26)))
        (local.set $yh
            (i64.shr_u
                (i64.reinterpret_f64
                    (f64.add
                        (f64.const 1)
                        (f64.mul
                            (local.get $y)
                            (f64.const 0.9999999999999998))))
                (i64.const 26)))
        (local.set $v
            (i64.or
                (i64.shl
                    (i64.and
                        (i64.const 0x55555555555555)
                        (i64.or
                            (i64.or
                                (i64.or
                                    (i64.mul
                                        (local.set $v (i64.and (local.get $yh) (i64.const 0x0802080)))
                                        (local.get $v)
                                        (local.get $v))
                                    (i64.mul
                                        (local.set $v (i64.and (local.get $yh) (i64.const 0x00a8820)))
                                        (local.get $v)
                                        (local.get $v)))
                                (i64.or
                                    (i64.mul
                                        (local.set $v (i64.and (local.get $yh) (i64.const 0x0500441)))
                                        (local.get $v)
                                        (local.get $v))
                                    (i64.mul
                                        (local.set $v (i64.and (local.get $yh) (i64.const 0x1015100)))
                                        (local.get $v)
                                        (local.get $v))))
                            (i64.or
                                (i64.mul
                                    (local.set $v (i64.and (local.get $yh) (i64.const 0x0040014)))
                                    (local.get $v)
                                    (local.get $v))
                                (i64.mul
                                    (local.set $v (i64.and (local.get $yh) (i64.const 0x220020a)))
                                    (local.get $v)
                                    (local.get $v)))))
                    (i64.const 2))
                (i64.shl
                    (i64.and
                        (i64.const 0x55555555555555)
                        (i64.or
                            (i64.or
                                (i64.or
                                    (i64.mul
                                        (local.set $v (i64.and (local.get $xh) (i64.const 0x0802080)))
                                        (local.get $v)
                                        (local.get $v))
                                    (i64.mul
                                        (local.set $v (i64.and (local.get $xh) (i64.const 0x00a8820)))
                                        (local.get $v)
                                        (local.get $v)))
                                (i64.or
                                    (i64.mul
                                        (local.set $v (i64.and (local.get $xh) (i64.const 0x0500441)))
                                        (local.get $v)
                                        (local.get $v))
                                    (i64.mul
                                        (local.set $v (i64.and (local.get $xh) (i64.const 0x1015100)))
                                        (local.get $v)
                                        (local.get $v))))
                            (i64.or
                                (i64.mul
                                    (local.set $v (i64.and (local.get $xh) (i64.const 0x0040014)))
                                    (local.get $v)
                                    (local.get $v))
                                (i64.mul
                                    (local.set $v (i64.and (local.get $xh) (i64.const 0x220020a)))
                                    (local.get $v)
                                    (local.get $v)))))
                    (i64.const 1))))
        (local.set $yh (i64.const 0))
        (local.set $state (i64.const 0))
        (local.set $top (i64.const 50))
        (loop $shift
            (local.set $xh
                (i64.or
                    (local.get $state)
                    (i64.and
                        (i64.const 6)
                        (i64.shr_u
                            (local.get $v)
                            (local.get $top)))))
            (local.set $top (i64.sub (local.get $top) (i64.const 2)))
            (local.set $yh
                (i64.or
                    (i64.shl
                        (local.get $yh)
                        (i64.const 2))
                    (i64.and
                        (i64.const 255)
                        (i64.load (i32.wrap_i64 (local.get $xh))))))
            (local.set $xh (i64.add (local.get $xh) (i64.const 1)))
            (local.set $state
                (i64.and
                    (i64.const 255)
                    (i64.load (i32.wrap_i64 (local.get $xh)))))
        (br_if $shift (i64.ge_s (local.get $top) (i64.const 0))))
    (call $from52fracbitsToFloat (local.get $yh)))
)
