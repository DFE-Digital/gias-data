require 'csv'
require 'date'
require 'json'
require 'net/http'
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

schools = CSV.parse(gias_csv, headers: true, encoding: 'ISO-8859-1:UTF-8').map.with_object([]) do |r, arr|
  arr << {
    urn: r['URN'].to_i,
    name: r['EstablishmentName'],
    local_authority: r['LA (name)'],
    phase_of_education: r['PhaseOfEducation (name)'],
    gender: r['Gender (name)'],
    status: r['EstablishmentStatus (name)'],
    **easting_northing_to_wgs84(easting: r["Easting"].to_f, northing: r["Northing"].to_f)
  }
end

schools.each { |s| write_json(%(schools/#{s[:urn]}), s) }
write_json('schools', schools)
