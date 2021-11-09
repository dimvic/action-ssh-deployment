# Git deployments using SSH

## Prerequisites:

- Image used by action has bash and ssh installed
- Target server is accessible using has key based SSH authentication (no password support)

## Inputs:

| param | required | default | description |
| --- | --- | --- | --- |
| ssh_host | Y | | SSH host |
| ssh_user | Y | | SSH username |
| ssh_private_key | Y | | SSH private key (raw text) |
| ssh_port | | `22` | SSH port |
| target_dir | Y | | Application directory on remote server |
| git_remote | | `origin` | Git remote to use |
| git_branch | | current action branch | Git branch to use |
| callback | | | Shell command to execute after deployment, workdir being the application's directory on remote server |

## Example:

```yml
name: Deploy
on: [ push, pull_request ]
jobs:
  staging:
    if: github.ref == 'refs/heads/staging'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: dimvic/action-ssh-deployment@v1
        with:
          ssh_host: "${{ secrets.SSH_HOST }}"
          ssh_port: "${{ secrets.SSH_PORT }}"
          ssh_user: "${{ secrets.SSH_USER }}"
          ssh_private_key: "${{ secrets.SSH_PRIVATE_KEY }}"
          target_dir: "${{ secrets.STAGING_SERVER_PATH }}"
          callback: |
            RAILS_ENV=production bundle exec rails assets:precompile && \
            RAILS_ENV=production bundle exec rails db:migrate && \
            touch tmp/restart.txt
```
