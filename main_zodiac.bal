import ballerinax/health.fhir.r4.international401 as international401;
import ballerinax/health.fhir.r4 as r4;
import ballerinax/health.fhir.r4.parser as parser;
import ballerina/io;
import ballerinax/health.hl7v2 as hl7v2;
import ballerinax/health.hl7v2commons as hl7v2commons;

type ZodiacSign record {|
    string signName;
    string dateRange;
|};

public function main() {
    ZodiacSign[] zodiacSigns = [
        {signName: "Aries", dateRange: "March 21 - April 19"},
        {signName: "Taurus", dateRange: "April 20 - May 20"},
        {signName: "Gemini", dateRange: "May 21 - June 20"},
        {signName: "Cancer", dateRange: "June 21 - July 22"},
        {signName: "Leo", dateRange: "July 23 - August 22"},
        {signName: "Virgo", dateRange: "August 23 - September 22"},
        {signName: "Libra", dateRange: "September 23 - October 22"},
        {signName: "Scorpio", dateRange: "October 23 - November 21"},
        {signName: "Sagittarius", dateRange: "November 22 - December 21"},
        {signName: "Capricorn", dateRange: "December 22 - January 19"},
        {signName: "Aquarius", dateRange: "January 20 - February 18"},
        {signName: "Pisces", dateRange: "February 19 - March 20"}
    ];

    foreach ZodiacSign zodiacSign in zodiacSigns {
        string signName = zodiacSign.signName;
        string dateRange = zodiacSign.dateRange;
        io:println(string `${signName}: ${dateRange}`);
    }
}