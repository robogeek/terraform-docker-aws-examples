
LBARN=${ alb_arn }

echo Load Balancer ARN: $LBARN

# sed command came from:
# https://stackoverflow.com/questions/758031/stripping-single-and-double-quotes-in-a-string-using-bash-standard-linux-comma
TGARN=`aws elbv2 describe-target-groups --load-balancer-arn $LBARN --query 'TargetGroups[0].TargetGroupArn' | sed "s/^\([\"']\)\(.*\)\1\$/\2/g"`

echo Target Group ARN: $TGARN

aws elbv2 modify-target-group-attributes --target-group-arn $TGARN --attributes Key=stickiness.enabled,Value=true

