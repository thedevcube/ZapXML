extends OptionButton

func get_opr():
	if selected == 0:
		return "Equal"
	elif selected ==  1:
		return "Greater"
	elif selected == 2:
		return "Less"


func get_opr_syntax():
	if selected != 0:
		return "Than"
	else:
		return "Value2"

func get_opr_prefix():
	if selected != 0:
		return "Value"
	else:
		return "Value1"
