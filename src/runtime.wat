(module
   (import "env" "Double_val"
      (func $Double_val (param (ref eq)) (result f64)))
   (import "env" "Int32_val"
      (func $Int32_val (param (ref eq)) (result i32)))
   (import "env" "caml_copy_int32"
        (func $caml_copy_int32 (param i32) (result (ref eq))))
   (import "env" "Nativeint_val"
      (func $Nativeint_val (param (ref eq)) (result i32)))
   (import "env" "caml_copy_nativeint"
        (func $caml_copy_nativeint (param i32) (result (ref eq))))
   (import "env" "Int64_val"
      (func $Int64_val (param (ref eq)) (result i64)))
   (import "env" "caml_copy_int64"
        (func $caml_copy_int64 (param i64) (result (ref eq))))

   (type $float (struct (field f64)))

   (func $box_float
      (param $x f64) (result (ref eq))
      (struct.new $float (local.get $x)))

   (func $unbox_float
      (param $x (ref eq)) (result f64)
      (struct.get $float 0 (ref.cast (ref $float) (local.get $x))))

   (func (export "caml_csel_value")
      (param $cond (ref eq)) (param $true (ref eq)) (param $false (ref eq))
      (result (ref eq))
      (select (result (ref eq)) (local.get $true) (local.get $false)
         (i31.get_s (ref.cast (ref i31) (local.get $cond)))))

   (func (export "caml_simd_float64_min_bytecode")
      (param $x (ref eq)) (param $y (ref eq)) (result (ref eq))
      (select (result (ref eq)) (local.get $x) (local.get $y)
         (f64.lt (call $Double_val (local.get $x))
                 (call $Double_val (local.get $y)))))

   (func (export "caml_simd_float64_max_bytecode")
      (param $x (ref eq)) (param $y (ref eq)) (result (ref eq))
      (select (result (ref eq)) (local.get $x) (local.get $y)
         (f64.gt (call $Double_val (local.get $x))
                 (call $Double_val (local.get $y)))))

   (func (export "caml_simd_cast_float64_int64_bytecode")
      (param $x (ref eq)) (result (ref eq))
      (call $caml_copy_int64
         (i64.trunc_sat_f64_s (f64.nearest (call $unbox_float (local.get $x))))))

    (func (export "caml_simd_float64_round_current_bytecode")
        (param (ref eq)) (result (ref eq))
        (local $x f64)
        (local.set $x (call $unbox_float (local.get 0)))
        (call $box_float (f64.nearest (local.get $x))))

    (func (export "caml_simd_float64_round_neg_inf_bytecode")
        (param (ref eq)) (result (ref eq))
        (local $x f64)
        (local.set $x (call $unbox_float (local.get 0)))
        (call $box_float (f64.floor (local.get $x))))

    (func (export "caml_simd_float64_round_pos_inf_bytecode")
        (param (ref eq)) (result (ref eq))
        (local $x f64)
        (local.set $x (call $unbox_float (local.get 0)))
        (call $box_float (f64.ceil (local.get $x))))

    (func (export "caml_simd_float64_round_towards_zero_bytecode")
        (param (ref eq)) (result (ref eq))
        (local $x f64)
        (local.set $x (call $unbox_float (local.get 0)))
        (call $box_float (f64.trunc (local.get $x))))

   (func (export "caml_int_popcnt") (param $x (ref eq)) (result (ref eq))
      (ref.i31 (i32.popcnt (i31.get_u (ref.cast (ref i31) (local.get $x))))))

   (func (export "caml_int32_popcnt") (param $x (ref eq)) (result (ref eq))
      (call $caml_copy_int32 (i32.popcnt (call $Int32_val (local.get $x)))))

   (func (export "caml_nativeint_popcnt") (param $x (ref eq)) (result (ref eq))
      (call $caml_copy_nativeint
         (i32.popcnt (call $Nativeint_val (local.get $x)))))

   (func (export "caml_int64_popcnt") (param $x (ref eq)) (result (ref eq))
      (call $caml_copy_int64 (i64.popcnt (call $Int64_val (local.get $x)))))

   (func (export "caml_int_clz")
      (param (ref eq)) (result (ref eq))
      (ref.i31
         (i32.clz
            (i32.or
               (i32.shl
                  (i31.get_s (ref.cast (ref i31) (local.get 0)))
                  (i32.const 1))
               (i32.const 1)))))

   (func (export "caml_int32_clz") (param $x (ref eq)) (result (ref eq))
      (call $caml_copy_int32 (i32.clz (call $Int32_val (local.get $x)))))

   (func (export "caml_nativeint_clz") (param $x (ref eq)) (result (ref eq))
      (call $caml_copy_nativeint (i32.clz (call $Nativeint_val (local.get $x)))))

   (func (export "caml_int64_clz") (param $x (ref eq)) (result (ref eq))
      (call $caml_copy_int64 (i64.clz (call $Int64_val (local.get $x)))))

   (func (export "caml_int_ctz") (param $x (ref eq)) (result (ref eq))
      (ref.i31 (i32.ctz (i31.get_s (ref.cast (ref i31) (local.get $x))))))

   (func (export "caml_int32_ctz") (param $x (ref eq)) (result (ref eq))
      (call $caml_copy_int32 (i32.ctz (call $Int32_val (local.get $x)))))

   (func (export "caml_nativeint_ctz") (param $x (ref eq)) (result (ref eq))
      (call $caml_copy_nativeint (i32.ctz (call $Nativeint_val (local.get $x)))))

   (func (export "caml_int64_ctz") (param $x (ref eq)) (result (ref eq))
      (call $caml_copy_int64 (i64.ctz (call $Int64_val (local.get $x)))))
)
