/*
    Created by Simon Sawyer
    Determines the Fitness Level of a given Member based upon the given Benchmark
    Uses standards from StrengthLevel.com stored as Static Resources
*/

public class LiftStandardsController {

    //Verify that weight falls into proper range and use other methods to determine level in each lift
    public static String getFitnessLevel(Benchmark__c b, Member__c m){
        
        if(m.Weight__c == null){
            return 'Beginner';
        }
        if(m.Gender__c == 'Female'){
            if(m.Weight__c < 90 || m.Weight__c > 260){
                return 'Beginner';
            }
        }else{
            if(m.Weight__c < 110 || m.Weight > 310){
                return 'Beginner';
            }
        }

        Integer bpLevel = getBenchPressLevel(m, b.Bench_Press__c);
        Integer bsLevel = getBackSquatLevel(m, b.Back_Squat__c);
        Integer dlLevel = getDeadliftLevel(m, b.Deadlift__c);
        Integer spLevel = getShoulderPressLevel(m, b.Shoulder_Press__c);
        if(bpLevel <= 1 || bsLevel <= 1 || dlLevel <= 1 || spLevel <= 1){
            return 'Beginner';
        }
        if(bpLevel <= 2 || bsLevel <= 2 || dlLevel <= 2 || spLevel <= 2){
            return 'Novice';
        }
        if(bpLevel <= 3 || bsLevel <= 3 || dlLevel <= 3 || spLevel <= 3){
            return 'Intermediate';
        }
        if(bpLevel <= 4 || bsLevel <= 4 || dlLevel <= 4 || spLevel <= 4){
            return 'Advanced';
        }
        return 'Elite';
    }

    //Creates a map using the appropriate JSON file. Keys represent a Fitness Level and a Weight. Values represent the Weight required to reach that Fitness Level
    public static Map<String, Integer> createMap(String resourceName){
        Map<String, Integer> resourceMap = new Map<String, Integer>();
        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name =: resourceName LIMIT 1];
        String body = sr.Body.toString();
        body = body.substring(body.indexOf('{') + 1, body.lastIndexOf('}')-2);
		List<String> pairList = body.split(',');
		String key;
		Integer val;
		for(String pair : pairList){
 		   key = pair.substring(pair.indexOf('"') + 1, pair.lastIndexOf('"'));
 		   val = Integer.valueOf(pair.substring(pair.indexOf(':') + 2));
		    resourceMap.put(key, val);
		}
        return resourceMap;
    }
    //Returns numeric representation of Fitness Level for this lift from 1 (Beginner) to 5 (Elite)
    public static Integer getBenchPressLevel(Member__c m, Decimal bp){
        if(m.Gender__c == 'Female'){
            Map<String, Integer> standards = createMap('FemaleBenchPressStandards');
            Decimal w = m.Weight__c / 10;
            Integer weight = w.round().intValue()*10;
            if(bp < standards.get('Novice ' + weight)){
                return 1;
            }
            if(bp < standards.get('Intermediate ' + weight)){
                return 2;
            }
            if(bp < standards.get('Advanced ' + weight)){
                return 3;
            }
            if(bp < standards.get('Elite ' + weight)){
                return 4;
            }
            return 5;
        }
        else{
            Map<String, Integer> standards = createMap('MaleBenchPressStandards');
            Decimal w = m.Weight__c / 10;
            Integer weight = w.round().intValue()*10;
            if(bp < standards.get('Novice ' + weight)){
                return 1;
            }
            if(bp < standards.get('Intermediate ' + weight)){
                return 2;
            }
            if(bp < standards.get('Advanced ' + weight)){
                return 3;
            }
            if(bp < standards.get('Elite ' + weight)){
                return 4;
            }
            return 5;
        }
    }
    //Returns numeric representation of Fitness Level for this lift from 1 (Beginner) to 5 (Elite)
    public static Integer getBackSquatLevel(Member__c m, Decimal bs){
        if(m.Gender__c == 'Female'){
            Map<String, Integer> standards = createMap('FemaleBackSquatStandards');
            Decimal w = m.Weight__c / 10;
            Integer weight = w.round().intValue()*10;
            if(bs < standards.get('Novice ' + weight)){
                return 1;
            }
            if(bs < standards.get('Intermediate ' + weight)){
                return 2;
            }
            if(bs < standards.get('Advanced ' + weight)){
                return 3;
            }
            if(bs < standards.get('Elite ' + weight)){
                return 4;
            }
            return 5;
        }
        else{
            Map<String, Integer> standards = createMap('MaleBackSquatStandards');
            Decimal w = m.Weight__c / 10;
            Integer weight = w.round().intValue()*10;
            if(bs < standards.get('Novice ' + weight)){
                return 1;
            }
            if(bs < standards.get('Intermediate ' + weight)){
                return 2;
            }
            if(bs < standards.get('Advanced ' + weight)){
                return 3;
            }
            if(bs < standards.get('Elite ' + weight)){
                return 4;
            }
            return 5;
        }
    }
    //Returns numeric representation of Fitness Level for this lift from 1 (Beginner) to 5 (Elite)
    public static Integer getDeadliftLevel(Member__c m, Decimal dl){
        if(m.Gender__c == 'Female'){
            Map<String, Integer> standards = createMap('FemaleDeadliftStandards');
            Decimal w = m.Weight__c / 10;
            Integer weight = w.round().intValue()*10;
            if(dl < standards.get('Novice ' + weight)){
                return 1;
            }
            if(dl < standards.get('Intermediate ' + weight)){
                return 2;
            }
            if(dl < standards.get('Advanced ' + weight)){
                return 3;
            }
            if(dl < standards.get('Elite ' + weight)){
                return 4;
            }
            return 5;
        }
        else{
            Map<String, Integer> standards = createMap('MaleDeadliftStandards');
            Decimal w = m.Weight__c / 10;
            Integer weight = w.round().intValue()*10;
            if(dl < standards.get('Novice ' + weight)){
                return 1;
            }
            if(dl < standards.get('Intermediate ' + weight)){
                return 2;
            }
            if(dl < standards.get('Advanced ' + weight)){
                return 3;
            }
            if(dl < standards.get('Elite ' + weight)){
                return 4;
            }
            return 5;
        }

    }
    //Returns numeric representation of Fitness Level for this lift from 1 (Beginner) to 5 (Elite)
    public static Integer getShoulderPressLevel(Member__c m, Decimal sp){
        if(m.Gender__c == 'Female'){
            Map<String, Integer> standards = createMap('FemaleShoulderPressStandards');
            Decimal w = m.Weight__c / 10;
            Integer weight = w.round().intValue()*10;
            if(sp < standards.get('Novice ' + weight)){
                return 1;
            }
            if(sp < standards.get('Intermediate ' + weight)){
                return 2;
            }
            if(sp < standards.get('Advanced ' + weight)){
                return 3;
            }
            if(sp < standards.get('Elite ' + weight)){
                return 4;
            }
            return 5;
        }
        else{
            Map<String, Integer> standards = createMap('MaleShoulderPressStandards');
            Decimal w = m.Weight__c / 10;
            Integer weight = w.round().intValue()*10;
            if(sp < standards.get('Novice ' + weight)){
                return 1;
            }
            if(sp < standards.get('Intermediate ' + weight)){
                return 2;
            }
            if(sp < standards.get('Advanced ' + weight)){
                return 3;
            }
            if(sp < standards.get('Elite ' + weight)){
                return 4;
            }
            return 5;
        }

    }
}