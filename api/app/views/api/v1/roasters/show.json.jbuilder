json.partial! 'api/v1/roasters/roaster', roaster: @roaster
json.followers_count @roaster.followers.length
