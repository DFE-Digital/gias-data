# GIAS DATA

[This script](build.rb) generates JSON files for:

* all schools from GIAS in a big list
* every school in [GIAS](https://get-information-schools.service.gov.uk/) by [URN](https://en.wikipedia.org/wiki/Unique_Reference_Number)

It is scheduled to refresh every morning at 05:00.

## Fields

* urn
* ukprn
* name
* local_authority_code
* local_authority
* administritive_district_code
* administritive_district
* phase_of_education_code
* phase_of_education
* gender
* type_code
* type
* status_code
* status
* rsc_region
* section_41_approved
* open_date
* close_date
* address_1
* address_2
* address_3
* county
* postcode
* school_website
* phone
* latitude
* longitude

## Instructions

These examples use [Curl](https://curl.se/) but you can browse to the resources in your browser too.

### Getting all the schools

To get a full list of every school use `/schools.json`

```bash
curl -l https://dfe-digital.github.io/gias-data/schools.json
```

### Getting one school

You need to know a school's URN to get the rest of its info:

```bash
curl -l https://dfe-digital.github.io/gias-data/schools/100000.json
```
