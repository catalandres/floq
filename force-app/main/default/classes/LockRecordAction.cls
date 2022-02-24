/**
* @author Andrés Catalán
* @date 2022-02-22
*
* @description Apex action that enables Flow developers to declaratively lock records on demand.
*/
public without sharing class LockRecordAction {

    /**
    * @description Locks records given their record IDs
    * @param requests list of instances of the LockRequest inner class containing the IDs of the records to lock
    * @return list of instances of the LockResult inner class with the results of the lock operation
    */
    @InvocableMethod(
        label='Lock Record' 
        description='Locks the record specified by the record ID.' 
        category='Approvals'
    )
    public static List<LockResult> lockRecords(List<LockRequest> requests) {
        List<LockResult> results = new List<LockResult>();
        Set<Id> recordIds = new Set<Id>();

        for (LockRequest thisRequest : requests) {
            if (thisRequest.recordId != null) {
                recordIds.add(thisRequest.recordId);
            }
        }

        List<Approval.LockResult> approvalResults = Approval.lock(new List<Id>(recordIds));

        for (Approval.LockResult thisApprovalResult : approvalResults) {
            results.add(new LockResult(thisApprovalResult));
        }

        return results;
    }


    /**
    * @description Invocable inner class to encapsulate the ID of a record to be locked
    */
    public class LockRequest {

        /**
        * @description ID of the record to be locked
        */
        @InvocableVariable(
            label='Record ID' 
            description='ID of the record to be locked' 
            required=true
        )
        public Id recordId;
    }


    /**
    * @description Invocable inner class to encapsulate the results of a lock operation
    */
    public class LockResult {

        /**
        * @description ID of the record to be locked
        */
        @InvocableVariable(
            label='Record ID' 
            description='ID of the record to be locked' 
        )
        public Id recordId;

        /**
        * @description Boolean that denotes that the lock operation has been successful
        */
        @InvocableVariable(
            label='Successful?'
            description='True if the lock has been successful'
        )
        public Boolean isSuccess;

        /**
        * @description No-argument constructor for the invocable variable that represents the results
        */
        public LockResult() {
            this.recordId = null;
            this.isSuccess = false;
        }

        /**
        * @description Parametrized constructor for the invocable variable that represents the results, based on the results of the lock operation
        */
        public LockResult(Approval.LockResult approvalResult) {
            this.recordId = approvalResult.getId();
            this.isSuccess = approvalResult.isSuccess();
        }
    }
}
