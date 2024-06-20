require 'csv'
require 'date'
require 'json'
require 'open-uri'
require 'breasal'

def gias_csv(base: 'https://ea-edubase-api-prod.azurewebsites.net/edubase/downloads/public/edubasealldata%s.csv')
  URI.open(sprintf(base, Date.today.strftime('%Y%m%d'))).read
end

def write_json(filename, hash)
  File.write(%(output/#{filename}.json), hash.to_json)
end

def easting_northing_to_wgs84(easting:, northing:)
  return {} unless easting && northing

  Breasal::EastingNorthing.new(easting:, northing:, type: :gb).to_wgs84
end

def extract_date(date)
  return nil if date == ""

  Date.parse(date)
end

def extract_number(num)
  return nil if num == ""

  num.to_i
end

schools = CSV.parse(gias_csv, headers: true, encoding: 'ISO-8859-1:UTF-8').map.with_object([]) do |r, arr|
  arr << {
    urn: r['URN'].to_i,
    ukprn: r['UKPRN'].to_i,
    name: r['EstablishmentName'],
    local_authority_code: r['LA (code)'],
    local_authority: r['LA (name)'],
    administritive_district_code: r['DistrictAdministrative (code)'],
    administritive_district: r['DistrictAdministrative (name)'],
    phase_of_education_code: extract_number(r['PhaseOfEducation (code)']),
    phase_of_education: r['PhaseOfEducation (name)'],
    gender: r['Gender (name)'],
    type_code: extract_number(r['TypeOfEstablishment (code)']),
    type: r['TypeOfEstablishment (name)'],
    status_code: extract_number(r['EstablishmentStatus (code)']),
    status: r['EstablishmentStatus (name)'],

    rsc_region: r['RSCRegion'],
    section_41_approved: r['Section41Approved (name)'],

    open_date: extract_date(r['OpenDate']),
    close_date: extract_date(r['CloseDate']),

    address_1: r['Street'],
    address_2: r['Locality'],
    address_3: r['Address3'],
    county: r['County (name)'],
    postcode: r['Postcode'],

    school_website: r['SchoolWebsite'],

    phone: r['TelephoneNum'],
    **easting_northing_to_wgs84(easting: r["Easting"].to_i, northing: r["Northing"].to_i)
  }
end

schools.each { |s| write_json(%(schools/#{s[:urn]}), s) }
write_json('schools', schools)
