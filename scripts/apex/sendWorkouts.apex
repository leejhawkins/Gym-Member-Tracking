WorkoutDistributor wd = new WorkoutDistributor();
<<<<<<< HEAD
String crn = '30 12 10 ? * *';
String jobID = system.schedule('Distribute Workouts '+ date.today(), crn, wd);
=======
String cron = '20 49 7 ? * *';
String jobID = system.schedule('Distribute Workouts '+ date.today(), cron, wd);
>>>>>>> 7d20d38cfd25e706f62dcf7238412857967d6be0
