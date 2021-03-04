WorkoutDistributor wd = new WorkoutDistributor();

String crn = '30 12 10 ? * *';
String jobID = system.schedule('Distribute Workouts '+ date.today(), crn, wd);

String cron = '20 49 7 ? * *';
String jobID = system.schedule('Distribute Workouts '+ date.today(), cron, wd);

