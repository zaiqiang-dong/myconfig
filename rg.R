ylst <- yaml::yaml.load_file('./open.yaml')
dt <- data.tree::as.Node(ylst)
collapsibleTree::collapsibleTree(
		dt,
		fill = 'orangered',
		root = 'vfs_open',
		width = 1850,
		height = 900,
		attribute = 'file',
		tooltip = T)
