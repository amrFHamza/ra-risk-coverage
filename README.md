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

1. Run `npm install` to install server dependencies.

2. Run `bower install` to install front-end dependencies.

3. Create the database connection config file `server/utils/db.js` with the content below, and be sure to set your correct MySQL server parameters: 
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
	*(or use the example file `db.js.spec` that is included in the same directory)*

4. Run `grunt serve` to start the development server. It should automatically open the client in your browser when ready.

5. At first time use you should be automatically redirected to the **Settings** page (`http://localhost:9000/settings`) where one of the pre-bundled databases need to be imported.

	This part can be performed manually using ``mysql`` DB import functionality. For example to import the RAG based data model:
	```bash
	mysql -u user -p -h localhost < server/db/rrc_rag.sql
	```

Follwoing are the locations of the two data models:
- RAG data model `server/db/rrc_rag.sql`
- TMF data model `server/db/rrc_tmf.sql`

6. Sign-in using the pre-set user/pasword set: `test@example.com` / `password` 

### Build for production

1. Run `grunt build` for running all tests and building production project 

2. Run `grunt serve` for preview in a browser.

### Data model

![RA Risk Coverage data model](static/images/rrc_data_model.png?raw=true "RA Risk Coverage data model")
![RA Risk Coverage data model detailed](static/images/rrc_data_model_detailed.png?raw=true "RA Risk Coverage data model detailed")

### Screenshots

![Look and feel](static/images/look_and_feel.png?raw=true "Look and feel")