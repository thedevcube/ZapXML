extends OptionButton

func get_opr(as_item = false):
	match selected:
		0:
			return (0 if as_item else "Equal")
		1:
			return (1 if as_item else "Greater")
		2:
			return (2 if as_item else "Less")


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

func get_astext_selected(string):
	match string:
		"Equal":
			return 0
		"Greater":
			return 1
		"Less":
			return 2
