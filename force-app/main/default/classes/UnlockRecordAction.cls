/**
* @author Andrés Catalán
* @date 2022-02-22
*
* @description Apex action that enables Flow developers to declaratively lock records on demand.
*/
public without sharing class UnlockRecordAction {

    /**
    * @description Unlocks records given their record IDs
    * @param requests list of instances of the UnlockRequest inner class containing the IDs of the records to unlock
    * @return list of instances of the UnlockResult inner class with the results of the unlock operation
    */
    @InvocableMethod(
        label='Unlock Record' 
        description='Unlocks the record specified by the record ID.' 
        category='Approvals'
    )
    public static List<UnlockResult> unlockRecords(List<UnlockRequest> requests) {
        List<UnlockResult> results = new List<UnlockResult>();
        Set<Id> recordIds = new Set<Id>();

        for (UnlockRequest thisRequest : requests) {
            if (thisRequest.recordId != null) {
                recordIds.add(thisRequest.recordId);
            }
        }

        List<Approval.UnlockResult> approvalResults = Approval.unlock(new List<Id>(recordIds));

        for (Approval.UnlockResult thisApprovalResult : approvalResults) {
            results.add(new UnlockResult(thisApprovalResult));
        }

        return results;
    }


    /**
    * @description Invocable inner class to encapsulate the ID of a record to be unlocked
    */
    public class UnlockRequest {

        /**
        * @description ID of the record to be unlocked
        */
        @InvocableVariable(
            label='Record ID' 
            description='ID of the record to be unlocked' 
            required=true
        )
        public Id recordId;
    }


    /**
    * @description Invocable inner class to encapsulate the results of an unlock operation
    */    
    public class UnlockResult {

        /**
        * @description ID of the record to be unlocked
        */
        @InvocableVariable(
            label='Record ID' 
            description='ID of the record to be unlocked' 
        )
        public Id recordId;

        /**
        * @description Boolean that denotes that the unlock operation has been successful
        */
        @InvocableVariable(
            label='Successful?'
            description='True if the unlock has been successful'
        )
        public Boolean isSuccess;

        /**
        * @description No-argument constructor for the invocable variable that represents the results
        */
        public UnlockResult() {
            this.recordId = null;
            this.isSuccess = false;
        }

        /**
        * @description Parametrized constructor for the invocable variable that represents the results, based on the results of the lock operation
        */
        public UnlockResult(Approval.UnlockResult approvalResult) {
            this.recordId = approvalResult.getId();
            this.isSuccess = approvalResult.isSuccess();
        }
    }
}
