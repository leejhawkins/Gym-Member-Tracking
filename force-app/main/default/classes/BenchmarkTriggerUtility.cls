public inherited sharing class BenchmarkTriggerUtility {
    
    public static void fitnessLevel(List<Benchmark__c> bens){
        List<Member__c> members = [SELECT Id, Gender__c FROM Member__c WHERE Active__c = TRUE];
        Map<Benchmark__c, Member__c> bmMap = new Map<Benchmark__c, Member__c>();
        for(Benchmark__c b : bens){
            for(Member__c m : members){
                if(b.Member__c == m.Id){
                    bmMap.put(b, m);
                }
            }
        }
        for (Benchmark__c b:bens){
            b.Fitness_Level__c = LiftStandardsController.getFitnessLevel(b, m);
        }
    }
    public static void BMICalculator(List<Benchmark__c> bens){
        for(Benchmark__c b:bens){
            Member__c m = [Select Height_Feet__c,Height_Inches__c from Member__c where Id=:b.Member__c];
            Double weightInKilos = b.Weight__c * 0.453592;
            Double heightInMeters = (((m.Height_Feet__c * 12) + m.Height_Inches__c)* .0254);
            Double bmi = weightInKilos / (heightInMeters * heightInMeters);
            b.BMI__c = bmi; 
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
