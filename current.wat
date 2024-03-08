(module
    (import "thing" "logbits" (func $log (param i64)))
    (memory 1)
    ;; TOD0: make bigger to reduce itterations
    (data (i32.const 0)
        "\00\20\01\00\03\30\02\00\03\38\00\28\02\08\01\08\02\10\03\20\01\10\00\30\01\18\02\18\00\38\03\28\00\00\03\10\01\20\02\20\01\28\00\08\02\28\03\18\02\30\01\30\03\00\00\10\03\08\02\38\00\18\01\38")
    (func $hilby (export "hilby") (param $x f64) (param $y f64) (result f64)
        (local $result i64)
        (local $state i64)
        (local $top i64)
        (local $xh i64)
        (local $yh i64)
        (local $xlz i64)
        (local $ylz i64)
        (local.set $xh (i64.and
            (i64.const 0x7ffffff)
            (i64.shr_u
                (i64.reinterpret_f64
                    (f64.add
                        (f64.mul
                            (local.get $x)
                            (f64.const 0.9999999999999998))
                        (f64.const 1)))
                (i64.const 26))))
        (local.set $xh (i64.shl (local.get $xh) (i64.const 1)))
        (local.set $yh (i64.and
            (i64.const 0x7ffffff)
            (i64.shr_u
                (i64.reinterpret_f64
                    (f64.add
                        (f64.mul
                            (local.get $y)
                            (f64.const 0.9999999999999998))
                        (f64.const 1)))
                (i64.const 26))))
        (local.set $xlz (i64.clz (local.get $xh)))
        (local.set $ylz (i64.clz (local.get $yh)))
        (local.set $top
            (i64.sub
                (i64.const 61)
                (select
                    (local.get $xlz)
                    (local.get $ylz)
                    (i64.le_s
                        (local.get $xlz)
                        (local.get $ylz)))))
        (local.set $result (i64.const 0))
        (local.set $state (i64.const 0))
        (loop $shift
            (local.set $top (i64.sub (local.get $top) (i64.const 1)))
            (local.set $state
                (i64.load
                    (i32.wrap_i64
                        (i64.or
                            (local.get $state)
                            (i64.or
                                (i64.and
                                    (i64.const 4)
                                        (i64.shr_u
                                            (local.get $xh)
                                            (local.get $top)))
                                (i64.and
                                    (i64.const 2
                                    (i64.shr_u
                                        (local.get $yh)
                                        (local.get $top)))))))))
            (local.set $result
                (i64.or
                    (i64.shl
                        (local.get $result)
                        (i64.const 2))
                    (i64.and
                        (i64.const 255)
                        (local.get $state))))
            (local.set $state
                (i64.and
                    (i64.const 255)
                    (i64.shr_u
                        (local.get $state)
                        (i64.const 8))))
            (br_if $shift (i64.ge_s (local.get $top) (i64.const 0))))
        (return
            (f64.mul 
                (f64.const 1.0000000000000004)
                (f64.sub
                    (f64.reinterpret_i64
                        (i64.or
                            (i64.const 0x3ff0000000000000)
                            (local.get $result)))
                (f64.const 1)))))



;; function sep2f26(n){
;;     let a,b,c,d,e,f;
;;     a = n & 0x0040014n; a = a * a;
;;     b = n & 0x0802080n; b = b * b;
;;     c = n & 0x0500441n; c = c * c;
;;     d = n & 0x220020an; a = a | (d * d);
;;     e = n & 0x00a8820n; b = b | (e * e);
;;     f = n & 0x1015100n; c = c | (f * f);
;;     return (a | b | c) & 0x5555555555555555n;
;; }


    
    (func $get26fracBits (param f64) (result i64)
        (i64.and
            (i64.shr_u
                (i64.reinterpret_f64
                    (f64.add
                        (f64.const 1)
                        (f64.mul
                            (local.get 0)
                            (f64.const 0.9999999999999998))))
                (i64.const 26))
            (i64.const 0x3ffffff)))
    (func $from52fracbitsToFloat (param i64) (result f64)
        (f64.mul
            (f64.const 1.0000000000000004)
            (f64.sub
                (f64.reinterpret_i64
                    (i64.or
                        (i64.const 0x3ff0000000000000)
                        (local.get 0)))
            (f64.const 1))))
    (func $hilbys (export "hilbys") (param $x f64) (param $y f64) (result f64)
        (local $r0 i64)
        (local $r1 i64)
        (local $r2 i64)
        (local $r3 i64)
        (local $r4 i64)
        (local $r5 i64)
        (local $xh i64)
        (local $yh i64)
        (local $result i64)
        (local $state i64)
        (local $top i64)
        (local $v i64)
        (local.set $result (i64.const 0))
        (local.set $state (i64.const 0))

        (local.set $xh (call $get26fracBits (local.get $x)))
        (local.set $yh (call $get26fracBits (local.get $y)))


        (local.set $v
            (call $morty
                (local.get $yh)
                (local.get $xh)))



        (local.set $top (i64.const 50))
        (loop $shift
            (local.set $r0
                (i64.or
                    (local.get $state)
                    (i64.and
                        (i64.const 6)
                        (i64.shr_u
                            (local.get $v)
                            (local.get $top)))))
            (local.set $top (i64.sub (local.get $top) (i64.const 2)))
            (local.set $result
                (i64.or
                    (i64.shl
                        (local.get $result)
                        (i64.const 2))
                    (i64.and
                        (i64.const 255)
                        (i64.load (i32.wrap_i64 (local.get $r0))))))
            (local.set $r0 (i64.add (local.get $r0) (i64.const 1)))
            (local.set $state
                (i64.and
                    (i64.const 255)
                    (i64.load (i32.wrap_i64 (local.get $r0)))))
        (br_if $shift (i64.ge_s (local.get $top) (i64.const 0))))
    (call $from52fracbitsToFloat (local.get $result)))




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









    (func $hilbySIMD (export "simd") (param $x f64) (param $y f64) (result f64)
        (local $result i64)
        (local $state i64)
        (local $top i32)
        (local $xlz i64)
        (local $ylz i64)
        (local $coords v128)
        (local $dup v128)
        ;;(local.set $coords )
        v128.const f64x2 0 0

        local.get $x
        f64x2.replace_lane 0

        local.get $y
        f64x2.replace_lane 1

        v128.const f64x2 0.9999999999999998 0.9999999999999998
        f64x2.mul

        v128.const f64x2 1 1
        f64x2.add

        i32.const 26
        i64x2.shr_u

        v128.const i64x2 0x7ffffff 0x7ffffff
        v128.and

        local.set $coords


        local.get $coords
        local.get $coords
        i64x2.extract_lane 0
        i64.const 1
        i64.shl
        i64x2.replace_lane 0
        local.set $coords

        local.get $coords
        i64x2.extract_lane 0
        i64.clz
        local.set $xlz

        local.get $coords
        i64x2.extract_lane 1
        i64.clz
        local.set $ylz
        (local.set $top
            (i32.wrap_i64
            (i64.sub
                (i64.const 61)
                (select
                    (local.get $xlz)
                    (local.get $ylz)
                    (i64.le_s
                        (local.get $xlz)
                        (local.get $ylz))))))
        (local.set $result (i64.const 0))
        (local.set $state (i64.const 0))
        (loop $shift
            (local.set $top (i32.sub (local.get $top) (i32.const 1)))
            local.get $coords
            local.get $top
            i64x2.shr_u
            v128.const i64x2 4 2
            v128.and
            local.set $dup
            local.get $dup
            i64x2.extract_lane 0
            local.get $dup
            i64x2.extract_lane 1
            i64.or
            local.get $state
            i64.or
            i32.wrap_i64
            i64.load
            local.set $state

            (local.set $result
                (i64.or
                    (i64.shl
                        (local.get $result)
                        (i64.const 2))
                    (i64.and
                        (i64.const 255)
                        (local.get $state))))
            (local.set $state
                (i64.and
                    (i64.const 255)
                    (i64.shr_u
                        (local.get $state)
                        (i64.const 8))))
            (br_if $shift (i32.ge_s (local.get $top) (i32.const 0))))
        (return
            (f64.mul 
                (f64.const 1.0000000000000004)
                (f64.sub
                    (f64.reinterpret_i64
                        (i64.or
                            (i64.const 0x3ff0000000000000)
                            (local.get $result)))
                (f64.const 1)))))






    (func $sim  (result i64)
        (local $s v128)
        v128.const i64x2 0 0
        local.set $s
        local.get $s
        i64.const 6
        i64x2.replace_lane 0
        i64x2.extract_lane 0)

    (func $sep (export "sep") (param i64) (result i64)
        (local $r0 i64)
        (local $r1 i64)
        (local $r2 i64)
        (local $r3 i64)
        (local $r4 i64)
        (local $r5 i64)
        (local.set $r0 (i64.and (local.get 0) (i64.const 0x0040014)))
        (local.set $r0 (i64.mul (local.get $r0) (local.get $r0)))
        (local.set $r1 (i64.and (local.get 0) (i64.const 0x0802080)))
        (local.set $r1 (i64.mul (local.get $r1) (local.get $r1)))
        (local.set $r2 (i64.and (local.get 0) (i64.const 0x0500441)))
        (local.set $r2 (i64.mul (local.get $r2) (local.get $r2)))
        (local.set $r3 (i64.and (local.get 0) (i64.const 0x220020a)))
        (local.set $r0 (i64.or (local.get $r0) (i64.mul (local.get $r3) (local.get $r3))))
        (local.set $r4 (i64.and (local.get 0) (i64.const 0x00a8820)))
        (local.set $r1 (i64.or (local.get $r1) (i64.mul (local.get $r4) (local.get $r4))))
        (local.set $r5 (i64.and (local.get 0) (i64.const 0x1015100)))
        (local.set $r2 (i64.or (local.get $r2) (i64.mul (local.get $r5) (local.get $r5))))
        (i64.and
            (i64.const 0x55555555555555)
            (i64.or
                (local.get $r2)
                (i64.or
                    (local.get $r0)
                    (local.get $r1)))))
    (func $morty (export "morty") (param i64) (param i64) (result i64)
        (i64.or
            (i64.shl
                (call $sep (local.get 0))
                (i64.const 2))
            (i64.shl
                (call $sep (local.get 1))
                (i64.const 1))))

)
