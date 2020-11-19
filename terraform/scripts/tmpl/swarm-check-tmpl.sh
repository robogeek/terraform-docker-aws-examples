
# Shell script for checking whether Docker on the VPS's is running
# The check is imply to run "docker ps"

ssh ${ srv1 } docker ps
ssh ${ srv2 } docker ps
ssh ${ srv3 } docker ps
