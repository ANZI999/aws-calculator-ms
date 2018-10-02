display() {
	echo "[Tear down script] $1"
}

display "Started"

eval docker-compose down

display "Finished"

