import ballerina/io;
import ballerina/graphql;

public type CovidEntry record {|
    readonly string isoCode;
    string region;
    int cases = 0;
    int deaths = 0;
    int recovered = 0;
    int active = 0;
    int confirmed = 0;
|};

table<CovidEntry> key(isoCode) covidEntriesTable = table [
    {isoCode: "KHM", region: "Khomas", cases: 0, deaths: 0, recovered: 0, active: 0},
        {isoCode: "OSH", region: "Oshana", cases: 0, deaths: 0, recovered: 0, active: 0},
        {isoCode: "OMU", region: "Omusati", cases: 0, deaths: 0, recovered: 0, active: 0},
        {isoCode: "OHA", region: "Ohangwena", cases: 0, deaths: 0, recovered: 0, active: 0},
        {isoCode: "HAR", region: "Hardap", cases: 0, deaths: 0, recovered: 0, active: 0},
        {isoCode: "KAE", region: "Kavango East", cases: 0, deaths: 0, recovered: 0, active: 0},
        {isoCode: "KAW", region: "Kavango West", cases: 0, deaths: 0, recovered: 0, active: 0},
        {isoCode: "ERO", region: "Erongo", cases: 0, deaths: 0, recovered: 0, active: 0},
         {isoCode: "OTJ", region: "Otjozondjupa", cases: 0, deaths: 0, recovered: 0, active: 0},
        {isoCode: "KAR", region: "Karas", cases: 0, deaths: 0, recovered: 0, active: 0},
        {isoCode: "OMH", region: "Omaheke", cases: 0, deaths: 0, recovered: 0, active: 0},
        {isoCode: "ZAM", region: "Zambezi", cases: 0, deaths: 0, recovered: 0, active: 0},
        {isoCode: "KUN", region: "Kunene", cases: 0, deaths: 0, recovered: 0, active: 0},
        {isoCode: "OSK", region: "Oshikoto", cases: 0, deaths: 0, recovered: 0, active: 0}
];

public distinct service class CovidData {
    private final readonly & CovidEntry entryRecord;

    function init(CovidEntry entryRecord) {
        self.entryRecord = entryRecord.cloneReadOnly();
    }

    resource function get isoCode() returns string {
        return self.entryRecord.isoCode;
    }

    resource function get region() returns string {
        return self.entryRecord.region;
    }

    resource function get cases() returns int? {
        return self.entryRecord.cases;
    }

    resource function get deaths() returns int? {
        return self.entryRecord.deaths;
    }

    resource function get recovered() returns int? {
        return self.entryRecord.recovered;
    }

    resource function get active() returns int? {
        return self.entryRecord.active;
    }
}

public type Entry record {|
    int deaths = 0;
    int recovered = 0;
    int new_case = 0;
|};

service /graphql on new graphql:Listener(4000) {
    resource function get all() returns CovidData[] {
        CovidEntry[] covidEntries = covidEntriesTable.toArray().cloneReadOnly();
        return covidEntries.map(entry => new CovidData(entry));
    }

    resource function get filter(string isoCode) returns CovidData? {
        CovidEntry? covidEntry = covidEntriesTable[isoCode];
        if covidEntry is CovidEntry {
            return new (covidEntry);
        }
        return;
    }

    remote function update(string isoCode, Entry entry) returns CovidData {
        CovidEntry e = covidEntriesTable.get(isoCode);
        io:println(e.toBalString());

        if (entry.new_case > 0) {
            e.cases += entry.new_case;
            e.active += entry.new_case;
        }

        if (entry.deaths > 0) {
            e.deaths += entry.deaths;
            e.active -= entry.deaths;
        }

        if (entry.recovered > 0) {
            e.recovered += entry.recovered;
            e.active -= entry.recovered;
        }

        // covidEntriesTable.put(entry);
        return new CovidData(e);
    }
}
