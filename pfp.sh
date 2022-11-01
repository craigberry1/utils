if [ -z "$1" ]
then
  echo "Missing pod name"
  exit 1
fi

if [ $# -gt 2 ];
then
  echo "Too many arguments, expected: pfpod [pod_name_search] [port_number]"
  exit 1
fi

pod_name=$(kubectl get pods --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | grep $1)
match_cnt=$(echo $pod_name | wc -w)

if [ $match_cnt -lt 1 ];
then
  echo 'No pod name match found.'
  exit 1
fi

if [ $match_cnt -gt 1 ];
then
  echo 'Ambiguous pod name. Matched'$match_cnt' pods'.
  exit 1
fi

if [ -z "$2" ]
then
port_num='random port'
else
port_num='port '$2
fi

echo Forwarding $pod_name to $port_num

kubectl port-forward pod/$pod_name $2:8080%