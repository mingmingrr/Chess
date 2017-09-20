sym = (bound, flip) -> (actions) ->
	concat-map _, actions <| (action) ->
		return [action] if bound action.target
		action2 = {} <<< action <<<
			target: flip action.target
			conds: map (-> {} <<< it <<< {target: flip it.target}), action.conds
			units: map (-> {} <<< it <<< {target: flip it.target}), action.units
		return [action, action2]

export sym2 = sym (==0) << (.0), (-> [-it.0, it.1])

export sym4 = sym2 . sym (==0) << (.1), (-> [it.0, -it.1])

export sym8 = sym4 . sym (-> it.0 == it.1), (-> [it.1, it.0])

