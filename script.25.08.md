
# Script 

## Introduction

    This POC was intended to see the capabilities how Hasura can solve our authorizations and  authentications necessities.

    First we can look how can looks like a basic future architecture and how this can work
    https://lucid.app/lucidchart/e359e076-008b-4c71-b67d-542b1c04475b/view?page=0_0&invitationId=inv_d4b97a82-a64d-4e58-829d-9966d90af664#

     It's important here to note the authentication and authorizations components. Now the current application contains a authentication module but not a authorization. Before advancing more in the POC and to understand better what we will see we can make sure that we are on the same page when we are talking  authentication and which providers can be used and authorization

## POC

    Status data of scenario 1 has been created
    1. Enter as admin and excute query students_user and see all the data
    2 Configure     X-Hasura-Role         user 
                    X-Hasura-User-Id      2  
    3. Execute the query to see students_user and see all the data filtered
    1. Change the user to 3 and see all the data filtered
    1. Insert the new data for scenario 2
    1. See how with the new data with user 2 changes the data wich I see
    1. Explain scenario 3
        1. Access to different fields
        1. Execute queries for scenario 3
        1. see how this doesn't change what user 2 sees but as admin I can see the new data
        1. see how the new volunteer (12)can see applicants
        1. use the new query and see how I can see the fields call, phone and email
        1. This new query cannot be used with a user with l1

## Problems

    * With the current implementation is a user can access some column, then can access this columns for all the users

    * To allow to have different columns accessible (and updatable) for different rows I need to implement different tables (students_level_1, students_level2) amd manga permission to access each of the table. This also makes the code more complicated. 
    * What we did here is to assign roles to determine which columns are accessible but this means that user A sees the same data from applicant B or C (or doesn't see it)

## Next steps

1. Authorization provider. We need to define an authorization provider. This can be oauth or another AWS provider Cognito or other, the proces for each one is different (with Auth the roles aren't free) with cognito I understand that under 50.000 operations in a month enters in a free category but this has to be checked.
  Once we decide the authorithation provider we have to implement some rules to provide Hasura with the needed claims
2. Data import. We need to import data from the current dashboard to the new progress db
3. Web POC. It would be nice to create a POC with a web app (perhaps in react) to interact with the data. But before doing this we need the authorization provider defined
