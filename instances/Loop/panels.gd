extends Node

func get_panel(panelname):
	match panelname:
		"actions_panel":
			return get_node("ActionPanel")
		"conditions_panel":
			return get_node("ConditionsPanel")
		"action_list":
			return get_node("ActionPanel/Margin/ScrollList")
		"condition_list":
			return get_node("ConditionsPanel/Margin/ScrollList")
		"using_list":
			return get_node("UsingPanel/Margin/ScrollList")
		"info_eventnode":
			return get_node("ActionPanel/Event")
