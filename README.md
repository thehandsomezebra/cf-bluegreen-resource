# Under Construction!!!

#### `blue-green` Deploy

Deploy an application to a Cloud Foundry

Pushes an application to the Cloud Foundry detailed in the source configuration. A [manifest](https://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html) that describes the application must be specified.

_NOTE_: This command is designed to function as a replacement for the Concourse [cf-resource](https://github.com/cloudfoundry-community/cf-resource).

- `org`: _Optional._ The organization to target (required if not set in the source config)
- `space`: _Optional._ The space to target (required if not set in the source config)
- `manifest`: _Required._ Path to a application manifest file.
- `path`: _Optional._ Path to the application to push. If this isn't set then it will be read from the manifest instead.
- `current_app_name`: _Optional._ This should be the name of the application that this will re-deploy over. If this is set the resource will perform a zero-downtime deploy.
- `environment_variables`: _Optional._ Environment variable key/value pairs to add to the manifest.
- `vars`: _Optional._ Map of variables to pass to manifest
- `vars_files`: _Optional._ List of variables files to pass to manifest
- `test_scripts`: _Optional._ Testing scripts to run.
- `show_app_log`: _Optional._ Outputs the app log after a failed startup, useful to debug issues when used together with the `current_app_name` option.
- `no_start`: _Optional._ Deploys the app but does not start it.
```yml
- put: cf-zero-downtime-push
  resource: cf-env
  params:
    command: zero-downtime-push
    manifest: path/to/manifest.yml
    path: path/to/myapp-*.jar
    current_app_name: myapp-ui
    environment_variables:
      key: value
      key2: value2
    vars:
      instances: 3
    vars_files:
      - path/to/vars.yml
```