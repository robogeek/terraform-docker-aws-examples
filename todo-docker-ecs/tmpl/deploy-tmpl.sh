docker compose up \
    --environment ALB_ARN="${ alb_arn }" \
    --environment SSL_CERTIFICATE_ARN="${ certificate_arn }" \
    --environment SEQUELIZE_CONNECT_ARN="${ sequelize_connect_arn }" \
    --environment WWWDOMAIN="${ www_domain }" \
    --environment BASEDOMAIN="${ base_domain }"
