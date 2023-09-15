use libc::{c_char, c_int, c_void, size_t};
use std::ffi::{CStr, CString};

pub const LUA_OK: c_int = 0;
pub const LUA_MULTIRET: c_int = -1;

#[allow(non_camel_case_types)]
pub type lua_State = c_void;

#[link(name = "luajit", kind = "static")]
extern "C" {
    fn lua_pcall(L: *mut lua_State, nargs: c_int, nresults: c_int, errfunc: c_int) -> c_int;
    fn luaL_loadstring(L: *mut lua_State, s: *const c_char) -> c_int;
    fn luaL_newstate() -> *mut lua_State;
    fn luaL_openlibs(L: *mut lua_State);
    fn lua_tolstring(L: *mut lua_State, idx: c_int, len: *mut size_t) -> *const c_char;
}

#[inline(always)]
unsafe fn lua_open() -> *mut lua_State {
    luaL_newstate()
}

#[inline(always)]
#[allow(non_snake_case)]
unsafe fn luaL_dostring(L: *mut lua_State, s: *const c_char) -> c_int {
    let status = luaL_loadstring(L, s);
    if status == 0 {
        lua_pcall(L, 0, LUA_MULTIRET, 0)
    } else {
        status
    }
}

#[inline(always)]
pub unsafe fn lua_tostring(state: *mut lua_State, i: c_int) -> *const c_char {
    lua_tolstring(state, i, std::ptr::null_mut())
}

pub fn run(code: &str) -> Result<String, String> {
    let code = CString::new(code).unwrap();

    let state = unsafe { lua_open() };
    let ret = unsafe {
        luaL_openlibs(state);
        luaL_dostring(state, code.as_ptr())
    };

    if ret != LUA_OK {
        let err = unsafe { CStr::from_ptr(lua_tostring(state, -1)) };
        Err(err
            .to_str()
            .map_err(|e| format!("{:?}", e))?
            .to_owned()
            .into())
    } else {
        let ret = unsafe { CStr::from_ptr(lua_tostring(state, -1)) };
        Ok(ret
            .to_str()
            .map_err(|e| format!("{:?}", e))?
            .to_owned()
            .into())
    }
}
