## How to update the schedule "on the fly"

Go to the [CodeLand Master Production](https://docs.google.com/spreadsheets/d/1kQNQ67qZKdeDRXgExQYhbkTfKjqInQqnUjl6NL_Q6qU/edit#gid=1142373351) spreadsheet. The columns __minutes__ & __seconds__ represent the __duration__ of each speaker/sponsor. The columns __delay_min__ & __delay_sec__ are the ones that should be used in case we encounter any delays along the way.

Example:

The Live Speaker Panel with id `114` had some trouble getting started and we're now 3 minutes behind of schedule. We should add a 3 minute delay to that row (simple 3 added to __delay_min__). This will cause all other talks downstream to update their times in cascade.

### What next?

1. `File` > `Download` > `.csv, current sheet`
1. Rename the CSV file to `schedule.csv` and place it in this directory
1. Parse the CSV into JSON using the script `ruby schedule_csv_to_json.rb`
1. Copy `schedule.json` contents and edit the Codeland Schedule page in [https://dev.to/internal/pages](https://dev.to/internal/pages)
