echo "* Remove the network if it already exists.."
docker network rm appnet || true
echo "* Creating the app network"
docker network create appnet
