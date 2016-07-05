# SeaUsers http interface
### Registration
**/register** - register new user.  
POST request with body JSON:

    {
        "email" : "EmailOrOther",
        "name" : "Name",
        "lang" : "Lang"
    }
Where `email` can be email (containing `@`) or other string. In case of email - 
generated password will be sent to this email. If other string provided - 
password will be returned in reply.  
`name` is user's name, to which email will be send. Is **optional**.  
`lang` is users preferred localization of email to send. Is **optional**.  

Success reply:  

    {
        "result" : true, "password" : "Pass", "code" : 0, "uid" : "UserId"
    }
or

    {
        "result" : true, "code" : 0, "uid" : "UserId"
    }
Error reply:

    {
        "result" : false, "code" : 101
    }   

### Authorisation
**/login** is two phase authorization.

##### First step
POST request with body JSON:

    {
        "uid" : "UserId"
    }
Where `uid` is unique user id, obtained from register user request.  
Success reply:  

    {
        "result" : true,
        "salt" : "SALT",
        "secret_len" : 10,
        "secret_iter" : 100,
        "code" : 0
    }
    
Error reply:

    {
        "result" : false,
        "code" : 500
    }

##### Second step
POST request with body JSON:

    {
        "uid" : "UserId",
        "secret" : "Secret",
        "token" : "Token"
    }
Where `uid` is same user identifier, as in step 1,  
`secret` is user calculated secret,  
`token` is user's token to be registerd for uid.  
Success reply:

    {
        "result" : true,
        "salt" : "SALT",
        "secret_len" : 10,
        "secret_iter" : 100,
        "code" : 0
    }
Error reply:

    {
        "result" : false,
        "code" : 100
    }