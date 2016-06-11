global class DmatBatchSchedulable implements Schedulable {
    global void execute(SchedulableContext ctx) {
        DmatBatch dmatBatch = new DmatBatch();
        ID batchprocessid = Database.executeBatch(dmatBatch,200);
    }    
}