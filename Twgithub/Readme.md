To Create a repo called api-test(this will be a public repo)
bin/tw-github -n api-test

add (-p) option to keep the repo private.

Remove a repo called api-test
bin/tw-github -n api-test -r


Add user sreeix as a collaborator to a repo called api-test
bin/tw-github -n api-test -a sreeix

To list all users projects
bin/tw-github


You will need to have the github.yml file in the root. The content of it will be something like this

--- 
:user_name: sreeix
:api_key: *******************
