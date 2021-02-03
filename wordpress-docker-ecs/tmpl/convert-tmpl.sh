docker compose convert \
    --environment WP_EFS_ID=${ wp_id } \
    --environment ALB_ARN=${ alb_arn } \
    --environment DB_ACCESS_ARN=${ secret_db_access_arn } \
    --environment OVERLAY=${ overlay }

