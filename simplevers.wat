

(module
  (import "console" "log" (func $log6 (param i64) (param i64) (param i64) (param i64) (param i64) (param i64)))
  (import "console" "log" (func $log1 (param i64)))

    (memory 1)
    (data (i32.const 0) ;; lookup table for hilbert curve
        "\00\00\00\00\20\00\00\00\01\00\00\00\00\00\00\00\03\00\00\00\30\00\00\00\02\00\00\00\00\00\00\00\03\00\00\00\38\00\00\00\00\00\00\00\28\00\00\00\02\00\00\00\08\00\00\00\01\00\00\00\08\00\00\00\02\00\00\00\10\00\00\00\03\00\00\00\20\00\00\00\01\00\00\00\10\00\00\00\00\00\00\00\30\00\00\00\01\00\00\00\18\00\00\00\02\00\00\00\18\00\00\00\00\00\00\00\38\00\00\00\03\00\00\00\28\00\00\00\00\00\00\00\00\00\00\00\03\00\00\00\10\00\00\00\01\00\00\00\20\00\00\00\02\00\00\00\20\00\00\00\01\00\00\00\28\00\00\00\00\00\00\00\08\00\00\00\02\00\00\00\28\00\00\00\03\00\00\00\18\00\00\00\02\00\00\00\30\00\00\00\01\00\00\00\30\00\00\00\03\00\00\00\00\00\00\00\00\00\00\00\10\00\00\00\03\00\00\00\08\00\00\00\02\00\00\00\38\00\00\00\00\00\00\00\18\00\00\00\01\00\00\00\38\00\00\00")


    (func $hilbertFull
        (param $x i64) (param $y i64) (param $state i32) (param $top i32) (param $bot i32) (result i64)
        (local $yh i32) (local $xh i32) (local $result i64) (local $index i32)
        (local.set $result (i64.const 0))

        (loop $shift ;; do
            (local.set $top (i32.sub (local.get $top) (i32.const 2))) ;; top = top - 2;
            (local.set $result (i64.shl (local.get $result) (i64.const 2))) ;; result = result << 2
            (local.set $yh (i32.wrap_i64 (i64.shr_u (local.get $y) (i64.extend_i32_u (local.get $top))))) ;; yh = y >> top;
            (local.set $top (i32.sub (local.get $top) (i32.const 1))) ;; top = top - 1;
            (local.set $yh (i32.and (local.get $yh) (i32.const 2))) ;; yh = yh & 2;
            (local.set $xh (i32.wrap_i64 (i64.shr_u (local.get $x) (i64.extend_i32_u (local.get $top))))) ;; xh = x >> top;
            (local.set $index (i32.or (local.get $state) (local.get $yh))) ;; index = state | yh;
            (local.set $top (i32.add (local.get $top) (i32.const 2))) ;; top = top + 2;
            (local.set $xh (i32.and (local.get $xh) (i32.const 4))) ;; xh = xh & 4;
            (local.set $index (i32.or (local.get $index) (local.get $xh))) ;; index = index | xh;
            (local.set $result
                (i64.or
                    (local.get $result)
                    (i64.extend_i32_u
                        (i32.load
                            (i32.shl
                                (local.get $index)
                                (i32.const 2)))))) ;; result = result | offset;
            (local.set $index (i32.or (local.get $index) (i32.const 1))) ;; index = index | 1;
            (local.set $state  (i32.load (i32.shl (local.get $index) (i32.const 2)))) ;; state = table[index];
            (br_if $shift (i32.ge_s (local.get $top) (local.get $bot)))  ;;while top >= bot
        )
        (return (local.get $result))
    )


  (func $main
  ;;console.log(hilbertClassicInt64(2342134, 12341234123) );

    (call $log1 
        (call $hilbertFull
            (i64.const 23421)
            (i64.const 12341)
            (i32.const 0)
            (i32.const 4)
            (i32.const 0)
        )
    )
  )
  (start $main)
)




