
#!/bin/bash




### Use some json from somewhere.... or supply it.
json='{"FIRST_VAR":"Hello friend","SECOND_VAR":"Hi there pal","THIRD_VAR":"Hey yall"}'

## The json is set up as 1 key with 1 value... we'll use this to our advantage
## use jq's to_entries to set it up as key=value -- and eval it so that all of those become
## variables in our script
eval $( echo $json | jq -r 'to_entries | .[] | .key + "=\"" + .value + "\""')


ALSOTEST="Another random var"


# set the external script to executable
chmod +x ./theory.sh

## We'll run the script as source via a variable.  
# Why? 
# First, we don't need to do anything with the variables we have set -- no need to do anything like `export $FIRST_VAR`
# Second, it allows us to skip the "exit", which would exit us out of all this parent script
# Lastly, it also allows us to grab the last status it threw (either by cmd or passed via exit code)

TEST=$(source ./theory.sh ) #runs the test -- note, we're just trying to get the exit code, nothing outputs to terminal yet
STATUS1=$? #gets the exit code/last executed cmd from the test
echo $TEST # we can see what the script output, if we want to - but it won't be formatted nicely.


# let's report back on how well that internal script did:
if [ $STATUS1 -eq 0 ]; then 
  echo "your testing theory ran successfully"
else 
  echo "your testing theory made an error"
fi