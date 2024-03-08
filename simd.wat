(module
  (func $main (export "main") (result i32)
    v128.const i32x4 3 2 3 4
    i32.const 2
    i32x4.replace_lane 0 
    i32x4.extract_lane 0
  )
)
