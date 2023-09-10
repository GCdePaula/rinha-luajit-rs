-- Prelude
local bit = require "bit"
local __to_bit = bit.tobit

local __buffer = require "string.buffer".new(1024)

getmetatable('').__add = function(lhs, rhs) return tostring(lhs) .. tostring(rhs) end

local __print = function(x)
  __buffer:put(x)
  __buffer:put "\n"
  return x
end

local __assert = assert

local __floor = math.floor

setfenv(1, {})

local __ret

-- Prelude end

-- code start
do
  local var_fib_cps
  var_fib_cps =
      function(var_n, var_cont, __sentinel)
        __assert(var_cont and not __sentinel, 'wrong argument count')
        do
          local __temp_0
          if var_n == 0 then
            do return var_cont(var_n) end
          else
            do
              return var_fib_cps(__to_bit(var_n - 1), function(var_x, __sentinel)
                __assert(var_x and not __sentinel, 'wrong argument count')
                do
                  local __temp_0
                  do
                    return var_fib_cps(__to_bit(var_x - 2), function(var_y, __sentinel)
                      __assert(var_y and not __sentinel, 'wrong argument count')
                      do
                        local __temp_0
                        do return var_cont(__to_bit(var_x + var_y)) end
                        return __temp_0
                      end
                    end
                    )
                  end
                  return __temp_0
                end
              end
              )
            end
          end
          return __temp_0
        end
      end
  __ret =
      __print(var_fib_cps(1, function(var_x, __sentinel)
        __assert(var_x and not __sentinel, 'wrong argument count')
        do
          local __temp_0
          do return var_x end
          return __temp_0
        end
      end
      ))
end
-- end code

return __buffer:tostring()
