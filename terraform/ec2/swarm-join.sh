
MASTER=$1
ROLE=$2

if [ -z "$MASTER" ]; then
    echo MUST SPECIFY A MASTER NODE - got: $MASTER
    exit 1
fi

if [ -z "$ROLE" ]; then
    echo MUST SPCIFY A ROLE - got: $ROLE
    exit 1
fi

if [ "$ROLE" != "manager" -a "$ROLE" != "worker" ]; then
    echo ROLE must be either manager or worker - got: $ROLE
    exit 1
fi

JOINCMD=`ssh $MASTER docker swarm join-token $ROLE | sed 1,2d | sed 2d`
echo $JOINCMD
