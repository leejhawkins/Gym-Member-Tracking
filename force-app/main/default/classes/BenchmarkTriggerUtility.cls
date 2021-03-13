public inherited sharing class BenchmarkTriggerUtility {
    public static void setBenchmarkEmptyFields(List<Benchmark__c> bens){
        for(Benchmark__c b:bens){
            try{
                b.Date__c = b.Date__c == null ? Date.Today() : b.Date__c;
                List<Benchmark__c> mRecent = [SELECT Deadlift__c,Back_Squat__c,Bench_Press__c,Shoulder_Press__c,Weight__c FROM Benchmark__c 
                                    WHERE Date__c <: b.Date__c AND Member__c =: b.Member__c AND Goal_Benchmarks__c=false
                                    ORDER BY Date__c DESC
                                    LIMIT 1];
                if(mRecent.size() != 0) {
                    b.Deadlift__c = b.Deadlift__c == null ? mRecent[0].Deadlift__c:b.Deadlift__c;
                    b.Back_Squat__c = b.Back_Squat__c == null ? mRecent[0].Back_Squat__c:b.Back_Squat__c;
                    b.Bench_Press__c = b.Bench_Press__c == null ? mRecent[0].Bench_Press__c:b.Bench_Press__c;
                    b.Shoulder_Press__c = b.Shoulder_Press__c == null ? mRecent[0].Shoulder_Press__c:b.Shoulder_Press__c;
                    b.Weight__c = b.Weight__c == null ? mRecent[0].Weight__c : b.weight__c;
                }
               
            } catch (QueryException e) {
                throw new AuraHandledException(e.getMessage());
            }
        
        }
    }
    
    public static void fitnessLevel(List<Benchmark__c> bens){
        List<Member__c> members = [SELECT Id, Weight__c, Gender__c FROM Member__c WHERE Active__c = TRUE];
        Map<Benchmark__c, Member__c> bmMap = new Map<Benchmark__c, Member__c>();
        for(Benchmark__c b : bens){
            for(Member__c m : members){
                if(b.Member__c == m.Id){
                    bmMap.put(b, m);
                }
            }
        }
        for (Benchmark__c b:bens){
            b.Fitness_Level__c = LiftStandardsController.getFitnessLevel(b, bmMap.get(b));
        }
    }
    public static void BMICalculator(List<Benchmark__c> bens){
        for(Benchmark__c b:bens){
            if(b.Weight__c != null){
                Member__c m = [Select Height_Feet__c,Height_Inches__c from Member__c where Id=:b.Member__c];
                if(m.Height_Feet__c != null && m.Height_Inches__c != null){
                    Double weightInKilos = b.Weight__c * 0.453592;
                    Double heightInMeters = (((m.Height_Feet__c * 12) + m.Height_Inches__c)* .0254);
                    Double bmi = weightInKilos / (heightInMeters * heightInMeters);
                    b.BMI__c = bmi; 
                }
            }
        }
        
    }
    public static void isGoalBenchmark(List<Benchmark__c> bens) {
        for(Benchmark__c b:bens){
            if(b.Goal_Benchmarks__c){
                Member__c m = [Select Id from Member__c Where Id=:b.Member__c];
                //m.Goal_Benchmark__c = b.Id;
                update m;
            }
        }
    }
    public static void isCurrentBenchmark(List<Benchmark__c> bens) {
        for(Benchmark__c b:bens){
            if(b.Date__c >= Date.Today().toStartofMonth() && b.Date__c < Date.Today().addMonths(1).toStartofMonth()){
                Member__c m = [Select Id from Member__c Where Id=:b.Member__c];
                //m.Current_Benchmark__c = b.Id;
                m.Fitness_Level__c = b.Fitness_Level__c;
                m.BMI__c = b.BMI__c;
                update m;
            }
        }
    }
    
         
    
    
}
