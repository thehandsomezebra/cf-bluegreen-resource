
manifest=$(get_option '.manifest')
current_app_name=$(get_option '.current_app_name')
show_app_log=$(get_option '.show_app_log')
path=$(get_option '.path')
environment_variables=$(get_option '.environment_variables')
vars=$(get_option '.vars')
vars_files=$(get_option '.vars_files')
test_scripts=$(test_scripts '.test_scripts')
no_start=$(get_option '.no_start')

logger::info "Executing $(logger::highlight "$command")"

if [ ! -f "$manifest" ]; then
  logger::error "invalid payload (manifest is not a file: $(logger::highlight "$manifest"))"
  exit $E_MANIFEST_FILE_NOT_FOUND
fi

if [ -n "$environment_variables" ]; then
  cf::set_manifest_environment_variables "$manifest" "$environment_variables" "$current_app_name"
fi

args=()
[ -n "$current_app_name" ] && args+=("$current_app_name")
args+=(-f "$manifest")
[ -n "$path" ]             && args+=(-p $path) # don't quote so we can support globbing
[ -n "$no_start" ]         && args+=(--no-start)

for key in $(echo $vars | jq -r 'keys[]'); do
  value=$(echo $vars | jq -r --arg key "$key" '.[$key]')
  args+=(--var "$key=$value")
done

for vars_file in $(echo $vars_files | jq -r '.[]'); do
  if [ ! -f "$vars_file" ]; then
    logger::error "invalid payload (vars_file is not a file: $(logger::highlight "$vars_file"))"
    exit 1
  fi
  args+=(--vars-file "$vars_file")
done










cf::target "$org" "$space"

# . Check if blue exists 
# ** If true, rename blue with suffix `-blue`

if [ -n "$current_app_name" ] && cf::app_exists "$current_app_name"; then
  blue_app_name="$current_app_name-blue"
  cf::rename "$current_app_name" "$blue_app_name"

##set up variable for the new app name
  green_app_name="$current_app_name-green"



# # . Generate random route
# # ** Need to write something for this, remembering the domain name cannot be more than 63 characters

###############
    ##get the domain from the input
#domain=$(get_option '.domain')
original_route=$(cf app $current_app_name | grep routes | awk '{print $2}')
original_domain=$(echo $original_route | sed -e "s/$current_app_name.//g")
 #hostname=$(get_option '.hostname')
    ## new route will be $green_app_name.$original_domain
###############
######we are already targeted

##we are already targeted, begin setting up args for new route
args=() #reset args
args+=("$original_domain")
args+=(--hostname "$green_app_name")

cf::cf create-route "${args[@]}"







# . Push green app with random route 
## Green is going to be ""
green_app_name="$current_app_name-green"
##cf push sets domain as default apps.internal, subdomain.example.com
## https://cli.cloudfoundry.org/en-US/v6/push.html


green_route_path=$green_app_name.$original_domain

args=() #reset args
[ -n "$app_name" ]                 && args+=("$app_name")
[ -n "$buildpack" ]                && args+=(-b "$buildpack")
[ -n "$startup_command" ]          && args+=(-c "$startup_command")
[ -n "$manifest" ]                 && args+=(-f "$manifest")
[ -n "$green_app_name" ]           && args+=(-n "$green_app_name") #This is the new hostname
[ -n "$original_domain" ]          && args+=(-d "$original_domain")
[ -n "$no_start" ]                 && args+=(--no-start)
[ -n "$path" ]                     && args+=(-p $path) # don't quote so we can support globbing
[ -n "$stack" ]                    && args+=(-s "$stack")
[ -n "$strategy" ]                 && args+=(--strategy "$strategy")

args+=(--route-path "$green_route_path")

 cf::cf push "${args[@]}"

#https://cli.cloudfoundry.org/en-US/v6/push.html
#include the new random route in this push 


#execute smoke tests, if any
# . For each smoke test
# .. Execute passing in the random route as the first input (`$1`)
# .. Capture the result
# *** If `exit_code` is 0, continue
# *** Else
# **** If `clean_up` is `true`
# ***** Delete green
# ***** Rename blue by removing suffix `-blue`
# **** `exit 1`



#if success from smoke test (or no smoke tests offered)
# . Unmap random route from green

# . Map route(s) from incoming manifest to green
# . Delete blue







    logger::error "Error encountered during blue-green deploy. You need to do manual cleanup." #############

    # cf::delete "$current_app_name"
    # cf::rename "$venerable_app_name" "$current_app_name"

    exit $E_BLUE_GREEN_FAILED 
  fi

  #cf::delete "$venerable_app_name"
else
  #cf::cf push "${args[@]}"
fi
