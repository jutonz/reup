# Reup

reup helps you context switch between projects by getting your various development environments up to date quickly.

Use it like so:
```bash
$ cd ~/code/my-awesome-project
$ reup
```

This will do two things:

1. `git pull` so you have the lastest code
1. Start your application server
  * reup knows what codebase you're using, so it can guess pretty well what it needs to do to start your server.
  * For example, if reup detects a `Gemfile` with Foreman, it will run `bundle exec foreman start`. If it detects `ember-cli-build.js`, it will run `ember serve`. This is totally [configurable](#configuration).

reup also supports conditional actions:

* If, in your Ember app, reup detects that `package.json` or `bower.json` were modified by `git pull`, it will also run `npm install`. Again, this is completely [configurable](#configuration).


## <a name="options">Flags and options</a>

#### `--resetdb`
* also `-r`
* Reset the database after pulling. Useful if you have someone on your team with a proclivity to rewrite migrations.

#### `--branch`
* also `-b`
* Perform a `git checkout` of the given branch prior to pulling.
* For example, this will take you back to the master branch:

  ```bash
  # reup -b master
  ```

## <a name="configuration">Configuration</a>

First, run `reup --init`. This will create a file `~/.reup.yaml` where you can place your custom commands.

The default `.reup.yaml` looks like this:
```yaml
---
ember:
  indicator_files:
    - ember-cli-build.js
  serve:
    command: "ember server"
  install:
    command: "npm install"
    only_if_changed:
      - bower.json
      - package.json
      - ember-cli-build.js
rails:
  indicator_files:
    - Gemfile
  serve:
    command: "bundle exec foreman start"
  install:
    command: bundle
    only_if_changed:
      - Gemfile
  db:
    reset_command: "bundle exec rake db:migrate:reset"
    migrate_command: "bundle exec rake db:migrate"
```

A few notes about this file:

1. Top-level values indicate project types. You can have as many as these as you want, and name them whatever you want.
2. Each project type is determined by a series of `indicator_files` that must be present in the working directory.
  * These need to be unique to a specific project. You can't have two projects that only specify `Gemfile` as an indicator file, for instance.
3. The action to be taken upon detecting the indicator files is specified in `serve`.
4. `install` is where you specify how dependencies are installed for this project type.
  * If you like, you can also write an `only_if_changed` property here. The install command will only be run if any of the files you specify are changed by the pull.
5. Some projects, like Rails, also support `db` actions.
  * These allow you to quickly reset your database or run migrations after doing a pull.
