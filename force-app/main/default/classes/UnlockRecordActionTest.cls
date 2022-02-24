@isTest(isParallel=true)
private without sharing class UnlockRecordActionTest {

    @isTest
    private static void unlockRecord_singleRecord_onValidId() {
        Account theAccount = new Account (Name = 'The Great Northern');
        insert theAccount;

        UnlockRecordAction.UnlockRequest request = new UnlockRecordAction.UnlockRequest();
        request.recordId = theAccount.Id;

        List<UnlockRecordAction.UnlockRequest> requests = new List<UnlockRecordAction.UnlockRequest>();
        requests.add(request);

        System.assertEquals(false, Approval.isLocked(theAccount.Id), 'The test data was created locked.');
        Approval.lock(theAccount.Id);
        System.assertEquals(true, Approval.isLocked(theAccount.Id), 'The test data was not locked before we tried to unlock it.');

        Test.startTest();
        List<UnlockRecordAction.UnlockResult> results = UnlockRecordAction.unlockRecords(requests);
        Test.stopTest();

        System.assertEquals(1, results.size(), 'UnlockRecordAction returns results with unexpected cardinality.');
        UnlockRecordAction.UnlockResult result = results[0];

        System.assertEquals(false, Approval.isLocked(theAccount.Id), 'UnlockRecordAction is not unlocking a record as expected.');
        System.assertEquals(true, result.isSuccess, 'UnlockRecordAction is not returning the status of the operation as expected.');
        System.assertEquals(theAccount.Id, result.recordId, 'UnlockRecordAction is not returning the record ID as expected.');
    }

    @isTest
    private static void unlockResult_noArgConstructor() {
        UnlockRecordAction.UnlockResult unlockResult = new UnlockRecordAction.UnlockResult();
        System.assertNotEquals(null, unlockResult, 'The no-argument constructor for UnlockResult is not initializing an instance properly.');
    }
}
