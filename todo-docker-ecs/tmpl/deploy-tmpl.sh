docker compose up \
    --environment ALB_ARN="${ alb_arn }" \
    --environment SEQUELIZE_CONNECT_ARN="${ sequelize_connect_arn }"
