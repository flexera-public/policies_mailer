# policies_mailer


## Development

### Requires
  - Ruby 2.3.0+
  - Bundler
  - Praxis-Framework

# Api

## /api/csv
 - Creates, Updates, and Deletes a csv file, the Create call returns the following hash, to use in additional calls:
 `{ "name": "filename.csv }`
### Fields
| Action | Verbs | Fields |
|------------|-----------|-------------|
| Create | POST | `data` - two dimensional array [[1,2,3][4,5,6]] 
| Update | PUT  | `data` - two dimensional array [[1,2,3][4,5,6]]
| Delete | DELETE | `id` as part of path

### Examples

#### Create
```
http POST http://localhost:8888/api/csv X-Api-Version:1.0 data:=[[1,2,3]]
```
Response:
```
HTTP/1.1 200 OK
Content-Length: 51
Content-Type: application/json

{
            "file": "6901f064-8077-4644-984b-a3ee258f57c3.csv"
}
```

#### Update
```
http PUT http://localhost:8888/api/csv/6901f064-8077-4644-984b-a3ee258f57c3.csv X-Api-Version:1.0 data:=[[4,5,6],[6,7,8]]
```
Response:
```
HTTP/1.1 200 OK
Content-Length: 51
Content-Type: application/json

{
            "file": "6901f064-8077-4644-984b-a3ee258f57c3.csv"
}
```

#### Delete
```
http DELETE http://localhost:8888/api/csv/6901f064-8077-4644-984b-a3ee258f57c3.csv X-Api-Version:1.0
```
Response:
```
HTTP/1.1 200 OK
Content-Length: 0
Content-Type: application/json
```

## /api/mail
 - Sends email to user via mailgun api with or without attachments

### Fields
| Action | Verbs | Fields |
|------------|-----------|-------------|
| Create | POST | `to` - String, `from` - String, `subject` - String, `body` - String, 
|        |      | `attachment` - String, `encoding` - String('html','text') Default: text, `delete_attachment` - Boolean, Default: true

### Examples

#### Create
```
http POST http://localhost:8888/api/mail X-Api-Version:1.0 to=john.doe@example.com from=policies@rightscale.com subject='Policy Report' \
                                                           body='Attached is your policy report' attachment='6901f064-8077-4644-984b-a3ee258f57c3.csv'
```
Response:
```
HTTP/1.1 200 OK
Content-Length: 117
Content-Type: application/json

{
            "message": "Queued. Thank you.", 
                "message_id": "<20180111191946.1.50D7896597E97DC2@services.rightscale.com>"
}
```

## RCL Example
```ruby
define create_csv_header() return $csv_file do
  $response = http_post(
    url: "http://localhost:8888/api/csv",
    headers: {"X-Api-Version": "1.0"},
    body: { data : [["column1","column2","column3"]] })
  $csv_file = response["body"]["file"]
end

define add_csv_rows($csv_file,@collection) do
  foreach @item in @collection do
    call business_logic($item) retrieve $row
    $response = http_put(
      url: "http://localhost:8888/api/csv"+$csv_file,
      headers: {"X-Api-Version": "1.0"},
      body: { data : [$row] })
  end
end

define business_logic(@item) return $row do
  # do something to turn item into row
end

define send_mail($csv_file) return $response do
  $response = http_post(
    url: "http://localhost:8888/api/mail",
    headers: {"X-Api-Version": "1.0"},
    body: { to: john.doe@example.com, from: policies@rightscale.com, subject: 'Policy Report', 
            body: 'Attached is your policy report', attachment: $csv_file}
  )
end

define launch_handler() do
  call create_csv_header() retrieve $csv_file
  @instances = rs_cm.instances.get()
  call add_csv_rows($csv_file,@instances)
  call send_mail($csv_file)
end
```
## Running Application
```
docker build policies_mailer -t policies_mailer:poc
docker run -d -p 80:8080 -e MAILGUN_DOMAIN='mail.example.com' -e MAILGUN_API_KEY='key-replace-me' sha_of_image
```
## Additional API Docs: https://rs-services.github.io/policies_mailer/
