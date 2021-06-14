/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-14-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   06-04-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public inherited sharing class MemberTriggerUtility {
   /*
    public static void lookupOnInsert(List<Contact> members){
        for(Contact m : members){
            if(m.Goal_Benchmark__c != null){
                m.Goal_Benchmark__c.addError('You may not assign a Benchmark to a Member that is not in the system yet');
            }if(m.Current_Benchmark__c != null){
                m.Current_Benchmark__c.addError('You may not assign a Benchmark to a Member that is not in the system yet');
            }
        }
    }
    
    public static void checkAssignment(List<Contact> members){
        for(Contact m : members){
            if(m.Goal_Benchmark__c != null){
                if(m.Goal_Benchmark__r != m.Id){
                    m.Goal_Benchmark__c.addError('You may not assign a Benchmark that already belongs to a different Member');
                }
            }
            if(m.Current_Benchmark__c != null){
                if(m.Current_Benchmark__r != m.Id){
                    m.Current_Benchmark__c.addError('You may not assign a Benchmark that already belongs to a different Member');
                }
            }
        }
    }
    public static void checkBenchmarkType(List<Contact> members){
        for(Contact m : members){
            if(m.Goal_Benchmark__c != null){
                if(!m.Goal_Benchmark__r.Goal_Benchmarks__c){
                    m.Goal_Benchmark__c.addError('You may not assign a progress Benchmark as a goal');
                }
            }
            if(m.Current_Benchmark__c != null){
                if(m.Current_Benchmark__r.Goal_Benchmarks__c){
                    m.Current_Benchmark__c.addError('You may not assign a goal as a progress Benchmark');
                }
            }
        }
    }
    */
    
}
