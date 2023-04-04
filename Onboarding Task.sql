-- Onboarding Task - Part 1

--- a. Display a list of all property names and their property id’s for Owner Id: 1426. 

SELECT	Property.Name, Property.Id

FROM	[dbo].[Property] INNER JOIN [dbo].[OwnerProperty]
			ON Property.Id = OwnerProperty.PropertyId

WHERE	OwnerProperty.OwnerId = 1426 

--- b. Display the current home value for each property in question a). 

SELECT	PropertyHomeValue.PropertyId, PropertyHomeValue.Value

FROM	[dbo].[PropertyHomeValue]

WHERE	PropertyId IN 
						(SELECT Property.Id
						FROM [dbo].[Property] INNER JOIN [dbo].[OwnerProperty]
						ON Property.Id = OwnerProperty.PropertyId
						WHERE OwnerProperty.OwnerId = 1426 )
		AND  [HomeValueTypeId]= 1
		AND [IsActive] = 1

--- c. For each property in question a), return the following:                                                                      
	--- i. Using rental payment amount, rental payment frequency, tenant start date and tenant end date to write a query that returns the sum of all payments from start date to end date. 
	--- ii. Display the yield. 

SELECT	TenantProperty.PropertyId,
		CASE WHEN TenantProperty.PaymentFrequencyId = 1 THEN DATEDIFF(WEEK, TenantProperty.StartDate, TenantProperty.EndDate)*TenantProperty.PaymentAmount
		WHEN TenantProperty.PaymentFrequencyId = 2 THEN (DATEDIFF(WEEK, TenantProperty.StartDate, TenantProperty.EndDate)*TenantProperty.PaymentAmount)/2
		ELSE (DATEDIFF(MONTH, TenantProperty.StartDate, TenantProperty.EndDate)+1)*TenantProperty.PaymentAmount
		END AS AllPayments,
		PropertyFinance.yield

FROM	TenantProperty LEFT JOIN PropertyFinance
			ON TenantProperty.PropertyId = PropertyFinance.PropertyId

WHERE	TenantProperty.PropertyId IN
						(SELECT Property.Id
						FROM [dbo].[Property] INNER JOIN [dbo].[OwnerProperty]
						ON Property.Id = OwnerProperty.PropertyId
						WHERE OwnerProperty.OwnerId = 1426 )

--- d. Display all the jobs available

SELECT	Job.Id,
		Job.JobDescription,
		Job.JobStartDate,
		Job.JobEndDate,
		Job.PaymentAmount,
		JobStatus.Status

FROM	Job INNER JOIN JobStatus
			ON Job.JobStatusId =  JobStatus.Id

WHERE	Job.JobStatusId = 1

--- e. Display all property names, current tenants first and last names and rental payments per week/ fortnight/month for the properties in question a). 

SELECT	Property.Name as PropertyName, 
		CONCAT (Person.FirstName, ' ', Person.LastName) as TenantName, 
		TenantProperty.PaymentAmount as RentalPayment, 
		TenantPaymentFrequencies.Name as PaymentFrequency

FROM	[dbo].[Property] INNER JOIN [dbo].[OwnerProperty]
			ON Property.Id = OwnerProperty.PropertyId 
		LEFT JOIN [dbo].[TenantProperty]
			ON Property.Id = TenantProperty.PropertyId
		LEFT JOIN [dbo].[Person]
			ON TenantProperty.TenantId = Person.Id
		LEFT JOIN [dbo].[TenantPaymentFrequencies]
			ON TenantPaymentFrequencies.Id = TenantProperty.PaymentFrequencyId

WHERE OwnerProperty.OwnerId = 1426 