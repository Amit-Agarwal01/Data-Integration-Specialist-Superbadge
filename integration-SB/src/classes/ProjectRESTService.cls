@RestResource(urlMapping = '/project/*')

global class ProjectRESTService {
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId,
                                            Date StartDate, Date EndDate, Double Amount, String Status){
        String returnMessage = 'Boom';
        
        Savepoint savepoint = Database.setSavepoint();
        try {
            List<Opportunity> opportunities = new List<Opportunity>();
            if(OpportunityId != null  && OpportunityId.trim().length() > 0){
                Opportunity o = [SELECT Id, DeliveryInstallationStatus__c
                                FROM Opportunity
                                WHERE Id =: OpportunityId];
                o.DeliveryInstallationStatus__c = 'In Progress';
                opportunities.add(o);
            }
            update opportunities;
            List<Project__c> projects = new List<Project__c>();
            Project__c project = new Project__c();
            project.ProjectRef__c = ProjectRef;
            project.Name = ProjectName;
            project.Opportunity__c = OpportunityId;
            project.Start_Date__c = StartDate;
            project.End_Date__c = EndDate;
            project.Billable_Amount__c = Amount;
            project.Status__c = Status;
            
            projects.add(project);
            upsert projects;
            returnMessage = 'OK';
            
        }catch (Exception e){
            Database.rollback(savepoint);
            returnMessage = e.getMessage();
        }
        return returnMessage;
    }
}