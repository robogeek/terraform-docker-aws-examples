
CLUSTER=`aws ecs list-clusters --query "clusterArns[?contains(@, 'todo-docker-ecs')] | [0]" | sed "s/^\([\"']\)\(.*\)\1\$/\2/g" `

echo Cluster ARN: ${CLUSTER}

SERVICE=`aws ecs list-services --cluster ${CLUSTER} --query "serviceArns[?contains(@, 'TodoService')] | [0]" | sed "s/^\([\"']\)\(.*\)\1\$/\2/g"`

echo Service ARN: ${SERVICE}

# https://linuxhandbook.com/bash-split-string/
svcarray=($(echo ${SERVICE} | tr / '\n' ))
SERVICEID=${svcarray[2]}

echo Service ID: ${SERVICEID}

aws ecs update-service --cluster ${CLUSTER} --service ${SERVICEID} --desired-count 5
