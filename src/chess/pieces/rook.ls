export symbols = <[\u2656 \u265c]>
export moves =
	map (-> [it, 0]), [1 to 7]
	map (-> [0, it]), [1 to 7]
	map (-> [it, 0]), [-1 to -7 by -1]
	map (-> [0, it]), [-1 to -7 by -1]
export takes = moves
