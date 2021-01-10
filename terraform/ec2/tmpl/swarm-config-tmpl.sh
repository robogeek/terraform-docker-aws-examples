set -x

MASTER_HOST=invalid-ip-address

%{ for host in host_modes ~}
    %{ if host.swarm_init ~}
        MASTER_HOST=${ host.ip_addr }
    %{ endif ~}
%{ endfor ~}

JOINMGR=`ssh ${ key_pair_file } ${ ssh_user_id } $MASTER_HOST docker swarm join-token manager | sed 1,2d | sed 2d`
JOINWORKER=`ssh ${ key_pair_file } ${ ssh_user_id } $MASTER_HOST docker swarm join-token worker | sed 1,2d | sed 2d`

%{ for host in host_modes ~}
    %{ if !host.swarm_init && host.join_manager ~}
        ssh ${ key_pair_file } ${ ssh_user_id } ${ host.ip_addr } $JOINMGR
    %{ endif ~}
    %{ if !host.swarm_init && host.join_worker ~}
        ssh ${ key_pair_file } ${ ssh_user_id } ${ host.ip_addr } $JOINWORKER
    %{ endif ~}
%{ endfor ~}

ssh ${ key_pair_file } ${ ssh_user_id } $MASTER_HOST \
    docker secret create RDS_DB_CONFIG - <../rds/rds-mysql.yaml
