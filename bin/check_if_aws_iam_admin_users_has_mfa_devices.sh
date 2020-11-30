#!/bin/bash +e

PROFILE=default
declare -a ADMIN_USERS
declare -a WARNING_USERS

AWS_ACCOUNT_ID=$(aws sts --profile ${PROFILE} get-caller-identity | jq -r '.Account')
user_names=$(aws iam --profile ${PROFILE} list-users | jq -r '.Users[].UserName')

for user_name in $user_names; do
  login_profile=$(aws iam --profile ${PROFILE} get-login-profile --user-name $user_name 2>/dev/null)
  if [ $? -eq 0 ]; then
    list=$(aws iam --profile ${PROFILE} list-attached-user-policies --user-name $user_name --query 'AttachedPolicies[].PolicyArn')
    for policy in $list; do
      if [ "$(echo $policy | grep AdministratorAccess)" ]; then
        # AdministratorAccessを持ったユーザー
        echo "$AWS_ACCOUNT_ID - $user_name has AdministratorAccess"
        ADMIN_USERS+=($user_name)
      fi
    done
  fi
  # グループに紐づいてるAdmin権限もチェックする
  groups=$(aws iam --profile ${PROFILE} list-groups-for-user --user-name $user_name | jq -r '.Groups[].GroupName')
  for group in $groups; do
    list=$(aws iam --profile ${PROFILE} list-attached-group-policies --group-name $group --query 'AttachedPolicies[].PolicyArn')
    for policy in $list; do
      if [ "$(echo $policy | grep AdministratorAccess)" ]; then
        # AdministratorAccessを持ったユーザー
        echo "$AWS_ACCOUNT_ID - $user_name has AdministratorAccess"
        ADMIN_USERS+=($user_name)
      fi
    done
  done
done

# MFAが有効になってるかのチェック
for admin_user in ${ADMIN_USERS[@]}; do
  len=$(aws iam --profile ${PROFILE} list-mfa-devices --user-name $admin_user | jq -r '.MFADevices | length')
  if [ $len == "0" ]; then
    # MFAデバイスの紐づきが無い
    echo "$AWS_ACCOUNT_ID - $admin_user do NOT have MFA Devices"
    WARNING_USERS+=($admin_user)
  else
    # ユーザーに最低一つのMFAデバイスが紐づいてる
    echo "$AWS_ACCOUNT_ID - $admin_user has MFA Devices"
  fi
done

echo "------------!!Warning!!------------"
for i in ${WARNING_USERS[@]}; do
  echo $i
done
