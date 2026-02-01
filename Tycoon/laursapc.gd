extends ColorRect # Herança correta para ColorRect

func _ready():
	# Define a cor do nó para o azul do Windows 95
	# (Isso ajuda o shader a ter uma base de cor)
	color = Color("008787ff") 
	
	# Ajusta os presets de âncora para ocupar a tela toda
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	

# Removido o _process com flicker para evitar cansaço visual
