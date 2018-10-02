display() {
	echo "[Start up script] $1"
}

display "Started"


display "Run builds";

cd calculator && eval gradle build && display "Calculator done"
cd ../service-add && eval gradle build && display "Add service done"
cd ../service-subtract && eval gradle build && display "Subtract service done"
cd ../service-multiply && eval gradle build && display "Multiply service done"
cd ../service-divide && eval gradle build && display "Divide service done"

display "Builds finished"


display "run docker images"

cd .. && eval docker-compose build && eval docker-compose up -d

display "docker images up and running"


display "delete built jar files"

cd calculator && eval gradle clean && display "Calculator cleaned"
cd ../service-add && eval gradle clean && display "Add service cleaned"
cd ../service-subtract && eval gradle clean && display "Subtract service cleaned"
cd ../service-multiply && eval gradle clean && display "Multiply service cleaned"
cd ../service-divide && eval gradle clean && display "Divide service cleaned"

display "Finished"

