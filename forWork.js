
function formatTimeSpan([startChunk, endChunk]) {
    // Convert time chunks to GMT dates, accounting for the 30 minute offset
    const startTime = new Date('1970-01-01T00:00:00Z').setMinutes(startChunk - 30);
    const endTime = new Date('1970-01-01T00:00:00Z').setMinutes(endChunk);

    // Format dates to the specified timezone
    const timeFormatter = new Intl.DateTimeFormat('en-US', {
        hour: 'numeric',
        minute: '2-digit',
        timeZone: "UTC",
        hour12: true,
    });

    return `${timeFormatter.format(startTime)} - ${timeFormatter.format(endTime)}`;
}

function consolidateTimeSpans(availability) {
    const consolidated = {};

    for (const [day, chunks] of Object.entries(availability)) {
        const spans = [];
        let start = 0;
        let end = 0;

        for (let i = 0; i < chunks.length; i++) {
            if (start === 0) {
                start = chunks[i];
                end = start;
            } else if (chunks[i] === end + 30) {
                end = chunks[i];
            } else {
                spans.push([start, end]);
                start = chunks[i];
                end = start;
            }
        }

        if (start !== 0) {
            spans.push([start, end]);
        }

        consolidated[day] = spans;
    }

    return consolidated;
}


function normalizeTo(spans, timezone) {
    const date = new Date();
    const userDate = new Date(date.toLocaleString('en-US', { timeZone: timezone }));
    const utcDate = new Date(date.toLocaleString('en-US', { timeZone: 'UTC' }));
    const offset = Math.round((((userDate - utcDate) / 60000) / 30)) * 30;

    const elements = [];
    const outputSpan = {};
    const dayOrder = { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6 };
    for (const day of Object.keys(dayOrder)) {
        for (const chunk of spans[day] ?? []) {
            let normChunk = chunk + dayOrder[day] * 1440 + offset;
            if (normChunk < 0) normChunk = normChunk + (7 * 1440);
            normChunk = normChunk % (7 * 1440);
            elements.push(normChunk);
        }
    }
    //n^2. optimize if problematic to itterate elements instead of days
    for (const day of Object.keys(dayOrder)) {
        outputSpan[day] = elements.filter(
            e => (Math.floor(e / 1441) === dayOrder[day])
        ).map(
            e => e % 1440 || ((e % 1440) + 1440)
        );
    }
    return outputSpan;
}

function showLocalTimeSpans(spans, timezone){
    const normal = normalizeTo(spans, timezone);
    const consold = consolidateTimeSpans(normal);
    let strs = [];
    for(const day of Object.keys(consold)){
        strs.push(day + ": " + consold[day].map(e => formatTimeSpan(e)).join(", "));
    }
    return strs.join("\n");
}

// Usage example
const timezone = "America/Denver";
const test = {
    monday: [30, 60, 1410, 1440],
    tuesday: [60, 90]
};




console.log(showLocalTimeSpans(test, timezone));
