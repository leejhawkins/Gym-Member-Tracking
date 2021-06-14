/*
    Created by Simon Sawyer
    Determines the Fitness Level of a given Member based upon the given Benchmark
    Uses standards from StrengthLevel.com stored as Static Resources
*/

public class LiftStandardsController {
  //Verify that weight falls into proper range and use other methods to determine level in each lift
  public static String getFitnessLevel(Member__c m) {
    if (m.Weight__c == null) {
      return 'Beginner';
    }
    if (m.Gender__c == 'Female') {
      if (m.Weight__c < 90 || m.Weight__c > 260) {
        return 'Beginner';
      }
    } else {
      if (m.Weight__c < 110 || m.Weight__c > 310) {
        return 'Beginner';
      }
    }

    Integer bpLevel = getBenchPressLevel(m);
    Integer bsLevel = getBackSquatLevel(m);
    Integer dlLevel = getDeadliftLevel(m);
    Integer spLevel = getShoulderPressLevel(m);
    if ((bpLevel <= 1) || (bsLevel <= 1) || (dlLevel <= 1) || (spLevel <= 1)) {
      return 'Beginner';
    }
    if ((bpLevel <= 2) || (bsLevel <= 2) || (dlLevel <= 2) || (spLevel <= 2)) {
      return 'Novice';
    }
    if ((bpLevel <= 3) || (bsLevel <= 3) || (dlLevel <= 3) || (spLevel <= 3)) {
      return 'Intermediate';
    }
    if ((bpLevel <= 4) || (bsLevel <= 4) || (dlLevel <= 4) || (spLevel <= 4)) {
      return 'Advanced';
    }
    if ((bpLevel == 5) && (bsLevel == 5) && (dlLevel == 5) && (spLevel == 5)) {
      return 'Elite';
    } else {
      return 'Beginner';
    }
  }

  //Creates a map using the appropriate JSON file. Keys represent a Fitness Level and a Weight. Values represent the Weight required to reach that Fitness Level
  public static Map<String, Integer> createMap(String resourceName) {
    Map<String, Integer> resourceMap = new Map<String, Integer>();
    StaticResource sr = [
      SELECT Id, Body
      FROM StaticResource
      WHERE Name = :resourceName
      LIMIT 1
    ];
    String body = sr.Body.toString();
    body = body.substring(body.indexOf('{') + 1, body.lastIndexOf('}') - 2);
    List<String> pairList = body.split(',');
    String key;
    Integer val;
    for (String pair : pairList) {
      key = pair.substring(pair.indexOf('"') + 1, pair.lastIndexOf('"'));
      val = Integer.valueOf(pair.substring(pair.indexOf(':') + 2));
      resourceMap.put(key, val);
    }
    return resourceMap;
  }
  //Returns numeric representation of Fitness Level for this lift from 1 (Beginner) to 5 (Elite)
  public static Integer getBenchPressLevel(Member__c m) {
    if (m.Gender__c == 'Female') {
      Map<String, Integer> standards = createMap('FemaleBenchPressStandards');
      Decimal w = m.Weight__c / 10;
      Integer weight = w.round().intValue() * 10;
      if (m.Bench_Press__c < standards.get('Novice ' + weight)) {
        return 1;
      }
      if (m.Bench_Press__c < standards.get('Intermediate ' + weight)) {
        return 2;
      }
      if (m.Bench_Press__c < standards.get('Advanced ' + weight)) {
        return 3;
      }
      if (m.Bench_Press__c < standards.get('Elite ' + weight)) {
        return 4;
      }
      return 5;
    } else {
      Map<String, Integer> standards = createMap('MaleBenchPressStandards');
      Decimal w = m.Weight__c / 10;
      Integer weight = w.round().intValue() * 10;
      if (m.Bench_Press__c < standards.get('Novice ' + weight)) {
        return 1;
      }
      if (m.Bench_Press__c < standards.get('Intermediate ' + weight)) {
        return 2;
      }
      if (m.Bench_Press__c < standards.get('Advanced ' + weight)) {
        return 3;
      }
      if (m.Bench_Press__c < standards.get('Elite ' + weight)) {
        return 4;
      }
      return 5;
    }
  }
  //Returns numeric representation of Fitness Level for this lift from 1 (Beginner) to 5 (Elite)
  public static Integer getBackSquatLevel(Member__c m) {
    if (m.Gender__c == 'Female') {
      Map<String, Integer> standards = createMap('FemaleBackSquatStandards');
      Decimal w = m.Weight__c / 10;
      Integer weight = w.round().intValue() * 10;
      if (m.Back_Squat__c < standards.get('Novice ' + weight)) {
        return 1;
      }
      if (m.Back_Squat__c < standards.get('Intermediate ' + weight)) {
        return 2;
      }
      if (m.Back_Squat__c < standards.get('Advanced ' + weight)) {
        return 3;
      }
      if (m.Back_Squat__c < standards.get('Elite ' + weight)) {
        return 4;
      }
      return 5;
    } else {
      Map<String, Integer> standards = createMap('MaleBackSquatStandards');
      Decimal w = m.Weight__c / 10;
      Integer weight = w.round().intValue() * 10;
      if (m.Back_Squat__c < standards.get('Novice ' + weight)) {
        return 1;
      }
      if (m.Back_Squat__c < standards.get('Intermediate ' + weight)) {
        return 2;
      }
      if (m.Back_Squat__c < standards.get('Advanced ' + weight)) {
        return 3;
      }
      if (m.Back_Squat__c < standards.get('Elite ' + weight)) {
        return 4;
      }
      return 5;
    }
  }
  //Returns numeric representation of Fitness Level for this lift from 1 (Beginner) to 5 (Elite)
  public static Integer getDeadliftLevel(Member__c m) {
    if (m.Gender__c == 'Female') {
      Map<String, Integer> standards = createMap('FemaleDeadliftStandards');
      Decimal w = m.Weight__c / 10;
      Integer weight = w.round().intValue() * 10;
      if (m.Deadlift__c < standards.get('Novice ' + weight)) {
        return 1;
      }
      if (m.Deadlift__c < standards.get('Intermediate ' + weight)) {
        return 2;
      }
      if (m.Deadlift__c < standards.get('Advanced ' + weight)) {
        return 3;
      }
      if (m.Deadlift__c < standards.get('Elite ' + weight)) {
        return 4;
      }
      return 5;
    } else {
      Map<String, Integer> standards = createMap('MaleDeadliftStandards');
      Decimal w = m.Weight__c / 10;
      Integer weight = w.round().intValue() * 10;
      if (m.Deadlift__c < standards.get('Novice ' + weight)) {
        return 1;
      }
      if (m.Deadlift__c < standards.get('Intermediate ' + weight)) {
        return 2;
      }
      if (m.Deadlift__c < standards.get('Advanced ' + weight)) {
        return 3;
      }
      if (m.Deadlift__c < standards.get('Elite ' + weight)) {
        return 4;
      }
      return 5;
    }
  }
  //Returns numeric representation of Fitness Level for this lift from 1 (Beginner) to 5 (Elite)
  public static Integer getShoulderPressLevel(Member__c m) {
    if (m.Gender__c == 'Female') {
      Map<String, Integer> standards = createMap(
        'FemaleShoulderPressStandards'
      );
      Decimal w = m.Weight__c / 10;
      Integer weight = w.round().intValue() * 10;
      if (m.Shoulder_Press__c < standards.get('Novice ' + weight)) {
        return 1;
      }
      if (m.Shoulder_Press__c < standards.get('Intermediate ' + weight)) {
        return 2;
      }
      if (m.Shoulder_Press__c < standards.get('Advanced ' + weight)) {
        return 3;
      }
      if (m.Shoulder_Press__c < standards.get('Elite ' + weight)) {
        return 4;
      }
      return 5;
    } else {
      Map<String, Integer> standards = createMap('MaleShoulderPressStandards');
      Decimal w = m.Weight__c / 10;
      Integer weight = w.round().intValue() * 10;
      if (m.Shoulder_Press__c < standards.get('Novice ' + weight)) {
        return 1;
      }
      if (m.Shoulder_Press__c < standards.get('Intermediate ' + weight)) {
        return 2;
      }
      if (m.Shoulder_Press__c < standards.get('Advanced ' + weight)) {
        return 3;
      }
      if (m.Shoulder_Press__c < standards.get('Elite ' + weight)) {
        return 4;
      }
      return 5;
    }
  }
  @AuraEnabled(cacheable=true)
  public static Member__c getNextLevel(
    String fitnessLevel,
    String gender,
    Decimal weight
  ) {
    Decimal w = weight != null ? weight / 10 : 15;
    Integer memberWeight = w.round().intValue() * 10;
    Member__c nextLevel = new Member__c();
    List<List<String>> liftList = new List<List<String>>{
      new List<String>{
        'FemaleBenchPressStandards',
        'MaleBenchPressStandards',
        'Bench_Press__c'
      },
      new List<String>{
        'FemaleBackSquatStandards',
        'MaleBackSquatStandards',
        'Back_Squat__c'
      },
      new List<String>{
        'FemaleDeadliftStandards',
        'MaleDeadliftStandards',
        'Deadlift__c'
      },
      new List<String>{
        'FemaleShoulderPressStandards',
        'MaleShoulderPressStandards',
        'Shoulder_Press__c'
      }
    };
    switch on fitnessLevel {
      when 'Beginner' {
        nextLevel.Fitness_Level__c = 'Novice';
      }
      when 'Novice' {
        nextLevel.Fitness_Level__c = 'Intermediate';
      }
      when 'Intermediate' {
        nextLevel.Fitness_Level__c = 'Advanced';
      }
      when 'Advanced' {
        nextLevel.Fitness_Level__c = 'Elite';
      }
      when 'Elite' {
        nextLevel.Fitness_Level__c = 'Elite';
      }
      when else {
        nextLevel.Fitness_Level__c = 'Novice';
      }
    }
    for (List<String> lift : liftList) {
      if (gender == 'Female') {
        Map<String, Integer> standards = createMap(lift[0]);
        nextLevel.put(
          lift[2],
          standards.get(nextLevel.Fitness_Level__c + ' ' + memberWeight)
        );
      } else {
        Map<String, Integer> standards = createMap(lift[1]);
        nextLevel.put(
          lift[2],
          standards.get(nextLevel.Fitness_Level__c + ' ' + memberWeight)
        );
      }
    }
    return nextLevel;
  }
}
