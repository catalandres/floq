@isTest(isParallel=true)
private without sharing class CheckLockStatusActionTest {

    @isTest
    private static void checkRecord_singleRecord_onLockedRecord() {
        Account theAccount = new Account (Name = 'The Great Northern');
        insert theAccount;

        CheckLockStatusAction.StatusCheckRequest request = new CheckLockStatusAction.StatusCheckRequest();
        request.recordId = theAccount.Id;

        List<CheckLockStatusAction.StatusCheckRequest> requests = new List<CheckLockStatusAction.StatusCheckRequest>();
        requests.add(request);

        System.assertEquals(false, Approval.isLocked(theAccount.Id), 'The test data was created locked.');
        Approval.lock(theAccount.Id);
        System.assertEquals(true, Approval.isLocked(theAccount.Id), 'The test data was not locked before we tried to unlock it.');

        Test.startTest();
        List<CheckLockStatusAction.StatusCheckResult> results = CheckLockStatusAction.checkRecords(requests);
        Test.stopTest();

        System.assertEquals(1, results.size(), 'CheckLockStatusAction returns results with unexpected cardinality.');
        CheckLockStatusAction.StatusCheckResult result = results[0];

        System.assertEquals(true, result.isLocked, 'CheckLockStatusAction is not returning the correct status of the record.');
        System.assertEquals(theAccount.Id, result.recordId, 'CheckLockStatusAction is not returning the record ID as expected.');
    }

    @isTest
    private static void checkRecord_singleRecord_onUnlockedRecord() {
        Account theAccount = new Account (Name = 'The Great Northern');
        insert theAccount;

        CheckLockStatusAction.StatusCheckRequest request = new CheckLockStatusAction.StatusCheckRequest();
        request.recordId = theAccount.Id;

        List<CheckLockStatusAction.StatusCheckRequest> requests = new List<CheckLockStatusAction.StatusCheckRequest>();
        requests.add(request);

        System.assertEquals(false, Approval.isLocked(theAccount.Id), 'The test data was created locked.');

        Test.startTest();
        List<CheckLockStatusAction.StatusCheckResult> results = CheckLockStatusAction.checkRecords(requests);
        Test.stopTest();

        System.assertEquals(1, results.size(), 'CheckLockStatusAction returns results with unexpected cardinality.');
        CheckLockStatusAction.StatusCheckResult result = results[0];

        System.assertEquals(false, result.isLocked, 'CheckLockStatusAction is not returning the correct status of the record.');
        System.assertEquals(theAccount.Id, result.recordId, 'CheckLockStatusAction is not returning the record ID as expected.');
    }


    @isTest
    private static void statusCheckResult_noArgConstructor() {
        CheckLockStatusAction.StatusCheckResult statusCheckResult = new CheckLockStatusAction.StatusCheckResult();
        System.assertNotEquals(null, statusCheckResult, 'The no-argument constructor for StatusCheckResult is not initializing an instance properly.');
    }
}
