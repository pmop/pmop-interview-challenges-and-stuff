### NOTES

This repo clones https://github.com/pmop/miniature-sniffle into 'alpha' and 'beta', plus modify the config files, for ease of use.

- Redis is required since ActionCable depends on it. Ideally it also should be running on port 6379.
```
On Ubuntu based:

sudo apt install redis
redis-server
```

- I recommend using tmux to run these multiple services and keep track of them.

Run alpha with:
```
cd alpha
rails db:migrate

rails s -p 3000

OR, IF RUNNING IN CONTAINER
rails s -b 0.0.0.0 -p 3000
```

Run beta with:
```
cd beta
rails db:migrate
rails s -p 3001

OR, IF USING CONTAINER
rails s -b 0.0.0.0 -p 3001
```

Then on each application, sign up, remember to use the same email when signing up on the two apps:
```
Alpha:
http://localhost:3000/users/sign_up

OR, IF USING CONTAINER
http://<container-ip-address>:3000/users/sign_up

Beta:
http://localhost:3001/users/sign_up

OR, IF USING CONTAINER
http://<container-ip-address>:3001/users/sign_up
```
 
On each application, you should be redirected to sign in/ calendar view after signing up/signing in.
If sync is not working, you're probably not signed in, or the applications are running on some port different from the expected ones. The peer port can be set on config files `config/config/environments/development.rb` or `config/environments/production.rb` if running on production mode.

- Tested in development mode
