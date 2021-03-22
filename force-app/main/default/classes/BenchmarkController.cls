public inherited sharing class BenchmarkController {
  @AuraEnabled(cacheable=true)
  public static Map<String, Benchmark__c> getBenchmarks(Id memberId) {
    Map<String, Benchmark__c> bens = new Map<String, Benchmark__c>();
    Member__c gender = [SELECT Gender__c FROM Member__c WHERE Id = :memberId] !=
      null
      ? [SELECT Gender__c FROM Member__c WHERE Id = :memberId]
      : new Member__c(Gender__c = 'Male');
    Benchmark__c currentBenchmark = BenchmarkTriggerUtility.getMostRecent(
      memberId,
      Date.Today()
    );
    bens.put('Current', currentBenchmark);
    Benchmark__c gb = LiftStandardsController.getNextLevel(
      currentBenchmark,
      gender.Gender__c
    );
    bens.put('Goal', gb);
    return bens;
  }
  //method used in the displayMemberBenchmark LWC
  @AuraEnabled(cacheable=true)
  public static Benchmark__c getBenchmark(Id memberId) {
    return [
      SELECT Back_Squat__c, Deadlift__c, Bench_Press__c, Shoulder_Press__c
      FROM Benchmark__c
      WHERE Member__c = :memberId AND Goal_Benchmarks__c != TRUE
      LIMIT 1
    ];
  }
  @AuraEnabled(cacheable=true)
  public static Benchmark__c getGoalBenchmark(Id memberId) {
    return [
      SELECT Back_Squat__c, Deadlift__c, Bench_Press__c, Shoulder_Press__c
      FROM Benchmark__c
      WHERE Member__c = :memberId AND Goal_Benchmarks__c = TRUE
      LIMIT 1
    ];
  }
  @AuraEnabled(cacheable=true)
  public static Map<String, List<Double>> getAnnualProgress(Id memberId) {
    Map<String, List<Double>> progressMap = new Map<String, List<Double>>();
    List<Benchmark__c> cbList = [
      SELECT Back_Squat__c, Bench_Press__c, Deadlift__c, Shoulder_Press__c
      FROM Benchmark__c
      WHERE Member__c = :memberId AND Goal_Benchmarks__c = FALSE
      ORDER BY Date__c
    ];
    Benchmark__c gb = [
      SELECT
        Back_Squat__c,
        Bench_Press__c,
        Deadlift__c,
        Shoulder_Press__c,
        Date__c
      FROM Benchmark__c
      WHERE Member__c = :memberId AND Goal_Benchmarks__c = TRUE
      LIMIT 1
    ];
    List<Double> bpProgress = new List<Double>();
    List<Double> bsProgress = new List<Double>();
    List<Double> dlProgress = new List<Double>();
    List<Double> spProgress = new List<Double>();
    for (Benchmark__c b : cbList) {
      bpProgress.add(b.Bench_Press__c / gb.Bench_Press__c);
      bsProgress.add(b.Back_Squat__c / gb.Back_Squat__c);
      dlProgress.add(b.Deadlift__c / gb.Deadlift__c);
      spProgress.add(b.Shoulder_Press__c / gb.Shoulder_Press__c);
    }
    progressMap.put('Bench Press', bpProgress);
    progressMap.put('Back Squat', bsProgress);
    progressMap.put('Deadlift', dlProgress);
    progressMap.put('Shoulder Press', spProgress);
    return progressMap;
  }
  @AuraEnabled(cacheable=true)
  public static Map<String, List<Benchmark__c>> getMonthlyProgress(
    Id memberId
  ) {
    Map<String, List<Benchmark__c>> progressMap = new Map<String, List<Benchmark__c>>();
    List<Benchmark__c> cbList = [
      SELECT
        Back_Squat__c,
        Bench_Press__c,
        Deadlift__c,
        Shoulder_Press__c,
        Date__c
      FROM Benchmark__c
      WHERE
        Member__c = :memberId
        AND Date__c >= :Date.today().toStartOfMonth()
        AND Goal_Benchmarks__c = FALSE
      ORDER BY Date__c
    ];
    List<Benchmark__c> gb = [
      SELECT Back_Squat__c, Bench_Press__c, Deadlift__c, Shoulder_Press__c
      FROM Benchmark__c
      WHERE Member__c = :memberId AND Goal_Benchmarks__c = TRUE
      LIMIT 1
    ];

    progressMap.put('Goal', gb);
    progressMap.put('Benchmarks', cbList);
    System.debug(progressMap.get('Benchmarks'));
    return progressMap;
  }
  @AuraEnabled(cacheable=true)
  public static List<String> getMembershipMonths(Id memberId) {
    List<String> membershipMonths = new List<String>();
    List<Benchmark__c> cbList = [
      SELECT Date__c
      FROM Benchmark__c
      WHERE Member__c = :memberId AND Goal_Benchmarks__c = FALSE
      ORDER BY Date__c
    ];
    for (Benchmark__c b : cbList) {
      String monthYear = b.Date__c.month() + '/' + b.Date__c.year();
      membershipMonths.add(monthYear);
    }
    return membershipMonths;
  }
  @AuraEnabled(cacheable=true)
  public static List<String> getMonthlyBenchmarkDates(Id memberId) {
    List<String> benchmarkDates = new List<String>();
    List<Benchmark__c> cbList = [
      SELECT Date__c
      FROM Benchmark__c
      WHERE Member__c = :memberId AND Goal_Benchmarks__c = FALSE
      ORDER BY Date__c
    ];
    for (Benchmark__c b : cbList) {
      if (b.Date__c <= Date.today().addMonths(-1)) {
        String monthYear = b.Date__c.month() + '/' + b.Date__c.year();
        benchmarkDates.add(monthYear);
      }
    }
    return benchmarkDates;
  }
}
