# Git Mentors

### Overview

Allow a given user as owner to add a set of users to an org and teams.

#### Executing Script
This script relies on a .env file which contains the following keys
- GIT_EMAIL
- GIT_PASSWORD

After you have that just run lib/git_mentors.rb and follow along.

### PSEUDO:

- ask cli for username && password
- Interface with github API
- authenticate as the owner
- get a list of owners orgs
- ask cli to select org from list
- display list of users to add
- display confirmation
- display list teams to add to
- display confirmation
- Interface with github API
- iterate over user list
- add each user to a given org and team
- display confirmation and count when complete

### Next Steps
- Add tests
- Add better CLI interface with confirmation for cohort org before add batch
- add batch method which will parse over a given input
- package into a gem and publish
- maybe lose .env in favor of dynamically entering credentials each run
