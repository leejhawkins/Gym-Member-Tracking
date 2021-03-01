public inherited sharing class BenchmarkTriggerUtility {
    
    public static void fitnessLevel(List<Benchmark__c> bens){
        for (Benchmark__c b:bens){
            Double w = b.Weight__c;
            Double bp = b.Bench_Press__c;
            Double bs = b.Back_Squat__c;
            Double dl = b.Deadlift__c;
            Double sp = b.Shoulder_Press__c;
            if( bp > w*1.5 && bs > w*2.0 && dl > w*2.5 && sp > w ){
                b.Fitness_Level__c = 'Elite';
            } else if( bp > w*1.25 && bs > w*1.75 && dl > w*2.25 && sp >.75* w ){
                b.Fitness_Level__c = 'Advanced';
            }  else if( bp > w && bs > w*1.50 && dl > w*2 && sp >.60* w ){
                b.Fitness_Level__c = 'Intermediate';
            }  else {
                b.Fitness_Level__c = 'Beginner';
            }
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
                m.Goal_Benchmark__c = b.Id;
                update m;
            }
        }
    }
    public static void isCurrentBenchmark(List<Benchmark__c> bens) {
        for(Benchmark__c b:bens){
            if(b.Date__c > Date.Today().toStartofMonth() && b.Date__c < Date.Today().addMonths(1).toStartofMonth()){
                Member__c m = [Select Id from Member__c Where Id=:b.Member__c];
                m.Current_Benchmark__c = b.Id;
                m.Fitness_Level__c = b.Fitness_Level__c;
                update m;
            }
        }
    }
    
         
    
    
}
