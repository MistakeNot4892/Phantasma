var/motd = "Please enjoy your stay!"

/client/New()
	. = ..()
	src << "<hr><font color = '[DARK_BROWN]' align = 'center'><b>Welcome to Phantasma!</b><br>[motd]<hr><br></font>"
