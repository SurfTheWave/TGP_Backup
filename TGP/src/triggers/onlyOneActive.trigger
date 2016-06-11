/*
Name : onlyOneActive 
Description : This trigger will deactivate other active version if current version is made active
Author :  Nilesh Adkar

Updated by        Update date        User story
-----------    ------------------  --------------

*/

trigger onlyOneActive on MEC_Post_Contract_Version__c (after insert, after update) 
{
    MOB_MakeMECQnsVersionActive.makeVersionActive(Trigger.new);
}