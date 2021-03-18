WorkoutDistributor wd = new WorkoutDistributor();

String cron = '0 23 12 ? * *';
String jobID = system.schedule('Distribute Workouts '+ date.today(), cron, wd);