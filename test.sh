for i in `seq 1000`;do
	if (($i % 100 == 0)); then
		echo "$i"
	fi
	lua test.lua
done
