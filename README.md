# ROR TEST Wallet Manipulation

## 💻 Getting Started <a name="getting-started"></a>

To get a local copy up and running, follow these steps.

### Prerequisites

In order to run this project you need:

```
    ruby >= 3.3.0
    rails >= 7.2.1
    postgres >- 15.3
```

You also need API Key from [rapidapi.com/suneetk92/api/latest-stock-price/playground](https://rapidapi.com/suneetk92/api/latest-stock-price/playground/apiendpoint_bfd7b183-67e6-4ecf-afd9-a42175b471aa) 
As this project have a library depends on that api

### Setup

Clone this repository to your desired folder:

```bash
  git clone https://github.com/ichsansandy/rortest_wallet.git
```

You need to setup database for these project

```
  development = rortest_wallet
  test        = rortest_wallet_test
  production  = rortest_wallet_prod
```

or you can use your own database and change the ```config/database.yml```

```yml
  default: &default
    adapter: postgresql
    encoding: unicode
    pool: 5
    username: [your_username]
    password: [your_password]
    host: localhost

  development:
    <<: *default
    database: [your_database_for_development]

  test:
    <<: *default
    database: [your_database_for_test]

  production:
    <<: *default
    database: [your_database_for_production]
```

Optionally you can save it inside your rails credentials by running

```
 EDITOR=VIM rails credentials:edit
```
it will show this and you can edit it

```yml

postgres:
  username: [your_database_username]
  password: [your_database_password]

rapidapi:
  x_rapidapi_key: [your_rapidapi_key]
  x_rapidapi_host: latest-stock-price.p.rapidapi.com


secret_key_base: [your_generated_key]

```

### Install

Install this project with:

```bash
  cd rortest_wallet
  bundle install
```

it will install the required gemfile for running the project

### Usage

to use this project:

```ruby
   bin/rails server
```

it will run the the server on ```localhost:3000```

<!-- ### Test

to run test in these this project:

```ruby
   rspec
```

it will run the all the unit test of these project

 -->


<p align="right">(<a href="#readme-top">back to top</a>)</p>