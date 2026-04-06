-- Prelude
-- local __to_bit = require "bit".tobit

local __buffer = require "string.buffer".new(1024)
local __buffer_put = __buffer.put
local __buffer_tostring = __buffer.tostring

local print = print

local __new_str

local __str_mt = {
  __add = function(lhs, rhs) return __new_str(tostring(lhs) .. tostring(rhs)) end,
  __eq = function(lhs, rhs) return lhs[1] == rhs[1] end,
  __tostring = function(x) return x[1] end,
}

__new_str = function(s)
  local t = { s }
  setmetatable(t, __str_mt)
  return t
end

local function __print0(x)
  if type(x) == "function" then
    __buffer_put(__buffer, "<#closure>")
  elseif getmetatable(x) == __str_mt then
    __buffer_put(__buffer, x[1])
  elseif type(x) == "table" then
    __buffer_put(__buffer, "(")
    __print0(x[1])
    __buffer_put(__buffer, ", ")
    __print0(x[2])
    __buffer_put(__buffer, ")")
  else
    __buffer_put(__buffer, tostring(x))
  end
end

local function __print(x)
  __print0(x)
  __buffer_put(__buffer, "\n")
  return x
end

local __assert = assert

local __floor = math.floor

setfenv(1, {})

local __ret

-- Prelude end

-- code start
do
  local __temp_0
  local __temp_1
  local __temp_2
  local __temp_3
  local __temp_4
  local __temp_5
  local __temp_6
  local __temp_7
  local __temp_8
  local __temp_9
  local __temp_10
  local __temp_11
  local __temp_12
  local __temp_13
  local __temp_14
  local __temp_15
  local __temp_16
  local __temp_17
  local __temp_18
  local __temp_19
  local __temp_20
  local __temp_21
  local __temp_22
  local __temp_23
  local __temp_24
  local __temp_25
  local __temp_26
  local __temp_27
  local __temp_28
  local __temp_29
  local __temp_30
  local __temp_31
  local __temp_32
  local __temp_33
  local __temp_34
  local __temp_35
  local __temp_36
  local __temp_37
  local __temp_38
  local __temp_39
  local __temp_40
  local __temp_41
  local __temp_42
  local __temp_43
  local __temp_44
  local __temp_45
  local __temp_46
  local __temp_47
  local __temp_48
  local __temp_49
  local __temp_50
  local __temp_51
  local __temp_52
  local __temp_53
  local __temp_54
  local __temp_55
  local __temp_56
  local __temp_57
  local __temp_58
  local __temp_59
  local __temp_60
  local __temp_61
  local __temp_62
  local __temp_63
  local __temp_64
  local __temp_65
  local __temp_66
  local __temp_67
  local __temp_68
  local __temp_69
  local __temp_70
  local __temp_71
  local __temp_72
  local __temp_73
  local __temp_74
  local __temp_75
  local __temp_76
  local __temp_77
  local __temp_78
  local __temp_79
  local __temp_80
  local __temp_81
  local __temp_82
  local __temp_83
  local __temp_84
  local __temp_85
  local __temp_86
  local __temp_87
  local __temp_88
  local __temp_89
  local __temp_90
  local __temp_91
  local __temp_92
  local __temp_93
  local __temp_94
  local __temp_95
  local __temp_96
  local __temp_97
  local __temp_98
  local __temp_99
  local __temp_100
  local __temp_101
  local __temp_102
  local __temp_103
  local __temp_104
  local __temp_105
  local __temp_106
  local __temp_107
  local __temp_108
  local __temp_109
  local __temp_110
  local __temp_111
  local __temp_112
  local __temp_113
  local __temp_114
  local __temp_115
  local __temp_116
  local __temp_117
  local __temp_118
  local __temp_119
  local var__
  var__ =
      __print(__new_str("@!compile::"))
  local var_fib_tail_rec
  var_fib_tail_rec =
      function(var_i, var_n, var_a, var_b, __sentinel)
        __assert(var_b ~= nil and __sentinel == nil, 'wrong argument count')
        if var_n == 0 then
          var__ =
              __print(__new_str("@!hehe") + var_i + __new_str("::"))
          do return var_a end
        else
          do return var_fib_tail_rec(var_i + 1, var_n - 1, var_b, var_a + var_b) end
        end
        return __temp_0
      end
  local var_fib
  var_fib =
      function(var_n, __sentinel)
        __assert(var_n ~= nil and __sentinel == nil, 'wrong argument count')
        do return var_fib_tail_rec(0, var_n, 0, 1) end
        return __temp_0
      end
  local var_cons
  var_cons =
      function(var_value, var_next, __sentinel)
        __assert(var_next ~= nil and __sentinel == nil, 'wrong argument count')
        do return ({ ({ 1, var_value }), var_next }) end
        return __temp_0
      end
  local var_nil
  var_nil =
      ({ ({ 0, 0 }), 0 })
  local var_map
  var_map =
      function(var_list, var_f, __sentinel)
        __assert(var_f ~= nil and __sentinel == nil, 'wrong argument count')
        local var_tag
        var_tag =
            var_list[1][1]
        local var_val
        var_val =
            var_list[1][2]
        local var_rest
        var_rest =
            var_list[2]
        if var_tag == 1 then
          local var_new_val
          var_new_val =
              var_f(var_val)
          local var_new_rest
          var_new_rest =
              var_map(var_rest, var_f)
          do return var_cons(var_new_val, var_new_rest) end
        else
          do return var_nil end
        end
        return __temp_0
      end
  local var_idx
  var_idx =
      function(var_list, var_n, __sentinel)
        __assert(var_n ~= nil and __sentinel == nil, 'wrong argument count')
        local var_tag
        var_tag =
            var_list[1][1]
        local var_val
        var_val =
            var_list[1][2]
        local var_rest
        var_rest =
            var_list[2]
        if var_tag == 1 then
          if var_n == 0 then
            do return var_val end
          else
            do return var_idx(var_rest, var_n - 1) end
          end
        else
          do return 0 end
        end
        return __temp_0
      end
  local var_fold
  var_fold =
      function(var_list, var_f, var_init, __sentinel)
        __assert(var_init ~= nil and __sentinel == nil, 'wrong argument count')
        local var_tag
        var_tag =
            var_list[1][1]
        local var_val
        var_val =
            var_list[1][2]
        local var_rest
        var_rest =
            var_list[2]
        if var_tag == 1 then
          local var_new_init
          var_new_init =
              var_f(var_init, var_val)
          local var_new_rest
          var_new_rest =
              var_fold(var_rest, var_f, var_new_init)
          do return var_new_rest end
        else
          do return var_init end
        end
        return __temp_0
      end
  local var_filter
  var_filter =
      function(var_list, var_f, __sentinel)
        __assert(var_f ~= nil and __sentinel == nil, 'wrong argument count')
        local var_tag
        var_tag =
            var_list[1][1]
        local var_val
        var_val =
            var_list[1][2]
        local var_rest
        var_rest =
            var_list[2]
        if var_tag == 1 then
          local var_new_rest
          var_new_rest =
              var_filter(var_rest, var_f)
          if var_f(var_val) then
            do return var_cons(var_val, var_new_rest) end
          else
            do return var_new_rest end
          end
        else
          do return var_nil end
        end
        return __temp_0
      end
  local var_list_to_string
  var_list_to_string =
      function(var_list, __sentinel)
        __assert(var_list ~= nil and __sentinel == nil, 'wrong argument count')
        local var_tag
        var_tag =
            var_list[1][1]
        local var_val
        var_val =
            var_list[1][2]
        local var_rest
        var_rest =
            var_list[2]
        if var_tag == 1 then
          local var_rest_str
          var_rest_str =
              var_list_to_string(var_rest)
          local var_str
          var_str =
              var_val + __new_str(" ") + var_rest_str
          do return var_str end
        else
          do return __new_str("") end
        end
        return __temp_0
      end
  local var_len
  var_len =
      function(var_list, __sentinel)
        __assert(var_list ~= nil and __sentinel == nil, 'wrong argument count')
        do
          return var_fold(var_list, function(var_acc, var_next, __sentinel)
            __assert(var_next ~= nil and __sentinel == nil, 'wrong argument count')
            do return var_acc + 1 end
            return __temp_0
          end
          , 0)
        end
        return __temp_0
      end
  local var_append
  var_append =
      function(var_list1, var_list2, __sentinel)
        __assert(var_list2 ~= nil and __sentinel == nil, 'wrong argument count')
        local var_tag1
        var_tag1 =
            var_list1[1][1]
        local var_val1
        var_val1 =
            var_list1[1][2]
        local var_rest1
        var_rest1 =
            var_list1[2]
        if var_tag1 == 1 then
          local var_new_rest1
          var_new_rest1 =
              var_append(var_rest1, var_list2)
          do return var_cons(var_val1, var_new_rest1) end
        else
          do return var_list2 end
        end
        return __temp_0
      end
  local var_quicksort
  var_quicksort =
      function(var_list, __sentinel)
        __assert(var_list ~= nil and __sentinel == nil, 'wrong argument count')
        local var_tag
        var_tag =
            var_list[1][1]
        local var_val
        var_val =
            var_list[1][2]
        local var_rest
        var_rest =
            var_list[2]
        if var_tag == 1 then
          local var_less
          var_less =
              var_filter(var_rest, function(var_x, __sentinel)
                __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
                do return var_x < var_val end
                return __temp_0
              end
              )
          local var_more
          var_more =
              var_filter(var_rest, function(var_x, __sentinel)
                __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
                do return var_x >= var_val end
                return __temp_0
              end
              )
          local var_sorted_less
          var_sorted_less =
              var_quicksort(var_less)
          local var_sorted_more
          var_sorted_more =
              var_quicksort(var_more)
          local var_sorted_list
          var_sorted_list =
              var_append(var_sorted_less, var_cons(var_val, var_sorted_more))
          do return var_sorted_list end
        else
          do return var_nil end
        end
        return __temp_0
      end
  local var_replicate
  var_replicate =
      function(var_n, var_x, __sentinel)
        __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
        if var_n == 0 then
          do return var_nil end
        else
          do return var_cons(var_x, var_replicate(var_n - 1, var_x)) end
        end
        return __temp_0
      end
  local var_bottom_up_tree
  var_bottom_up_tree =
      function(var_item, var_depth, __sentinel)
        __assert(var_depth ~= nil and __sentinel == nil, 'wrong argument count')
        if var_depth == 0 then
          do return var_cons(var_item, var_nil) end
        else
          local var_new_depth
          var_new_depth =
              var_depth - 1
          local var_new_item
          var_new_item =
              var_item * 2
          local var_lhs
          var_lhs =
              var_bottom_up_tree(var_new_item - 1, var_new_depth)
          local var_rhs
          var_rhs =
              var_bottom_up_tree(var_new_item, var_new_depth)
          do return var_cons(var_item, var_cons(var_lhs, var_cons(var_rhs, var_nil))) end
        end
        return __temp_0
      end
  local var_item_check
  var_item_check =
      function(var_tree, __sentinel)
        __assert(var_tree ~= nil and __sentinel == nil, 'wrong argument count')
        local var_item
        var_item =
            var_idx(var_tree, 0)
        local var_lhs
        var_lhs =
            var_idx(var_tree, 1)
        if var_len(var_tree) < 3 then
          do return 1 end
        else
          local var_rhs
          var_rhs =
              var_idx(var_tree, 2)
          do return 1 + var_item_check(var_lhs) + var_item_check(var_rhs) end
        end
        return __temp_0
      end
  local var_pow
  var_pow =
      function(var_x, var_y, __sentinel)
        __assert(var_y ~= nil and __sentinel == nil, 'wrong argument count')
        if var_y == 0 then
          do return 1 end
        else
          do return var_x * var_pow(var_x, var_y - 1) end
        end
        return __temp_0
      end
  local var_test_dead_code
  var_test_dead_code =
      function(__sentinel)
        var__ =
            __print(__new_str("dead code"))
        var__ =
            30 + 493985 + 4
        var__ =
            429457395 * 4
        var__ =
            32425 * var_pow(20, 10)
        var__ =
            var_replicate(100, var_pow(10, 2))
        var__ =
            var_replicate(30, var_pow(14, 2))
        var__ =
            var_replicate(45, var_pow(35, 2))
        var__ =
            var_replicate(52, var_pow(10, 2))
        var__ =
            var_replicate(69, var_pow(1, 2))
        var__ =
            var_replicate(69, var_pow(10, 2))
        var__ =
            var_replicate(39, var_pow(3, 2))
        var__ =
            var_replicate(69, var_pow(10, 2))
        var__ =
            var_replicate(59, var_pow(10, 2))
        var__ =
            var_replicate(69, var_pow(8, 2))
        var__ =
            var_replicate(61, var_pow(10, 2))
        var__ =
            var_replicate(98, var_pow(10, 2))
        var__ =
            var_replicate(60, var_pow(9, 2))
        var__ =
            var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))
        var__ =
            var_append(var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2))),
              var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2))))
        local var_x
        var_x =
            var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))
        var__ =
            var_map(var_x, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_x * 2 end
              return __temp_0
            end
            )
        var__ =
            __print(__new_str("some_list => ") + var_list_to_string(var_replicate(10, var_pow(3, 3))))
        var__ =
            var_map(var_x, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_x * 2 end
              return __temp_0
            end
            )
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        local var_y
        var_y =
            var_replicate(30, var_pow(14, 2))
        local var_g
        var_g =
            var_replicate(45, var_pow(35, 2))
        var__ =
            var_replicate(52, var_pow(10, 2))
        local var_sim
        var_sim =
            var_replicate(100, var_pow(10, 2))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(var_sim, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            __print(__new_str("some_list => ") + var_list_to_string(var_replicate(10, var_pow(3, 3))))
        var__ =
            var_map(var_x, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_x * 2 end
              return __temp_0
            end
            )
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            __print(__new_str("@!dead_code::"))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(var_sim, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            var_replicate(52, var_pow(10, 2))
        var__ =
            var_replicate(69, var_pow(1, 2))
        var__ =
            var_replicate(69, var_pow(10, 2))
        var__ =
            var_replicate(39, var_pow(3, 2))
        var__ =
            var_replicate(69, var_pow(10, 2))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(var_sim, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            __print(__new_str("dead code"))
        var__ =
            30 + 493985 + 4
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(var_g, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            var_replicate(100, var_pow(10, 2))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(var_sim, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            __print(__new_str("some_list => ") + var_list_to_string(var_replicate(10, var_pow(3, 3))))
        var__ =
            var_map(var_x, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_x * 2 end
              return __temp_0
            end
            )
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(var_g, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(var_g, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            var_append(var_sim, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            __print(__new_str("some_list => ") + var_list_to_string(var_replicate(10, var_pow(3, 3))))
        var__ =
            var_map(var_x, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_x * 2 end
              return __temp_0
            end
            )
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_replicate(30, var_pow(14, 2))
        var__ =
            var_replicate(45, var_pow(35, 2))
        var__ =
            var_replicate(52, var_pow(10, 2))
        var__ =
            var_replicate(100, var_pow(10, 2))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(var_g, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            var_append(var_sim, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            __print(__new_str("some_list => ") + var_list_to_string(var_replicate(10, var_pow(3, 3))))
        var__ =
            var_map(var_x, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_x * 2 end
              return __temp_0
            end
            )
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(var_g, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(var_g, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            var_append(var_sim, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            __print(__new_str("some_list => ") + var_list_to_string(var_replicate(10, var_pow(3, 3))))
        var__ =
            var_map(var_x, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_x * 2 end
              return __temp_0
            end
            )
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(var_g, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(var_g, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            var_append(var_sim, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            __print(__new_str("some_list => ") + var_list_to_string(var_replicate(10, var_pow(3, 3))))
        var__ =
            var_map(var_x, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_x * 2 end
              return __temp_0
            end
            )
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            __print(__new_str("@!dead_code::"))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            __print(__new_str("some_list => ") + var_list_to_string(var_replicate(10, var_pow(3, 3))))
        var__ =
            var_map(var_x, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_x * 2 end
              return __temp_0
            end
            )
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(var_g, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(var_g, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            var_append(var_sim, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            __print(__new_str("some_list => ") + var_list_to_string(var_replicate(10, var_pow(3, 3))))
        var__ =
            var_map(var_x, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_x * 2 end
              return __temp_0
            end
            )
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(var_g, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(var_g, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            var_append(var_sim, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            __print(__new_str("some_list => ") + var_list_to_string(var_replicate(10, var_pow(3, 3))))
        var__ =
            var_map(var_x, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_x * 2 end
              return __temp_0
            end
            )
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))),
              var_append(var_x,
                var_append(var_replicate(60, var_pow(10, 2)), var_replicate(60, var_pow(10, 2)))))
        var__ =
            var_append(var_g, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        var__ =
            var_append(var_sim, var_map(var_y, function(var_x, __sentinel)
              __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
              do return var_pow(var_x, 2) end
              return __temp_0
            end
            ))
        do return var_pow(2, var_pow(2, 2)) end
        return __temp_0
      end
  local var_dynamic_typing_test
  var_dynamic_typing_test =
      function(var_x, var_y, var_z, __sentinel)
        __assert(var_z ~= nil and __sentinel == nil, 'wrong argument count')
        var__ =
            __print(__new_str("dynamic_typing_test print 1"))
        if var_x + var_z % 2 == 0 then
          var__ =
              __print(__new_str("dynamic_typing_test print 2"))
          do return __new_str("it's a string") end
        else
          if var_z * var_x > var_y then
            var__ =
                __print(__new_str("dynamic_typing_test print 3"))
            do return 1 end
          else
            var__ =
                __print(__new_str("dynamic_typing_test print 4"))
            do return 2039 end
          end
        end
        return __temp_0
      end
  local var_dynamic_list_test
  var_dynamic_list_test =
      function(__sentinel)
        local var_dyn_list_1
        var_dyn_list_1 =
            var_replicate(100, var_dynamic_typing_test(19, 210, 304))
        local var_dyn_list_2
        var_dyn_list_2 =
            var_fold(var_dyn_list_1, function(var_acc, var_next, __sentinel)
              __assert(var_next ~= nil and __sentinel == nil, 'wrong argument count')
              var__ =
                  __print(__new_str("dynamic_list_test print 1"))
              var__ =
                  var_dynamic_typing_test(423, 230, 4)
              do return var_acc * var_acc end
              return __temp_0
            end
            , 4)
        do return __print(__new_str("@!dynamic_list_test_print_2::")) end
        return __temp_0
      end
  local var_fib1
  var_fib1 =
      var_fib(1)
  local var_fib5
  var_fib5 =
      var_fib(5)
  local var_fib10
  var_fib10 =
      var_fib(10)
  local var_fibx
  var_fibx =
      __print(__new_str("@!fib::") + var_fib(45))
  local var_base_list
  var_base_list = var_cons(1,
    var_cons(2,
      var_cons(3,
        var_cons(4,
          var_cons(5,
            var_cons(6,
              var_cons(7,
                var_cons(8,
                  var_cons(9,
                    var_cons(10,
                      var_cons(11,
                        var_cons(12, var_cons(13, var_cons(14, var_cons(15, var_cons(16, var_nil))))))))))))))))
  local var_append_list
  var_append_list =
      var_append(var_base_list, var_append(var_base_list, var_map(var_base_list, function(var_x, __sentinel)
        __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
        do return var_x * 4 end
        return __temp_0
      end
      )))
  local var_list
  var_list =
      var_append(var_append_list, var_replicate(100, 1))
  local var_map_list
  var_map_list =
      var_map(var_list, function(var_x, __sentinel)
        __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
        do return var_x * 2 end
        return __temp_0
      end
      )
  var__ =
      __print(__new_str("@!to_string::") + var_list_to_string(var_map_list))
  var__ =
      __print(__new_str("@!fold::") + var_fold(var_map_list, function(var_x, var_y, __sentinel)
        __assert(var_y ~= nil and __sentinel == nil, 'wrong argument count')
        do return var_x + var_y end
        return __temp_0
      end
      , 0))
  var__ =
      __print(__new_str("@!filter::") + var_list_to_string(var_filter(var_list, function(var_x, __sentinel)
        __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
        do return var_x > 2 end
        return __temp_0
      end
      )))
  var__ =
      __print(__new_str("@!append::") + var_list_to_string(var_append(var_map_list, var_list)))
  var__ =
      __print(__new_str("@!quicksort::") + var_list_to_string(var_quicksort(var_append(var_map_list, var_list))))
  var__ =
      __print(__new_str("@!idx::") + var_idx(var_list, 0))
  var__ =
      __print(__new_str("@!map_run::"))
  local var_max_depth
  var_max_depth =
      14
  local var_min_depth
  var_min_depth =
      4
  local var_stretch_depth
  var_stretch_depth =
      var_max_depth + 1
  var__ =
      __print(__new_str("stretch_depth  = ") + var_stretch_depth)
  local var_stretch_tree
  var_stretch_tree =
      var_bottom_up_tree(0, var_stretch_depth)
  var__ =
      var_map(var_replicate(var_max_depth, 1), function(var_x, __sentinel)
        __assert(var_x ~= nil and __sentinel == nil, 'wrong argument count')
        local var_iterations
        var_iterations =
            var_pow(2, var_max_depth - var_x + var_min_depth)
        print(var_iterations)
        local var_check
        var_check =
            var_fold(var_replicate(var_iterations, 0), function(var_acc, var_next, __sentinel)
              __assert(var_next ~= nil and __sentinel == nil, 'wrong argument count')
              local var_tree
              var_tree =
                  var_bottom_up_tree(var_x, var_x)
              local var_sum
              var_sum =
                  var_item_check(var_tree)
              do return var_acc + var_sum end
              return __temp_0
            end
            , 0)
        do return __print(__new_str("check(") + var_iterations + __new_str(") = ") + var_check) end
        return __temp_0
      end
      )
  var__ =
      __print(__new_str("@!binary_trees::"))
  var__ =
      var_test_dead_code()
  var__ =
      __print(__new_str("@!dead_code_test::"))
  var__ =
      __print(__new_str("@!dynamic_typing_run1::") + var_dynamic_typing_test(19, 210, 304))
  var__ =
      __print(__new_str("@!dynamic_typing_run2::") + var_dynamic_typing_test(423, 230, 4))
  var__ =
      __print(__new_str("@!dynamic_typing_run3::") + var_dynamic_typing_test(19, 210, 304))
  var__ =
      __print(__new_str("@!dynamic_typing_run4::") + var_dynamic_typing_test(423, 230, 4))
  var__ =
      __print(__new_str("@!dynamic_typing_run5::") + var_dynamic_typing_test(44, 422, 5))
  var__ =
      __print(__new_str("@!dynamic_typing_run6::") + var_dynamic_typing_test(33, 210, 55))
  var__ =
      var_dynamic_list_test()
  var__ =
      __print(__new_str("@!dynamic_list_run::"))
  __ret =
      0
end
-- end code

return print(__buffer_tostring(__buffer))
