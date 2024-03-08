(module
    (memory 1)



    (data (i32.const 0) ;; lookup table for hilbert curve
    "\u0\u20\u1\u0\u3\u30\u2\u0\u3\u38\u0\u28\u2\u8\u1\u8\u2\u10\u3\u20\u1\u10\u0\u30\u1\u18\u2\u18\u0\u38\u3\u28\u0\u0\u3\u10\u1\u20\u2\u20\u1\u28\u0\u8\u2\u28\u3\u18\u2\u30\u1\u30\u3\u0\u0\u10\u3\u8\u2\u38\u0\u18\u1\u38"

    )

    (func (export "hilbertFull") 
        (param $x i64) (param $y i64) (param $state i64) (param $top i64) (param $bot i64)
        (local $yh i64) (local $xh i64) (local $result i64) (local $index i64) (local $offset i64)
        (local.set $result (i32.const 0))

        (loop $shift ;; do
            (local.set $top (i64.sub (local.get $top) (i64.const 2) ) ) ;; top = top - 2;
            (local.set $result (i64.shl (local.get $result) (i64.const 2) ) ) ;; result = result << 2
            (local.set $yh (i64.shr_u (local.get $y) (local.get $top) ) ) ;; yh = y >> top;
            (local.set $top (i64.sub (local.get $top) (i64.const 1) ) ) ;; top = top - 1;
            (local.set $yh (i64.and (local.get $yh) (i64.const 2) ) ) ;; yh = yh & 2;
            (local.set $xh (i64.and (local.get $x) (local.get $top) ) ) ;; xh = x >> top;
            (local.set $index (i64.or (local.get $state) (local.get $yh) ) ) ;; index = state | yh;
            (local.set $top (i64.add (local.get $top) (i64.const 2) ) ) ;; top = top + 2;
            (local.set $xh (i64.and (local.get $xh) (i64.const 8) ) ) ;; xh = xh & 8;
            (local.set $index (i64.or (local.get $index) (local.get $xh) ) ) ;; index = index | xh;
            (local.set $offset (i64.extend_i32_u (i32.load (i64.mul (i64.const 4) (local.get $index))))) ;; offset = table[index]; //fix
            (local.set $index (i64.or (local.get $index) (i64.const 1) ) ) ;; index = index | 1;
            (local.set $result (i64.or (local.get $result) (local.get $offset) ) ) ;; result = result | offset;
            (local.set $state (i64.extend_i32_u (i32.load (i64.mul (i64.const 4) (local.get $index))))) ;; state = table[index]; //fix
            (br_if (i64.ge_u (local.get $top) (local.get $bot) ) )  ;;while top >= bot
        )
        (return (local.get $result))
    )
)
