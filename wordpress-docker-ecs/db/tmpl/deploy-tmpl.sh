docker compose up \
    --environment WORDPRESS_DB_HOST=${ db_host } \
    --environment WORDPRESS_DB_USER=${ db_user } \
    --environment WORDPRESS_DB_PASSWORD=${ db_password } \
    --environment WORDPRESS_DB_NAME=${ db_name } \
    --environment WP_EFS_ID=${ wp_id } \
    --environment ALB_ARN=${ alb_arn } \
    --environment ALB_NAME=${ alb_name }

