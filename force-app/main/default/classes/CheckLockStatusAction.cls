/**
* @author Andrés Catalán
* @date 2022-02-22
*
* @description Apex action that enables Flow developers to declaratively check if certain records are locked.
*/
public without sharing class CheckLockStatusAction {

    /**
    * @description Checks whether records are locked, given their record IDs
    * @param requests list of instances of the StatusCheckRequest inner class containing the IDs of the records to check
    * @return list of instances of the StatusCheckResult inner class with the results of the check
    */
    @InvocableMethod(
        label='Check Lock Status' 
        description='Checks the lock status of the record specified by the record ID.' 
        category='Approvals'
    )
    public static List<StatusCheckResult> checkRecords(List<StatusCheckRequest> requests) {
        List<StatusCheckResult> results = new List<StatusCheckResult>();
        Set<Id> recordIds = new Set<Id>();

        for (StatusCheckRequest thisRequest : requests) {
            if (thisRequest.recordId != null) {
                recordIds.add(thisRequest.recordId);
            }
        }

        Map<Id,Boolean> statusCheckResults = Approval.isLocked(new List<Id>(recordIds));

        for (Id thisRecordId : statusCheckResults.keySet()) {
            results.add(new StatusCheckResult(thisRecordId, statusCheckResults.get(thisRecordId)));
        }

        return results;
    }


    /**
    * @description Invocable inner class to encapsulate the ID of a record to be checked
    */
    public class StatusCheckRequest {

        /**
        * @description ID of the record to be checked
        */
        @InvocableVariable(
            label='Record ID' 
            description='ID of the record to be checked' 
            required=true
        )
        public Id recordId;
    }


    /**
    * @description Invocable inner class to encapsulate the results of a status check
    */
    public class StatusCheckResult {

        /**
        * @description ID of the record checked
        */
        @InvocableVariable(
            label='Record ID' 
            description='ID of the record checked' 
        )
        public Id recordId;

        /**
        * @description Boolean that denotes that the associated record is locked
        */
        @InvocableVariable(
            label='Locked?'
            description='True if the record is locked'
        )
        public Boolean isLocked;

        /**
        * @description No-argument constructor for the invocable variable that represents the results
        */
        public StatusCheckResult() {
            this.recordId = null;
            this.isLocked = false;
        }

        /**
        * @description Parametrized constructor for the invocable variable that represents the results
        */
        public StatusCheckResult(Id recordId, Boolean isLocked) {
            this.recordId = recordId;
            this.isLocked = isLocked;
        }
    }
}
