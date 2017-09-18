export symmetry2 = (targets) ->
	[f, r] = partition (==0) << (.0), targets
	f ++ r ++ map (-> [-it.0, it.1]), r

export symmetry4 = (targets) ->
	[f, r] = partition (==0) << (.1), targets
	symmetry2 <| f ++ r ++ map (-> [it.0, -it.1]), r

export symmetry8 = (targets) ->
	[f, r] = partition (-> it.0 == it.1), targets
	symmetry4 <| f ++ r ++ map (-> [it.1, it.0]), r

export attack = () ->

export move = () ->

export take = () ->

export swap = () ->

export promote = () ->


