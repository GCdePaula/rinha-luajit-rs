-- Prelude
local __to_bit = require "bit".tobit

local __buffer = require "string.buffer".new(1024)
local __buffer_put = __buffer.put
local __buffer_tostring = __buffer.tostring

getmetatable('').__add = function(lhs, rhs) return tostring(lhs) .. tostring(rhs) end

local __print = function(x)
  __buffer_put(__buffer, x)
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
  local var_fib
  var_fib =
      function(var_n, __sentinel)
        __assert(var_n and not __sentinel, 'wrong argument count')
        do
          local __temp_0
          if var_n < 2 then
            do return var_n end
          else
            do return __to_bit(var_fib(__to_bit(var_n - 1)) + var_fib(__to_bit(var_n - 2))) end
          end
          return __temp_0
        end
      end
  __ret =
      __print(var_fib(40))
end
-- end code

return __buffer_tostring(__buffer)
