// 1<<n = 2^n

// 16  2

// Basearray is an unsigned integer without maximum limit
// Basearray is Little Endian
BASE = 10


show_debug_message(string_format(log2(4294967296),2,40))
show_debug_message(string_format(log2(1023.0000001),2,40))

function basearray(val_or_array) {
	var _trim = 0
	var _ret = (is_array(val_or_array)?val_or_array:[val_or_array])
	for (var _i = 0; _i < array_length(_ret); _i++) {
		if (_ret[_i] >= BASE) {
			if (_i == array_length(_ret)-1) {array_push(_ret,0)}
			var _ext = floor(_ret[_i]/BASE)
			_ret[_i] -= BASE*_ext
			_ret[_i+1] += _ext
		}
		_trim = (_ret[_i] == 0?_trim-1:0)
	}
	array_delete(_ret,-1,_trim)
	return _ret
}

//  (5+1) (1+2+1) (5+8+2) 3 6 
//  6 5 5 3 6

function basearray_multiply_value(base_array,mul) {
	var _r = 0
	for (var _i = array_length(base_array)-1; _i > -1; _i--) {
		var _v = base_array[_i]*mul
		base_array[_i] = floor(_v) + _r
		_r = BASE*frac(_v)
	}
	return basearray(base_array)
}

// 10000 (16)
// 00001 (1)
// 01111 (15)

function basearray_compare(base_array0,base_array1) {
    var _0 = array_length(base_array0), _1 = array_length(base_array1)
    var _ret = sign(_0-_1)
    
    for (var _i = _0-1; _ret == 0 && _i > -1; _i--) {
        _ret = sign(base_array0[_i]-base_array1[_i])
    }
    
    return _ret
}
// 10
// 01
function basearray_subtract(base_array,base_array_sub) {
    var _sub = 0, _i = 0, _trim = 0
    while (true) {
        if (_i < array_length(base_array_sub)) {
            _sub += base_array_sub[_i]
        } else if (_sub == 0) {
            break
        }
        if (_i < array_length(base_array)) {
            var _v = base_array[_i]-_sub
            base_array[_i] = _v-floor(_v/BASE)*BASE //mod(_v,BASE)
            _sub = abs(floor(_v/BASE))
            _trim = (base_array[_i] == 0?_trim-1:0)
            
        } else if (_sub > 0) {
            _trim = 0
            array_resize(base_array,0)
            break
        }
        _i++
    }
    array_delete(base_array,-1,_trim)
    return base_array
}
// 10 = [0,1,0,1]
// [0,2]
function basearray_new_base(base_array,base_to) {
    var _newbasearray = []
    for (var _i = 0; _i < array_length(base_array); _i++) {
        if (base_array[_i] > 0) {
            var _l = logn(base_to,BASE) * _i + logn(base_to,base_array[_i]) + 1
            var _v = power(base_to,frac(_l))
            if (array_length(_newbasearray) < floor(_l)) {array_resize(_newbasearray,floor(_l))}
            for (var _j = floor(_l)-1; _j > -1; _j--) {
                _newbasearray[_j] += floor(_v)
                _v = frac(_v)*base_to
            }
            _newbasearray[0] += (_v >= 0.5)
            
        }
    }
    var _base_prev = BASE
    BASE = base_to
    _newbasearray = basearray(_newbasearray)
    BASE = _base_prev
    return _newbasearray
}



// LEARN FLEX NODES


function basearray_string(base_array) {
	var _ret = ""
    var _d = ceil(log10(BASE))
    if (_d == 1){
        for (var _i = 0; _i < array_length(base_array); _i++) {
            _ret = string(base_array[_i]) + _ret
        }
        return _ret
    } else {
        for (var _i = 0; _i < array_length(base_array); _i++) {
            _ret = string_replace_all(string_format(base_array[_i],floor(_d),0)," ","0") + _ret
        }
        return string_trim_start(_ret,["0"])
    }
}



var _a = basearray([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1])
var _b = basearray_new_base(_a,2)

show_debug_message(basearray_string(_a))
show_debug_message(basearray_string(_b))
show_debug_message(_b)
a = _a
