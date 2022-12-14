# CYF Next

## Introduction

CYF has developed a bag of tools to help him to manage the organization and deliver his services. This ecosystem has some strengths (strongly decoupled, self-managed, self-served) and big limitations (difficulties to maintain, difficulties to share data, lack of control of the data).

In the last weeks we have a series of sessions to understand how CYF works and what are her strengths, weaknesses and needs. In this document we want to gather this knowledge to help us to design the next evolution in the CYF ecosystem

## Strengths

CYF has been able to setup a set of tools to help to manage a organization that deals with hundreds of volunteers and applicants/students. and has done this by herself without help of external organizations only with the resolution of volunteers students and grads. This is not a small feat. And this ecosystem has some unique characteristics that we have to try to keep

- Self-Served: The fact that CYF is mainly a volunteer organization makes very easy that people comes with ideas and implement it
- Self-managed: we deploy and manage our software in AWS servers using mainly open-source tools (K8,MongoDB, Node, React )
- Strongly-decoupled: There is no dependencies between different tools (if we consider ITD/ITC and dashboard as one tool)

## Weakness

The very same thing that help us to build these tools so quickly is hurting us now. Making difficult to add new functionalities or to fix the errors that appear. These tools are mainly build for volunteers that tried to solve one problem and a lot of times where learning at the same time that they where building the software. This makes that the code now is

- Difficult to maintain: The code has grow without vision of product but as a problem comes-problem solved. This makes the code (inside each product) coupled, sometimes with the wrong solutions to common problems, and other with different approach's to the same solution, with very basic problems naming for example) that makes very difficult for a newcomers to understand the code
- Difficult to share data: Each set of products lives in his own burble without mechanism to share data between them (for example dashboard and student tracker)
- Lack of control of data: The data has not a defined authorization configuration that control who has access to what we only have an authentication configuration that is not enoughs for the working of the application
- Difficulty to create a new environment: ....

## What's next

The problem that we are facing is how to think in the future of CYF taking into account his strengths as organization with highly motivated people and minimizing his weakens as for example the high turnout and helping to create this new set of tools meanwhile we are keeping working the actual set

In [this sheet](https://docs.google.com/spreadsheets/d/1GywwW3BXOpEUZiwePCqRqQCl_FzYVTz052kx1FN9egE/edit#gid=1930388278) we can begin to understand the set of entities that makes CYF his different lifecycle and the authorizations needed to maintain this model. Now none of our databases actually supports this lifecycle and authorizations. Knowing also the painfully that is to do modifications in the current codebase it seems that the best way forward is to define a new source of truth. A database or set of databases that allows to keep this data and flexible enough to manage the authorizations, also we have to define a set of scripts to import data from the current system, and a API to be used for current/future applications to access this data

## Modeling

The following model has been designed thinking in a SQL database. We think that makes more sense mainly because the data that we have is very structured, well-defined, and we don't foresee scalability problems due to the size/usage of data because we are talking about tracking thousands of students/volunteers, and in any case we see entities with millions of records or transactions.

## Entities

The system is build around Persons. A **Person** can be a **Student** or/and a **Volunteer** and could have associated a **User**. In the future a **Person** can be also a ONG_user (to analyze in more detail)

A **Person** belongs to a **Region**

A **User** can have multiple **Role**, and each **Role** can have multiple **Permission**, and each **Permission** can filter different set of **Person** that can be accessible. To implement this filter the permission can have a query that filters the **Person** based on fixed filters (e.g. the last twenty) or dynamic (e.g. that belongs to the same cohort) and the **Group** of fields that can see.

A **Region** contains multiple **Cohort**. But a **Cohort** belongs to one and only one **Region**

A **Student** can belong multiple **Cohort** although at most only one is active.

A **Student** can have multiple **Buddy**. A **Buddy** is a **volunteer** in a role of tech

A **Stage** in the lifecycle of the **student** is composed for different **step**. In function of the stage is which the student is, he is called in different ways (applicant, trainee, grad, alumnni, ...).

A **Student** go through different **step** in his lifecycle and each **step** is done in one(usually), or multiple, **cohort** although only one is active at a moment in time, we call these specific steps **student_step**. The relationship between cohort and student_step is many-to-many as a student can be transfer from one cohort to another and the step is shared or can reapply in another cohort and has to repeat the step. The active **student_step** will determine the **Role** and through the **Role** and his **Permission** this will define what action can do at each moment on time.

Each **student** can have many **message** that are sent from **volunteer** to **student**.

Each **volunteer** can give **feedback** to the **student** if it has a relationship of **Buddy**

Each **student_step** can have many **course_work** that is sent from student to **volunteer** and that the **volunteer** reviews. Also both **volunteer** and **student** can give **comment**

A **Volunteer** can have multiple **Role** and each **Role** can have a **Cohort** (used in query permissions)

A **Volunteer** can have a relationship of **Buddy** (can be Tech, PD or welfare) with specific **Student** (used in query permissions)

## E-R

### Student E-R

```mermaid
erDiagram %% Student
   PERSON ||--o| STUDENT : is_a
   PERSON }|--|| REGION : belongs
   REGION ||--o{ COHORT : has
   STUDENT }|--|{ COHORT : belongs %% only one is active in a moment in time
   STUDENT ||--o{ STUDENT_STEP : works_in %% only one is active in a moment in time
   STAGE ||--o{ STEP: is_composed
   STAGE ||--o{ STUDENT: is
   STEP ||--o{ STUDENT_STEP: is_materialized
   COHORT }|--o{ STUDENT_STEP: is_done
   STUDENT o|--|{ MESSAGE: has
   STUDENT o|--|{ FEEDBACK: receives
   STUDENT_STEP o|--|{ COURSE_WORK: delivers
   STUDENT o|--|{ COMMENT: gives
   COURSE_WORK o|--o{ COMMENT: has
   STUDENT ||--0{ BUDDY: has
```
### Volunteer E-R

```mermaid
erDiagram %% Volunteer
   PERSON ||--o| VOLUNTEER : is_a
   ROLE o|--o{ VOLUNTEER_ROLE_COHORT: is_materialized
   VOLUNTEER o|--o{ VOLUNTEER_ROLE_COHORT: have
   VOLUNTEER_ROLE_COHORT }o--o| COHORT: associated
   VOLUNTEER |o--o{ MESSAGE: sent
   VOLUNTEER |o--o{ COURSE_WORK: reviews
   VOLUNTEER |o--o{ FEEDBACK: gives
   VOLUNTEER |o--o{ COMMENT: gives
   COURSE_WORK o|--o{ COMMENT: has
   VOLUNTEER ||--o{ BUDDY: is
```

## Tables

### Person

Contains the basic data of a person
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| person_id | Id | Int | PK |
| user_id | Id | Int | FK |
| firstName | | String | |
| lastName | | String | |
| email | | String | |
| telephone | | String | |
| agreeToTou | | Boolean | |
| agreeToReceiveCommunication | | Boolean | |
| region_id | Id | Int | FK |
| created_at | | DateTime | |
| updated_at | | DateTime | |
| updated_by | Id | Int | FK to last user_id that created/updated data|

### Student

Contains the data of a student
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| student_id | Id | Int | PK |
| person_id | Id | Int | FK |
| CountryISO | | String | FK, Iso code of the origin country | Out of POC
| ExperienceId | Id | Int | FK  | Out of POC
| itAccess | | Boolean | |
| heardAboutId | Id | Int | FK | Out of POC
| isEighteen | | Boolean | |
| genderId | Id | Int | FK | Out of POC
| disadvantagedBackground | | Boolean | |
| disadvantagedBackgroundText | | String | |
| currentlyEmployedId | Id | Int | FK | Out of POC
| studyingId | Id | Int | FK | Out of POC
| isAsylumSeekerOrRefugee | | Boolean | |  Change to table. Out of POC
| created_at | | DateTime | |
| updated_at | | DateTime | |
| updated_by | Id | Int | FK to last user_id that created/updated data|

### Region

Contains the regions (city) 
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| region_id | Id | Int | PK |
| description | | String | |

### Cohort

Contains the Cohorts
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| cohort_id | Id | Int | PK |
| region_id | Id | Int | FK |
| description | | String | |
| start_date | | Date | |
| end_date | | Date | |

### Student_Cohort

Keeps the students that work in a cohort and to which cohort the student belong or had belonged
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| cohort_id | Id | Int | PK |
| student_id | Id | Int | PK |
| is_active | | Boolean | |

### Stage
-- Out of POC
Different stages in the lifecycle of the student
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| StageId | Id | Int | PK |
| description |  | String | |

### Step
-- Out of POC
Steps that compose a stage
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| StepId | Id | Int | PK |
| StageId | Id | Int | FK |
| description |  | String | |

### Student_Step
-- Out of POC
Steps that are done by the student
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| student_id | Id | Int | PK,FK |
| StepId | Id | Int | PK, FK |
| cohort_id | Id | Int | PK, FK |
| is_active |  | Boolean |  |

### Message
-- Out of POC
Message sent from volunteer to student
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| MessageId | Id | Int | PK |
| student_id | Id | Int | FK |
| volunteer_id | Id | Int | FK |
| description |  | String | |

### Feedback
-- Out of POC
Feedback sent from volunteer to student
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| FeedbackId | Id | Int | PK |
| student_id | Id | Int | FK |
| volunteer_id | Id | Int | FK |
| description |  | String | |

### Course_Work
-- Out of POC
Course work done by the student
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| CourseWorkId | Id | Int | PK |
| student_id | Id | Int | FK |
| StepId | Id | Int | FK |
| cohort_id | Id | Int | FK |
| CourseWorkStatusId | Id | Int | FK |
| created_at | | DateTime | |
| updated_at | | DateTime | |
| updated_by | Id | Int | FK to last user_id that created/updated data|

### Comment
-- Out of POC
Comments give to the course_work, can be done by the student or the volunteer
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| CourseWorkId | Id | Int | PK |
| person_id | Id | Int | FK |
| description | | String |  |

### Buddy

Relationship of Tech, PD or welfare between volunteer and student
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| student_id | Id | Int | PK, FK |
| volunteer_id | Id | Int | PK, FK |
| buddy_type_id | Id | Int | FK |

### Volunteer

Contains the data of a volunteer
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| volunteer_id | Id | Int | PK |
| person_id | Id | Int | FK |
| other_expertise | | String |  |
| is_currently_volunteering | | Boolean |  |
| is_available_on_weekends | | Boolean |  |
| created_at | | DateTime | |
| updated_at | | DateTime | |
| updated_by | Id | Int | FK to last user_id that created/updated data|

### Volunteer_Role_Cohort

Contains a list the role of the volunteer
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| volunteer_id | Id | Int | PK, FK |
| Cohort_id | Id | Int | PK, FK |
| role_id | Id | Int | PK, FK |
| is_active |  | Boolean | |

### Volunteer_Expertise
-- Out of POC
Contains a list of expertise for a volunteer
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| volunteer_id | Id | Int | PK |
| ExpertiseId | Id | Int | PK, FK |
| Level |  | Int | |

### Volunteer_Skillset
-- Out of POC
Contains a list of expertise for a volunteer
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| volunteer_id | Id | Int | PK |
| SkillId | Id | Int | PK, FK |

### Country
-- Out of POC
Contains list of countries
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| CountryISO | Id | String | PK |
| description | | String | |

### Experience

Contains experience descriptions
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| ExperienceId | Id | Int | PK |
| description | | String | |

### Heard_About
-- Out of POC
Contains heard About descriptions
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| HeardAboutId | Id | Int | PK |
| description | | String | |

### Gender
-- Out of POC
Contains Gender descriptions
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| GenderId | Id | Int | PK |
| description | | String | |

### Currently_Employed
-- Out of POC
Contains Currently Employed descriptions
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| CurrentlyEmployedId | Id | Int | PK |
| description | | String | |

### Studying
-- Out of POC
Contains Studying descriptions
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| StudyingId | Id | Int | PK |
| description | | String | |

### Course_Work_Status
-- Out of POC
Contains Course Work Status descriptions
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| CourseWorkStatusId | Id | Int | PK |
| description | | String | |

### Buddies_Type

Contains Type Of Buddy descriptions
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| buddy_type_id | Id | Int | PK |
| description | | String | |

### Expertise
-- Out of POC
Contains Expertise descriptions
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| ExpertiseId | Id | Int | PK |
| description | | String | |

### Skillset
-- Out of POC
Contains Skill set descriptions
| Field | description | Type | Notes |
| ------- | -------------- | ------ | --- |
| SkillSetId | Id | Int | PK |
| description | | String | |

## Permissions

### User

Contains the user with access permissions
| Field | description | Type | Notes |
| ------- |-------------- | ------ |-- |
| user_id | Id | | PK |
| Active | Is user active | Bool | |

### Role

Contains the different roles
| Field | description | Type | Notes |
| ------- |-------------- |------ | -- |
| role_id | Id | | PK |
| Name | description | String | |

### User_Role

Contains the relationship between user & roles
| Field | description | Type | Notes |
| ------- |-------------- |------ | -- |
| user_id | Id | | PK, FK |
| role_id | Id | | PK, FK |

### Permission
--Managed through Hasura in the POC
Contains the different permissions
| Field | description | Type | Notes |
| ------- |-------------- |------ | -- |
| PermissionId | Id | | PK |
| Name | description | String | |
| Query | Filter to apply to the person | code to execute dynamically|

### Role_Permission
--Managed through Hasura in the POC
Contains the relationship between role & permissions
| Field | description | Type | Notes |
| ------- |-------------- |------ | -- |
| PermissionId | Id | | PK |
| role_id | Id | | PK |

### GroupFields
--Managed through Hasura in the POC
Set of fields
| Field | description | Type | Notes |
| ------- |-------------- |------ | -- |
| GroupFieldsId | Id | | PK |
| Name | description | String | |

### Permission_GroupFields
--Managed through Hasura in the POC
Fields accessible by the permission
| Field | description | Type | Notes |
| ------- |-------------- |------ | -- |
| PermissionId | Id | | PK, FK |
| GroupFieldsId | Id | | PK, FK |

## Next steps

- Deploy DB in the cloud for POC (https://devcenter.heroku.com/categories/command-line)
- Filter first scenario in Hasura
- Unify Message and feedback in one table (with some boolean to differentiate one from another)