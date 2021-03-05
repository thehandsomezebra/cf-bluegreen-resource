# Under Construction!!!

#### Blue-Green Deployment

Blue-green deployment is a technique that reduces downtime and risk by running two identical production environments called Blue and Green.

This resource type makes it possible to push a new application, run smoketests to check if it is working as designed, adjust routes between the new and old routes, then lastly remove the old app.

Read the more about using a Blue-Green deployment in [Cloud Foundry's docs](https://docs.cloudfoundry.org/devguide/deploy-apps/blue-green.html).

A [manifest](https://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html) that describes the application must be specified.

- `org`: _Required._ The organization to target.
- `space`: _Required._ The space to target.
- `path`: _Optional._ Path to the application to push. If this isn't set then it will be read from the manifest instead. 
### ^^^// TODO: INVESIGATE THIS PART.. or just set to required and ignore the manifest..

- `current_app_name`: _Required._ This should be the name of the application that this will deploy as blue/green. 
#### ^^^ // TODO: ADD CATCH TO CHECK CF APPS
- `manifest`: _Required._ Path to a application manifest file.
- `manifest_env_variables`: _Optional._ Environment variable key/value pairs to add to the manifest. 
<!-- - `manifest_vars`: _Optional._ Map of variables to pass to manifest `**INVESIGATE THIS PART`
- `manifest_vars_files`: _Optional._ List of variables files to pass to manifest `**INVESIGATE THIS PART` -->
- `smoketest`: _Optional._ Testing script to run.  NOTE: At this time, only one *.sh file is accepted
- `smoketest_variables`: _Optional._ If using a smoketest, you may set variables used in *.sh file here.
- `keep_old_app`: _Optional._ If the blue/green deployment is successful, set `true` to keep original app named as *-old.

*to add:  
- `no_start`: _Optional._ Deploys the app but does not start it.




```yml
- put: cf-blue-green-deploy
  resource: cf-env
  params:
    org: myorg
    space: myspace
    path: path/to/myapp-*.jar
    current_app_name: myapp-ui
    smoketest: path/to/mytest.sh
    smoketest_variables:
      key1: mysecret
      key1: mysecret2
    manifest: path/to/manifest.yml
    manifest_env_variables:
      key3: value
      key4: value2
    # manifest_vars:
    #   instances: 3
    # manifest_vars_files:
    #   - path/to/vars.yml
    keep_old_app: true
    #no_start: true
```