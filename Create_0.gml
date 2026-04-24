// 1<<n = 2^n

// 16  2


// Basearray is Little Endian

BASE = 10
function basearray(val_or_array) {
	var _tr = 0
	var _ret = (is_array(val_or_array)?val_or_array:[val_or_array])
	for (var _i = 0; _i < array_length(_ret); _i++) {
		if (_ret[_i] >= BASE) {
			if (_i == array_length(_ret)-1) {array_push(_ret,0)}
			var _ext = floor(_ret[_i]/BASE)
			_ret[_i] -= BASE*_ext
			_ret[_i+1] = _ext
		}
		_tr = (_ret[_i] == 0?_tr-1:0)
	}
	array_delete(_ret,-1,_tr)
	return _ret
}

function basearray_mul(base_array,mul) {
	var _nv = 0
	for (var _i = array_length(base_array)-1; _i > -1; _i--) {
		var _v = base_array[_i]*mul
		base_array[_i] = floor(_v) + _nv
		_nv = BASE*frac(_v)
	}
	return basearray(base_array)
}

function basearray_string(base_array) {
	var _ret = ""
	for (var _i = 0; _i < array_length(base_array); _i++) {
		_ret = string(base_array[_i]) + _ret
	}
	return _ret
}


var _ss = [10203303202]
var _ba = basearray_mul(_ss,2.5)


show_debug_message(basearray_string(_ba))