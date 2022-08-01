"use strict"

// AutoCurrying through FFI (Fn0 - Fn10) + (runFn0 - runFn10)
export const sliceImpl = function(beginIdx, endIdx, str) {
  return endIdx === 0 ? str.slice(beginIdx) : str.slice(beginIdx, endIdx)
}
