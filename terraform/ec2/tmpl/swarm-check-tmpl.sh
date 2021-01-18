set -x
%{ for server_ip in servers ~}
ssh ${ key_pair_file } ${ ssh_user_id } ${ server_ip } docker ps
%{ endfor ~}
