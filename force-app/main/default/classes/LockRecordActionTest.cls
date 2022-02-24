@isTest(isParallel=true)
private without sharing class LockRecordActionTest {

    @isTest
    private static void lockRecord_singleRecord_onValidId() {
        Account theAccount = new Account (Name = 'The Great Northern');
        insert theAccount;

        LockRecordAction.LockRequest request = new LockRecordAction.LockRequest();
        request.recordId = theAccount.Id;

        List<LockRecordAction.LockRequest> requests = new List<LockRecordAction.LockRequest>();
        requests.add(request);

        System.assertEquals(false, Approval.isLocked(theAccount.Id), 'The test data was locked before we tried to lock it.');

        Test.startTest();
        List<LockRecordAction.LockResult> results = LockRecordAction.lockRecords(requests);
        Test.stopTest();

        System.assertEquals(1, results.size(), 'LockRecordAction returns results with unexpected cardinality.');
        LockRecordAction.LockResult result = results[0];

        System.assertEquals(true, Approval.isLocked(theAccount.Id), 'LockRecordAction is not locking a record as expected.');
        System.assertEquals(true, result.isSuccess, 'LockRecordAction is not returning the status of the operation as expected.');
        System.assertEquals(theAccount.Id, result.recordId, 'LockRecordAction is not returning the record ID as expected.');
    }

    @isTest
    private static void lockResult_noArgConstructor() {
        LockRecordAction.LockResult lockResult = new LockRecordAction.LockResult();
        System.assertNotEquals(null, lockResult, 'The no-argument constructor for LockResult is not initializing an instance properly.');
    }
}
