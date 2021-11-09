quote () {
    local quoted=${1//\'/\'\\\'\'};
    printf "'%s'" "$quoted"
}

# quote callback command for use with `eval`
if [[ ! -z $DEPLOY_CALLBACK ]]; then
  export DEPLOY_CALLBACK=`quote "$DEPLOY_CALLBACK"`
fi

# put private key in a file
echo "$SSH_PRIVATE_KEY" > ./identity
chmod 700 ./identity

# perform deployment
ssh "ssh://${SSH_USER}@${SSH_HOST}:${SSH_PORT}" -i ./identity -o "StrictHostKeyChecking no" " \
  cd \"$TARGET_DIR\" && \
  git fetch \"$GIT_REMOTE\" && \
  git reset --hard \"$GIT_REMOTE/$GIT_BRANCH\" && \
  [[ ! -z "$DEPLOY_CALLBACK" ]] && eval $DEPLOY_CALLBACK \
  "

