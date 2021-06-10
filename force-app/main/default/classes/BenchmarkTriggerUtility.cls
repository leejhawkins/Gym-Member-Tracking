public inherited sharing class BenchmarkTriggerUtility {
  public static void setBenchmarkEmptyFields(List<Benchmark__c> bens) {
    for (Benchmark__c b : bens) {
      try {
        b.Date__c = b.Date__c == null ? Date.Today() : b.Date__c;
        Benchmark__c mRecent = BenchmarkTriggerUtility.getMostRecent(
          b.Member__c,
          b.Date__c
        );

        b.Deadlift__c = b.Deadlift__c == null
          ? mRecent.Deadlift__c
          : b.Deadlift__c;
        b.Back_Squat__c = b.Back_Squat__c == null
          ? mRecent.Back_Squat__c
          : b.Back_Squat__c;
        b.Bench_Press__c = b.Bench_Press__c == null
          ? mRecent.Bench_Press__c
          : b.Bench_Press__c;
        b.Shoulder_Press__c = b.Shoulder_Press__c == null
          ? mRecent.Shoulder_Press__c
          : b.Shoulder_Press__c;
        b.Weight__c = b.Weight__c == null ? mRecent.Weight__c : b.weight__c;
      } catch (QueryException e) {
        throw new AuraHandledException(e.getMessage());
      }
    }
  }

  public static void fitnessLevel(List<Benchmark__c> bens) {
    List<Member__c> members = [
      SELECT Id, Weight__c, Gender__c
      FROM Member__c
      WHERE Active__c = TRUE
    ];
    Map<Benchmark__c, Member__c> bmMap = new Map<Benchmark__c, Member__c>();
    for (Benchmark__c b : bens) {
      for (Member__c m : members) {
        if (b.Member__c == m.Id) {
          bmMap.put(b, m);
        }
      }
    }
    for (Benchmark__c b : bens) {
      b.Fitness_Level__c = LiftStandardsController.getFitnessLevel(
        bmMap.get(b)
      );
    }
  }
  public static void BMICalculator(List<Benchmark__c> bens) {
    for (Benchmark__c b : bens) {
      if (b.Weight__c != null) {
        Member__c m = [
          SELECT Height_Feet__c, Height_Inches__c
          FROM Member__c
          WHERE Id = :b.Member__c
        ];
        if (m.Height_Feet__c != null && m.Height_Inches__c != null) {
          Double weightInKilos = b.Weight__c * 0.453592;
          Double heightInMeters = (((m.Height_Feet__c * 12) +
          m.Height_Inches__c) * .0254);
          Double bmi = weightInKilos / (heightInMeters * heightInMeters);
          b.BMI__c = bmi;
        }
      }
    }
  }
  public static void isCurrentBenchmark(List<Benchmark__c> bens) {
    for (Benchmark__c b : bens) {
      Benchmark__c mRecent = BenchmarkTriggerUtility.getMostRecent(
        b.Member__c,
        Date.today()
      );
      if (mRecent.Id == b.id) {
        Member__c m = [
          SELECT Id, Fitness_Level__c, Name, Email__c, Gender__c
          FROM Member__c
          WHERE Id = :b.Member__c
        ];
        String oldFitnessLevel = m.Fitness_Level__c;
        m.Fitness_Level__c = b.Fitness_Level__c;
        m.Current_Benchmark__c = b.Id;
        if (
          (oldFitnessLevel == 'Beginner' &&
          (m.Fitness_Level__c == 'Novice' ||
          m.Fitness_Level__c == 'Intermediate' ||
          m.Fitness_Level__c == 'Advanced' ||
          m.Fitness_Level__c == 'Elite')) ||
          (oldFitnessLevel == 'Novice' &&
          (m.Fitness_Level__c == 'Intermediate' ||
          m.Fitness_Level__c == 'Advanced' ||
          m.Fitness_Level__c == 'Elite')) ||
          (oldFitnessLevel == 'Intermediate' &&
          (m.Fitness_Level__c == 'Advanced' ||
          m.Fitness_Level__c == 'Elite')) ||
          (oldFitnessLevel == 'Advanced' &&
          m.Fitness_Level__c == 'Elite')
        ) {
          Member__c nextLevel = LiftStandardsController.getNextLevel(
            m.Fitness_Level__c,
            m.Gender__c,
            b.Weight__c
          );
          if (m.Email__c != null) {
            EmailController.sendCongratulationsEmail(
              m.Name,
              m.Email__c,
              oldFitnessLevel,
              b.Fitness_Level__c,
              nextLevel
            );
          }
        }
        m.BMI__c = b.BMI__c;
        update m;
      }
    }
  }
  public static Benchmark__c getMostRecent(Id memberId, Date targetDate) {
    Integer count = (Integer) [
      SELECT COUNT()
      FROM Benchmark__c
      WHERE
        Date__c <= :targetDate
        AND Member__c = :memberId
        AND Goal_Benchmarks__c = FALSE
    ];
    List<Benchmark__c> recentBs = new List<Benchmark__c>();
    Benchmark__c currentBenchmark = new Benchmark__c(
      Back_Squat__c = 0,
      Deadlift__c = 0,
      Bench_Press__c = 0,
      Shoulder_Press__c = 0,
      Weight__c = 150
    );
    if (count > 0) {
      recentBs = [
        SELECT
          Deadlift__c,
          Back_Squat__c,
          Bench_Press__c,
          Shoulder_Press__c,
          Weight__c,
          Date__c,
          Name,
          LastModifiedDate,
          Fitness_Level__c,
          Id
        FROM Benchmark__c
        WHERE
          Date__c <= :targetDate
          AND Member__c = :memberId
          AND Goal_Benchmarks__c = FALSE
        ORDER BY Date__c DESC
        LIMIT 10
      ];
      date recentDate = targetDate.addYears(-1);
      Datetime recentModified = Datetime.now().addYears(-1);
      for (Benchmark__c b : recentBs) {
        if (b.Date__c >= recentDate && b.LastModifiedDate > recentModified) {
          recentDate = b.Date__c;
          recentModified = b.LastModifiedDate;
          currentBenchmark = b;
        }
      }
    }
    return currentBenchmark;
  }
}
