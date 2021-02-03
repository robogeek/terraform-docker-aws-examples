
QUERY='AccessPoints[?Name == `${ efs_nm }`].{ fsapid: AccessPointId }[0].fsapid'
EFSID=${ efs_id }

FSAPID=`aws efs describe-access-points --file-system-id $EFSID --query "$QUERY" | sed "s/^\([\"']\)\(.*\)\1\$/\2/g"`

echo sudo mount -t efs -o tls,accesspoint=$FSAPID $EFSID:/ /home/ubuntu/efs

