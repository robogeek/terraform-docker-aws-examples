
export DOMAIN_MGR=${ domain_mgr }
export DOMAIN_TODO=${ domain_todo }
export DOMAIN_TODO_WWW=${ domain_todo_www }
export EMAIL_LETS_ENCRYPT=${ email_lets_encrypt }

docker stack deploy --compose-file docker-compose.yml ${ stack_name }
