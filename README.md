# swift-firebase-sample

##### FIREBASE RULES CONFIGURATION
```
{
    "rules": {
      "users": {
        "$user_id": {
          // grants write access to the owner of this user account
          // whose uid must exactly match the key ($user_id)
          ".write": "$user_id === auth.uid"
        }
      },      
     "userObjects" : {
        "public-messages" : {
          "$user_id":{
            ".read": true,
            ".write": true
          }
        },       
        "private-messages" : {
          "$user_id":{
            ".read": "$user_id === auth.uid",
            ".write": "$user_id === auth.uid"
          }
        }
      },
    }
}
```
##### SAMPLE DATA STRUCTURE
