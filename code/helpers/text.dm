// todo
/proc/trim_spaces(var/message = "")
	if(!message || message == "")
		return ""
	return message

/proc/sanitize_text(var/message = "", var/max_length = 200)

	// Trim down to size.
	message = copytext(message,1,max_length)

	// Remove HTML tags.
	message = replacetext(message, "<", "")
	message = replacetext(message, ">", "")

	// Remove trailing spaces.
	message = trim_spaces(message)
	return message

/proc/capitalize(var/message = "")
	return "[uppertext(copytext(message,1,2))][copytext(message,2)]"

/proc/format_and_capitalize(var/message = "")
	message = capitalize(message)
	if(!(copytext(message, length(message)) in list("!","?",".")))
		message += "."
	return message

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