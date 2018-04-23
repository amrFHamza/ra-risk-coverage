# RA Risk Coverage model

This project is a fork of the *Dataflow* and *RA Risk Coverage modeling* tools which are part of the Revenue Assurance toolset used in **A1 Telekom Austria Group**. 

It is an attempt to build a community around the idea of designing standard and open tool that supports risk based approach of doing cost and revenue assurance in telecom industry. The main purpose of the A1 RA Risk Coverage model is to provide a framework for risks modeling of individual business processess and product segments by guiding the process of risk assessment, helping to understand the risks and assisting in decisions for controlling and reducing the identified risks. It also implements easy to grasp methodology for quantifying revenue assurance risk coverage and residual risk aggregated on various levels.

The main features include:

- **Data-flow modeler** (provides repository of systems, interfaces, datasources, procedures and controls)
- **Risk catalogue** (provides repository of risks, root causes and generic revenue assurance controls)
- **Risk node modeler** (enables risk assessment of defined product segments in context of the process and core system)
- **Risk coverage visualisation and analysis** (provides means to set priorities and plan risk mitigation strategies)

The risk modeling tool comes out of the box with two (mutually exclusive) data models based on different risk catalogues, whcih are de-facto risk management standards in telecom industry:
- **RAG RA Risk Catalogue** ([more information](https://riskandassurancegroup.org/)), available under [Creative Commons Attribution-Non Commercial-No Derivatives International 4.0 Licence](https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode)
- **TM Forum RA Risk Inventory** ([more information](https://www.tmforum.org/resources/best-practice/gb941e-revenue-assurance-coverage-model-risk-inventory-v1-4-1/)), Copyright © TM Forum 2014.

## Getting Started

### Prerequisites

- [Git](https://git-scm.com/)
- [Node.js (^4.2.3) and npm (^2.14.7)](https://nodejs.org/en/download/)
- [MySQL (^5.7.21)](https://dev.mysql.com/downloads/mysql/)
- [Bower](https://bower.io/) (`npm install --global bower`)
- [Grunt](http://gruntjs.com/) (`npm install --global grunt-cli`)

### Set-up and run

After the prerequisites are installed:

1. Clone this repository using `git` command from the terminal:
	```shell
	git clone https://github.com/a1telekom/ra-risk-coverage.git
	```
	this will create directory named `ra-risk-coverage` in your working directory.

2. Change the working directory to the newly created location: 
	```shell
	cd ra-risk-coverage
	```

3. To install the server dependencies:
	```shell
	npm install
	```

4. To install the front-end dependencies:
	```shell
	bower install
	```

5. Create the database connection config file `server/utils/db.js` with the content below, and be sure to set your correct MySQL server parameters

	File `server/utils/db.js`:
	```javascript
	var mysql = require('mysql');
	var pool = mysql.createPool({
		connectionLimit	: 10,
		host : 'localhost',
		database : 'tag',
		user : 'user',
		password : 'password'
	});
	module.exports = pool;
	``` 
	*(or rename and edit the included example file `server/utils/db.js.spec`)*

6. To start the development server:
	```shell
	grunt serve
	```
	It should automatically open the client in your browser when ready.

7. On first use you should be automatically redirected to the **Settings** page (`http://localhost:9000/settings`) where one of the pre-bundled databases need to be imported. 

	This part can be performed manually using ``mysql`` DB import functionality. For example to import the RAG based data model into MySQL database server running on the localhost:
	```shell
	mysql -u user -p -h localhost < server/db/rrc_rag.sql
	```

	Following are the locations of the two data models:
	- RAG data model `server/db/rrc_rag.sql`
	- TMF data model `server/db/rrc_tmf.sql`

	Note that unrelated to which data model is chosen - new DB schema named `tag` will be created in the MySQL DB.  

8. Sign-in using the pre-set user/pasword set: `test@example.com` / `password` 

### Build for production

1. Run `grunt build` for running all tests and building production project 

2. Run `grunt serve` for preview in a browser.

### Data model

![RA Risk Coverage data model](static/images/rrc_data_model.png?raw=true "RA Risk Coverage data model")
![RA Risk Coverage data model detailed](static/images/rrc_data_model_detailed.png?raw=true "RA Risk Coverage data model detailed")

### Screenshots

![Look and feel](static/images/look_and_feel.png?raw=true "Look and feel")