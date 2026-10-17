public class TriggerDispatcher {

    public static void handleTrigger(ITriggerHandler handler) {
        if (Trigger.isBefore && Trigger.isInsert) {
            handler.beforeInsert(Trigger.new);
        } else if (Trigger.isBefore && Trigger.isUpdate) {
            handler.beforeUpdate(Trigger.new, Trigger.oldMap);
        } else if (Trigger.isAfter && Trigger.isInsert) {
            handler.afterInsert(Trigger.new);
        } else if (Trigger.isAfter && Trigger.isUpdate) {
            handler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}