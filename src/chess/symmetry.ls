sym = (bound, flip) -> (actions) ->
	concat-map _, actions <| (action) ->
		if all bound, [action.target] ++
				map (.target), action.conds ++ action.units
			then [action]
			else [action, action with do
				target: flip action.target
				conds: map (-> it with target: flip it.target), action.conds
				units: map (-> it with target: flip it.target), action.units
			]

export sym2 = sym (==0) << (.0), (-> it with 0: -it.0)

export sym4 = sym (==0) << (.1), (-> it with 1: -it.1)

export sym8 = sym (-> it.0 == it.1), (-> [it.1, it.0])

