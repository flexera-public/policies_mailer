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

```
http POST http://localhost:8888/api/csv X-Api-Version:1.0 data:=[[1,2,3]]
http PUT http://localhost:8888/api/csv/5dea41ad-b0d6-45a7-8deb-458301a2ff5f.csv X-Api-Version:1.0 data:=[[4,5,6],[6,7,8]]
http DELETE http://localhost:8888/api/csv/5dea41ad-b0d6-45a7-8deb-458301a2ff5f.csv
```

## /api/mail
 - Sends email to user via mailgun api with or without attachments

### Fields
| Action | Verbs | Fields |
|------------|-----------|-------------|
| Create | POST | `to` - String, `from` - String, `subject` - String, `body` - String, 
|        |      | `attachment` - String, `encoding` - String('html','text') Default: text, `delete_attachment` - Boolean, Default: true

### Examples

```
http POST http://localhost:8888/api/mail X-Api-Version:1.0 to=john.doe@example.com from=policies@rightscale.com subject='Policy Report' \
                                                           body='Attached is your policy report' attachment='5dea41ad-b0d6-45a7-8deb-458301a2ff5f.csv'
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
## Routes
 ```
+---------+----------------+--------+--------------------------+--------+-------------------+------+---------+---------+
|                                                        Routes                                                        |
+---------+----------------+--------+--------------------------+--------+-------------------+------+---------+---------+
| Version | Path           | Verb   | Resource                 | Action | Implementation    | Name | Primary | Options |
+---------+----------------+--------+--------------------------+--------+-------------------+------+---------+---------+
| 1.0     | /api/csv       | GET    | V1::ApiResources::CSVAPI | index  | V1::CSVAPI#index  |      | yes     |         |
| 1.0     | /api/csv/:id   | GET    | V1::ApiResources::CSVAPI | show   | V1::CSVAPI#show   |      | yes     |         |
| 1.0     | /api/csv       | POST   | V1::ApiResources::CSVAPI | create | V1::CSVAPI#create |      | yes     |         |
| 1.0     | /api/csv/:id   | PUT    | V1::ApiResources::CSVAPI | update | V1::CSVAPI#update |      | yes     |         |
| 1.0     | /api/csv/:id   | PATCH  | V1::ApiResources::CSVAPI | update | V1::CSVAPI#update |      |         |         |
| 1.0     | /api/csv/:id   | DELETE | V1::ApiResources::CSVAPI | delete | V1::CSVAPI#delete |      | yes     |         |
| 1.0     | /api/hello     | GET    | V1::ApiResources::Hello  | index  | V1::Hello#index   |      | yes     |         |
| 1.0     | /api/hello/:id | GET    | V1::ApiResources::Hello  | show   | V1::Hello#show    |      | yes     |         |
| 1.0     | /api/mail      | GET    | V1::ApiResources::Mail   | index  | V1::Mail#index    |      | yes     |         |
| 1.0     | /api/mail/:id  | GET    | V1::ApiResources::Mail   | show   | V1::Mail#show     |      | yes     |         |
| 1.0     | /api/mail      | POST   | V1::ApiResources::Mail   | create | V1::Mail#create   |      | yes     |         |
+---------+----------------+--------+--------------------------+--------+-------------------+------+---------+---------+
```
