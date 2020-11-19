
JOINCMD=`ssh ${ srv1 } docker swarm join-token manager | sed 1,2d | sed 2d`

ssh ${ srv2 } $JOINCMD
ssh ${ srv3 } $JOINCMD

ssh ${ srv1 } mkdir /home/ubuntu/letsencrypt

docker --context ${ context } secret create RDS_DB_CONFIG - <../rds/rds-mysql.yaml
