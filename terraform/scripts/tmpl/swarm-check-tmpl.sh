set -x
%{ for srv in servers ~}
ssh ${ srv } docker ps
%{ endfor ~}
