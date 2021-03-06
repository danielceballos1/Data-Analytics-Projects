Dataset Exploration with San Francisco's Department of Public Health

_________________________________________________________________________________________________________________________

Dataset was taken from
https://data.sfgov.org/Health-and-Social-Services/Restaurant-Scores-LIVES-Standard/pyih-qa8i


_________________________________________________________________________________________________________________________

Context

Dataset contains information on San Francisco's restaurant scores from 2016 to 2019.
San Francisco's Health Deparment has created an inspection report and scoring system for facilities within San Francisco. 

After inspecting facilities, health inspectors calculate scores based on the various violations observed.
Violations can vary from category. Categories of violations include: 

	"high risk category:
	records specific violations that directly relate to the transmission of food borne illnesses,
	the adulteration of food products and the contamination of food-contact surfaces.
	
	moderate risk category:
	records specific violations that are of a moderate risk to the public health and safety.
	
	low risk category:
	records violations that are low risk or have no immediate risk to the public health and safety."



Columns violation_id, violation_description, risk_category were not needed for the following queries so they were
removed before being imported into PgAdmin.

_________________________________________________________________________________________________________________________

Content

The file Restaurant_Scores_CLEAN.xlsx contains the following columns:

	business_id	

	business_name	

	business_address	

	business_city	

	business_state	

	business_postal_code	

	business_latitude	

	business_longitude	

	business_location	

	business_phone_number	

	inspection_id	

	inspection_date	

	inspection_score	

	inspection_type	
