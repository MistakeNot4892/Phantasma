/proc/shuffle_list(var/list/_list)
	if(!_list)
		return
	_list = _list.Copy()
	for(var/i=1 to _list.len)
		_list.Swap(i, rand(i,_list.len))
	return _list

/proc/concat_list(var/list/_list, var/prepend)
	var/result = ""
	var/i = 1
	for(var/entry in _list)
		if(prepend)
			result+= "[prepend]"
		result += "[entry]"
		if(_list.len>1 && i != _list.len)
			if(i+1 != _list.len)
				result += ", "
			else
				result += " and "
		i++
	return result