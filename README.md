#### Blue-Green Deployment

Blue-green deployment is a technique that reduces downtime and risk by running two identical production environments called Blue and Green.

This resource type makes it possible to push a new application, run smoketests to check if it is working as designed, adjust routes between the new and old routes, then lastly remove the old app.

Read the more about using a Blue-Green deployment in [Cloud Foundry's docs](https://docs.cloudfoundry.org/devguide/deploy-apps/blue-green.html).

A [manifest](https://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html) that describes the application must be specified.

- `org`: _Required._ The organization to target.
- `space`: _Required._ The space to target.
- `create_new`: _Optional._ Set `true` to create the org and space if they do not yet exist. This is useful for first-time deployments - no need to adjust the pipeline.
- `current_app_name`: _Required._ This should be the name of the application that this will deploy as blue/green. Note: this requires app to exist & will not work for fresh deployments.
cf cli v6 specific params
- `path`: _Optional._ Path to the application to push.  (If this isn't set then it will be read from the manifest instead.)
- `manifest`: _Required._ Path to a application manifest file.
- `manifest_env_variables`: _Optional._ Environment variable key/value pairs to add to the manifest. 
- `smoketest`: _Optional._ Testing script to run.  NOTE: At this time, only one *.sh file is accepted
- `smoketest_variables`: _Optional._ If using a smoketest, you may set variables used in *.sh file here.
- `keep_old_app`: _Optional._ If the blue/green deployment is successful, set `true` to keep original app named as *-old.


----
> Other notes:
> - For new apps, the route will be pulled from the manifest.  
> - For existing apps deploying with the blue-green method, it will utilize the original route.


----

```yml
jobs:
  - name: blue-green-deploy
    plan:
    - put: cf-blue-green-deploy
      resource: cf-env
      params:
        org: myorg
        space: myspace
        create_new: true
        current_app_name: myapp-ui
        path: path/to/myapp-*.jar
        smoketest: path/to/mytest.sh
        smoketest_variables:
          key1: mysecret1
          key2: mysecret2
        manifest: path/to/manifest.yml
        manifest_env_variables:
          key3: value1
          key4: value2
        keep_old_app: true
```

```yml
resources:
  - name: cf-env-sandbox
    icon: cloud
    type: cf-bluegreen-resource
    source:
      api: https://api.system.environment.company.io
      username: admin
      password: yourpassword
      skip_cert_check: true
```

```yml
resource_types:
  - name: cf-bluegreen-resource
    type: registry-image
    source:
      repository: thehandsomezebra/cf-bluegreen-resource
      tag: latest
```

----

### Planned later improvements:

- Currently this works for just cf6.  Plans to make this work universally with 6 & 7 coming soon.
- Plans to add `manifest_vars` for map of variables to pass to manifest.
- Plans to add `manifest_vars_files` for file with variables to pass to manifest.
```yml
    # manifest_vars:
    #   instances: 3
    # manifest_vars_files:
    #   - path/to/vars.yml
```