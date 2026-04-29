// 1<<n = 2^n

// LEARN FLEX NODES
// 16  2

// basestruct is an unsigned integer without maximum limit
// basestruct is Little Endian
BASE = 7

function basestruct_normalize(base_struct) {
	with (base_struct) {
		var _trim = 0
		for (var _i = 0; _i < array_length(array); _i++) {
			if (array[_i] >= base) {
				if (_i == array_length(array)-1) {array_push(array,0)}
				var _ext = floor(array[_i]/base)
				array[_i] -= base*_ext
				array[_i+1] += _ext
			}
			_trim = (array[_i] == 0?_trim-1:0)
		}
		if (_trim < 0) {array_delete(array,-1,_trim)}
	}
}

function basestruct(base,val_or_array) {
	var _ret = {base:base,array:(is_array(val_or_array)?val_or_array:[val_or_array])}
	basestruct_normalize(_ret)
	return _ret
}

function basestruct_new_basestruct(base_struct,base_to) {
	var _retbasestruct = basestruct(base_to,[])
	var _0arr = base_struct.array, _RETarr = _retbasestruct.array
	for (var _i = 0; _i < array_length(_0arr); _i++) {
		var _bstruct = basestruct(base_to,_0arr[_i])
		repeat (_i) {basestruct_multiply_value(_bstruct,base_struct.base)}
		basestruct_add(_retbasestruct,_bstruct)
	}
	return _retbasestruct
}

function basestruct_return_base_matched(base_struct,base_struct_to_match) {
	var _ret = base_struct
	if (base_struct.base != base_struct_to_match.base) {
		_ret = basestruct_new_basestruct(_ret,base_struct_to_match.base)
	}
	return _ret
}

function basestruct_multiply_value(base_struct,mul) {
	with (base_struct) {
		var _r = 0
		for (var _i = array_length(array)-1; _i > -1; _i--) {
			var _v = array[_i]*mul + _r
			array[_i] = floor(_v)
			_r = base*frac(_v)
		}
	}
	basestruct_normalize(base_struct)
}

function basestruct_compare(base_struct0,base_struct1) {
	var _basestructcomp = basestruct_return_base_matched(base_struct1,base_struct0)
	var _0arr = base_struct0.array, _1arr = _basestructcomp.array
	
	var _0 = array_length(_0arr), _1 = array_length(_1arr)
    var _ret = sign(_0-_1)
    for (var _i = _0-1; _ret == 0 && _i > -1; _i--) {
        _ret = sign(_0arr[_i]-_1arr[_i])
    }
    return _ret
}

function basestruct_add(base_struct,base_struct_add) {
	var _basestructadd = basestruct_return_base_matched(base_struct_add,base_struct)
	var _0arr = base_struct.array, _ADDarr = _basestructadd.array
	
	array_resize(_0arr,max(array_length(_0arr),array_length(_ADDarr)))
	for (var _i = 0; _i < array_length(_ADDarr); _i++) {
		_0arr[_i] += _ADDarr[_i] 
	}
	basestruct_normalize(base_struct)
}

function basestruct_subtract(base_struct,base_struct_sub) {
	var _basestructsub = basestruct_return_base_matched(base_struct_sub,base_struct)
	var _0arr = base_struct.array, _SUBarr = _basestructsub.array
	
    var _sub = 0, _i = 0, _trim = 0, _base = base_struct.base
    while (true) {
        if (_i < array_length(_SUBarr)) {
            _sub += _SUBarr[_i]
        } else if (_sub == 0) {
            break
        }
        if (_i < array_length(_0arr)) {
            var _v = _0arr[_i]-_sub
            _0arr[_i] = _v-floor(_v/_base)*_base //mod(_v,BASE)
            _sub = abs(floor(_v/_base))
            _trim = (_0arr[_i] == 0?_trim-1:0)
            
        } else if (_sub > 0) {
            _trim = 0
            array_resize(_0arr,0)
            break
        }
        _i++
    }
    if (_trim < 0) {array_delete(_0arr,-1,_trim)}
}



function basestruct_string(base_struct) {
	var _ret = ""
	var _array = base_struct.array, _base = base_struct.base, _d = ceil(log10(_base))
    if (_d == 1){
        for (var _i = 0; _i < array_length(_array); _i++) {
            _ret = string(_array[_i]) + _ret
        }
    } else {
		var _space = (_d==log10(_base)?"":" ")
        for (var _i = 0; _i < array_length(_array); _i++) {
            _ret = _space + string_replace_all(string_format(_array[_i],floor(_d),0)," ","0") + _ret
        }
		_ret = string_trim_start(_ret,[(_space==""?"0":" ")])
    }
	return _ret
}


function basestruct_from_numbered_string(base,str) {
	var _array = [], _trim = 0
	var _d = ceil(log10(base)), _ext = false
	var _sect = ""
	for (var _i = string_length(str); _i > 0; _i--) {
		var _s = string_digits(string_char_at(str,_i))
		_sect = _s + _sect
		
		if (_sect != "") {
			if (_s == "" || string_length(_sect) == _d || _i == 1) {
				var _v = real(_sect)
				array_push(_array,_v)
				_trim = (_v == 0?_trim-1:0)
				if (_v >= base) {_ext = true}
				_sect = ""
			}
		}
	}
	var _basestruct = {base:base,array:_array} 
	if (_ext) {basestruct_normalize(_basestruct)}
	return _basestruct
}

var _a = basestruct_from_numbered_string(17,"3, 12, 1, 13, 5, 13, 3, 7, 9, 2, 7, 1, 11, 14, 1, 6, 3, 0, 10, 9, 6, 14, 10, 12, 0, 0, 11, 14, 4, 4, 1, 12, 4, 15, 8, 4, 6, 1, 9, 0, 0, 9, 10, 10, 3, 15, 4, 9, 6, 5, 2, 16, 2, 9, 3, 0, 8, 2, 13, 11, 4, 13, 11, 14, 9, 16, 6, 12, 3, 2, 5, 16, 7, 13, 8, 14, 12, 1, 4, 0, 1, 10, 8, 9, 16, 13, 15, 3, 1, 1, 2, 14, 15, 3, 0, 7, 9, 4, 3, 8, 12, 1, 4, 10, 3, 7, 11, 5, 8, 15, 10, 7, 12, 9, 8, 4, 11, 4, 8, 7, 14, 0, 6, 6, 9, 9, 12,1")
var _b = basestruct_new_basestruct(_a,9973)


//array_copy(_a,0,_,-1,-array_length(_))
show_debug_message(_a)
show_debug_message(basestruct_string(_a))
show_debug_message(basestruct_string(_b))
