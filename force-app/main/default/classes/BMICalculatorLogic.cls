public inherited sharing class BMICalculatorLogic {
    
     public static void BMICalculator(Member__c member){

        Double weightInKilos = member.Weight__c * 0.453592;
        Double heightInMeters = (((member.Height_Feet__c * 12) + member.Height_Inches__c)* .0254);
        Double bmi = weightInKilos / (heightInMeters * heightInMeters);
        member.BMI__c = bmi;
        Benchmark__c b = [Select Id from Benchmark__c where Id =: member.Current_Benchmark__c];
        insert b;

        
    }

    public static void getAllMembers(List<Member__c> members){
        for(Member__c m: members){
                BMICalculator(m);
            }
        
    }
   /*
    public static void interpretBMI(Double bmi){
        if(bmi < 18.5){
            System.debug('Member is underweight');
        }
        if(bmi >= 18.5 && bmi < 25.0){
                System.debug('Member has a normal BMI');
            }
        if(bmi >= 25.0 && bmi < 30.0){
                System.debug('Member is above weight');
            }
        else{
            if(bmi > 30.0){
                System.debug('Member needs to speak with trainer');
            }
        }
    }
    */



    
}
