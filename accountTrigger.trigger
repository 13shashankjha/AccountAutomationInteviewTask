trigger accountTrigger on Account (after insert, after update,before insert,before update) {
   AccountTriggerHandler ath = new AccountTriggerHandler();
   if(trigger.isBefore){
      ath.checkActiveCriteria(Trigger.new,Trigger.newMap);
   }
   if(trigger.isAfter && (trigger.isUpdate || trigger.isInsert)){
      ath.createDefaultContact(Trigger.new,Trigger.newMap);
   }
}