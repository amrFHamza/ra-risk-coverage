/**
 * Using Rails-like standard naming convention for endpoints.
 * GET     /api/dfl-procedures              ->  index
 */

'use strict';

var db = require("../../utils/db");
var _und = require("underscore");

// Gets a list of DflProcedures

export function getApiEndpoint(req, res, next) {

	var queryParamsArray, metricId, opcoId;

  if (req.params.apiEndpoint === "getAllDatasources") {

    db.query(`
							SELECT 
								ds.DATASOURCE_ID, ds.OPCO_ID, ds.TYPE, ds.NAME, ds.RETENTION_POLICY, ds.DESCRIPTION, ds.STATUS_CODE,
								d.OWNER, d.COMMENT, 
								f.HOST, f.DIRECTORY, f.FILEMASK, f.FORMAT, f.COMPRESSION,
								m.SUBJECT, m.RECIPIENTS,
								i.INTERFACE_ID, i.INTERFACE_TYPE, i.INTERFACE_NAME, i.INTERFACE_DESCRIPTION, i.CONNECTION_INFO, i.DOCU_LINK, EXPERT_NAME,
						    s.NAME SYSTEM_NAME,
						    c.NAME CONTACT_NAME, c.EMAIL CONTACT_EMAIL,
								case 
									when ds.TYPE = 'D' then 'DB Object' 
									when ds.TYPE = 'F' then 'File' 
									when ds.TYPE = 'E' then 'Email' 
								end TYPE_TEXT 
							FROM dfl_datasource ds
							left join dfl_dbobject d on d.datasource_id = ds.datasource_id
							left join dfl_file f on f.datasource_id = ds.datasource_id
							left join dfl_mail m on m.datasource_id = ds.datasource_id
							left join dfl_interface i on i.interface_id = ds.interface_id
							left join amx_system s on s.system_id = i.ifc_system_id
							left join amx_contact c on c.CONTACT_ID = i.ifc_contact_id
							where ds.OPCO_ID like case when ? = '0' then '%' else ifnull(?, '%') end
							order by ds.MODIFIED desc
    	`, 
    	[req.query.opcoId, req.query.opcoId],
    	function (err, row) {
	      if(err !== null) {
	      	console.log(err);
	        next(err);
	      }
	      else {
	        res.json(row);
	      }
    });

  }

	if (req.params.apiEndpoint === "getDatasource") {
		if (req.query.datasourceId.substr(0,1) === 'M') {
			queryParamsArray = req.query.datasourceId.split('-');
			metricId = queryParamsArray[1];
			opcoId = queryParamsArray[2];
		  db.query(`
								SELECT 
									concat('M', '-', mc.METRIC_ID,'-',mc.OPCO_ID) DATASOURCE_ID,
									mc.OPCO_ID, 
									'R' TYPE, 
									mc.METRIC_ID NAME, 
									concat(mc.NAME, ' - ', mc.DESCRIPTION) DESCRIPTION, 
									case 
										when mc.RELEVANT='Y' and mc.IMPLEMENTED = 'Y' then 'A' 
										when mc.RELEVANT='Y' and mc.IMPLEMENTED = 'N' then 'D' 
										when mc.RELEVANT='N' then 'I' 
									end STATUS_CODE,
									'AMX Metric' TYPE_TEXT,
									case 
										when mc.RELEVANT='Y' and mc.IMPLEMENTED = 'Y' then 'Active fine-tuned' 
										when mc.RELEVANT='Y' and mc.IMPLEMENTED = 'N' then 'Active NOT fine-tuned' 
										when mc.RELEVANT='N' then 'Not relevant' 
									end STATUS_CODE_TEXT,
									mc.FREQUENCY,
									case 
										when mc.FREQUENCY = 'A' then 'Ad-hoc' 
										when mc.FREQUENCY = 'D' then 'Daily' 
										when mc.FREQUENCY = 'W' then 'Weekly' 
										when mc.FREQUENCY = 'M' then 'Monthly' 
										when mc.FREQUENCY = 'C' then 'Bill cycle' 
									end FREQUENCY_TEXT									
								FROM amx_metric_catalogue mc
								where mc.METRIC_ID = ? and mc.OPCO_ID = ?
		    	`, 
		    	[metricId, opcoId],
		    	function (err, row) {
			      if(err !== null) {
			      	console.log(err);
			        next(err);
			      }
			      else {
			        res.json(row[0]);
			      }
		    });
		}
		else {
		  db.query(`
								SELECT 
									ds.DATASOURCE_ID, ds.OPCO_ID, ds.TYPE, ds.NAME, ds.RETENTION_POLICY, ds.DESCRIPTION, ds.STATUS_CODE,
									d.OWNER, d.COMMENT, 
									f.HOST, f.DIRECTORY, f.FILEMASK, f.FORMAT, f.COMPRESSION,
									m.SUBJECT, m.RECIPIENTS,
									i.INTERFACE_ID, i.INTERFACE_TYPE, i.INTERFACE_NAME, i.INTERFACE_DESCRIPTION, i.CONNECTION_INFO, i.DOCU_LINK, EXPERT_NAME,
								    s.NAME SYSTEM_NAME,
								    c.NAME CONTACT_NAME, c.EMAIL CONTACT_EMAIL,
									case 
										when ds.TYPE = 'D' then 'DB Object' 
										when ds.TYPE = 'F' then 'File' 
										when ds.TYPE = 'E' then 'Email' 
									end TYPE_TEXT,
									case 
										when ds.STATUS_CODE = 'A' then 'Active' 
										when ds.STATUS_CODE = 'I' then 'Inactive' 
										when ds.STATUS_CODE = 'D' then 'Development' 
										when ds.STATUS_CODE = 'P' then 'Plan' 
									end STATUS_CODE_TEXT							
								FROM dfl_datasource ds
								left join dfl_dbobject d on d.datasource_id = ds.datasource_id
								left join dfl_file f on f.datasource_id = ds.datasource_id
								left join dfl_mail m on m.datasource_id = ds.datasource_id
								left join dfl_interface i on i.interface_id = ds.interface_id
								left join amx_system s on s.system_id = i.ifc_system_id
								left join amx_contact c on c.CONTACT_ID = i.ifc_contact_id
								where ds.DATASOURCE_ID = ?
		    	`, 
		    	[req.query.datasourceId],
		    	function (err, row) {
			      if(err !== null) {
			      	console.log(err);
			        next(err);
			      }
			      else {
			        res.json(row[0]);
			      }
		    });
		}
	}

 if (req.params.apiEndpoint === "getLinkedProcedures") {
		if (req.query.datasourceId.substr(0,1) === 'M') {
			queryParamsArray = req.query.datasourceId.split('-');
			metricId = queryParamsArray[1];
			opcoId = queryParamsArray[2];			
	    db.query(`
								select  
									0 DATAFLOW_ID,
							    p.PROCEDURE_ID,
							    concat('M', '-', ?,'-', ?) DATASOURCE_ID,
							    'O' DIRECTION,
									p.OPCO_ID, p.TYPE, p.SUB_TYPE, p.STATUS_CODE, p.NAME, p.DESCRIPTION, p.MODIFIED,
									jc.CODE_LOCATION, jc.JOB_PARAMETERS, 
									cc.CONTROL_TYPE, cc.CONTROL_ASSERTION, cc.START_DATE, cc.END_DATE, cc.CVG_CONTROL_ID, cc.ESCALATION_NOTES,
									sc.SOX_RELEVANT, sc.SOLUTION_CONTACT_ID, sc.DOCU_LINK,
									s.SCHEDULE_ID, s.NAME SCHEDULE_NAME, s.TYPE SCHEDULE_TYPE, s.FREQUENCY, s.COMMENT SCHEDULE_COMMENT,
									case 
										when p.TYPE = 'J' then 'Job' 
										when p.TYPE = 'C' then 'Control' 
										when p.TYPE = 'T' then 'Dato' 
										when p.TYPE = 'S' then 'Report solution'
									end TYPE_TEXT,
									case 
										when s.TYPE = 'A' then 'Application' 
										when s.TYPE = 'W' then 'Windows' 
										when s.TYPE = 'U' then 'UX Cron' 
										when s.TYPE = 'D' then 'Database'
										when s.TYPE = 'M' then 'Manual'
									end SCHEDULE_TYPE_TEXT,
									case 
										when s.FREQUENCY = 'A' then 'Ad-hoc' 
										when s.FREQUENCY = 'D' then 'Daily' 
										when s.FREQUENCY = 'W' then 'Weekly' 
										when s.FREQUENCY = 'M' then 'Monthly' 
										when s.FREQUENCY = 'C' then 'Bill cycle' 
									end FREQUENCY_TEXT	
								from dfl_procedure p 
								left join dfl_job_catalogue jc on jc.procedure_id = p.procedure_id
								left join dfl_control_catalogue cc on cc.procedure_id = p.procedure_id
								left join dfl_solution_catalogue sc on sc.procedure_id = p.procedure_id
							  left join dfl_schedule s on s.schedule_id = p.schedule_id
								where p.TYPE = 'T' and p.OPCO_ID = ? and p.NAME in (select DATO_ID from amx_metric_dato_link where OPCO_ID=? and METRIC_ID=?)
	    	`, 
	    	[metricId, opcoId, opcoId, opcoId, metricId],
	    	function (err, row) {
		      if(err !== null) {
		      	console.log(err);
		        next(err);
		      }
		      else {
		        //res.json(_und.pluck(row, 'SUB_TYPE'));
		        res.json(row);
		      }
	    });			
		}
		else {
	    db.query(`
								select  
									df.DATAFLOW_ID,
							    df.PROCEDURE_ID,
							    df.DATASOURCE_ID,
							    df.DIRECTION,
									p.OPCO_ID, p.TYPE, p.SUB_TYPE, p.STATUS_CODE, p.NAME, p.DESCRIPTION, p.MODIFIED,
									jc.CODE_LOCATION, jc.JOB_PARAMETERS, 
									cc.CONTROL_TYPE, cc.CONTROL_ASSERTION, cc.START_DATE, cc.END_DATE, cc.CVG_CONTROL_ID, cc.ESCALATION_NOTES,
									sc.SOX_RELEVANT, sc.SOLUTION_CONTACT_ID, sc.DOCU_LINK,
									s.SCHEDULE_ID, s.NAME SCHEDULE_NAME, s.TYPE SCHEDULE_TYPE, s.FREQUENCY, s.COMMENT SCHEDULE_COMMENT,
									case 
										when p.TYPE = 'J' then 'Job' 
										when p.TYPE = 'C' then 'Control' 
										when p.TYPE = 'T' then 'Dato' 
										when p.TYPE = 'S' then 'Report solution'
									end TYPE_TEXT,
									case 
										when s.TYPE = 'A' then 'Application' 
										when s.TYPE = 'W' then 'Windows' 
										when s.TYPE = 'U' then 'UX Cron' 
										when s.TYPE = 'D' then 'Database'
										when s.TYPE = 'M' then 'Manual'
									end SCHEDULE_TYPE_TEXT,
									case 
										when s.FREQUENCY = 'A' then 'Ad-hoc' 
										when s.FREQUENCY = 'D' then 'Daily' 
										when s.FREQUENCY = 'W' then 'Weekly' 
										when s.FREQUENCY = 'M' then 'Monthly' 
										when s.FREQUENCY = 'C' then 'Bill cycle' 
									end FREQUENCY_TEXT	
								from dfl_dataflow df														
								join dfl_procedure p on p.PROCEDURE_ID = df.PROCEDURE_ID
								left join dfl_job_catalogue jc on jc.procedure_id = p.procedure_id
								left join dfl_control_catalogue cc on cc.procedure_id = p.procedure_id
								left join dfl_solution_catalogue sc on sc.procedure_id = p.procedure_id
							  left join dfl_schedule s on s.schedule_id = p.schedule_id
								where df.DATASOURCE_ID = ? and df.DIRECTION like ?
	    	`, 
	    	[req.query.datasourceId, (req.query.getDirection === 'A'?'%':req.query.getDirection)],
	    	function (err, row) {
		      if(err !== null) {
		      	console.log(err);
		        next(err);
		      }
		      else {
		        //res.json(_und.pluck(row, 'SUB_TYPE'));
		        res.json(row);
		      }
	    });
		}
  }

 if (req.params.apiEndpoint === "getInterfacesByType") {
    db.query(`
							SELECT 
								i.INTERFACE_ID, i.OPCO_ID, i.INTERFACE_TYPE, i.INTERFACE_NAME, i.INTERFACE_DESCRIPTION, i.CONNECTION_INFO, i.DOCU_LINK, EXPERT_NAME,
							  s.NAME SYSTEM_NAME,
							  c.NAME CONTACT_NAME, c.EMAIL CONTACT_EMAIL
							from dfl_interface i 
							left join amx_system s on s.system_id = i.ifc_system_id
							left join amx_contact c on c.CONTACT_ID = i.ifc_contact_id
							where 1=1
								and i.OPCO_ID like ifnull(?, '%')
								and i.INTERFACE_TYPE = ?
							order by i.INTERFACE_NAME
    	`, 
    	[req.query.opcoId, req.query.type],
    	function (err, row) {
	      if(err !== null) {
	      	console.log(err);
	        next(err);
	      }
	      else {
	        //res.json(_und.pluck(row, 'SUB_TYPE'));
	        res.json(row);
	      }
    });
  }

  if (req.params.apiEndpoint === "getAllInterfaces") {

    db.query(`
							SELECT 
								i.INTERFACE_ID, i.OPCO_ID, i.INTERFACE_TYPE, i.INTERFACE_NAME, i.INTERFACE_DESCRIPTION, i.CONNECTION_INFO, i.DOCU_LINK, i.EXPERT_NAME,
							  s.NAME SYSTEM_NAME,
							  c.NAME CONTACT_NAME, c.EMAIL CONTACT_EMAIL,
								case 
									when i.INTERFACE_TYPE = 'D' then 'DB Interface' 
									when i.INTERFACE_TYPE = 'F' then 'File interface' 
									when i.INTERFACE_TYPE = 'E' then 'Email interface' 
								end INTERFACE_TYPE_TEXT 							  
							from dfl_interface i 
							left join amx_system s on s.system_id = i.ifc_system_id
							left join amx_contact c on c.CONTACT_ID = i.ifc_contact_id
							where 1=1
								and i.OPCO_ID like ifnull(?, '%')
							order by i.MODIFIED desc
    	`, 
    	[req.query.opcoId, req.query.opcoId],
    	function (err, row) {
	      if(err !== null) {
	      	console.log(err);
	        next(err);
	      }
	      else {
	        res.json(row);
	      }
    });

  }

  if (req.params.apiEndpoint === "getInterface") {

    db.query(`
							SELECT 
								i.INTERFACE_ID, i.OPCO_ID, i.INTERFACE_TYPE, i.INTERFACE_NAME, i.INTERFACE_DESCRIPTION, i.CONNECTION_INFO, i.DOCU_LINK, i.EXPERT_NAME, i.IFC_CONTACT_ID, i.IFC_SYSTEM_ID,
								case 
									when i.INTERFACE_TYPE = 'D' then 'DB interface' 
									when i.INTERFACE_TYPE = 'F' then 'File interface' 
									when i.INTERFACE_TYPE = 'E' then 'Email interface' 
								end INTERFACE_TYPE_TEXT 							  
							from dfl_interface i 
							where i.INTERFACE_ID = ?
    	`, 
    	[req.query.interfaceId],
    	function (err, row) {
	      if(err !== null) {
	      	console.log(err);
	        next(err);
	      }
	      else {
	        res.json(row[0]);
	      }
    });

  }


  if (req.params.apiEndpoint === "getAllSystems") {

    db.query(`
							SELECT 
								SYSTEM_ID, OPCO_ID, NAME, DESCRIPTION, DOCU_LINK
							from amx_system 
							where OPCO_ID = ?
    	`, 
    	[req.query.opcoId],
    	function (err, row) {
	      if(err !== null) {
	      	console.log(err);
	        next(err);
	      }
	      else {
	        res.json(row);
	      }
    });

  }

  if (req.params.apiEndpoint === "getSystem") {

    db.query(`
							SELECT 
								SYSTEM_ID, OPCO_ID, NAME, DESCRIPTION, DOCU_LINK
							from amx_system 
							where SYSTEM_ID = ?
    	`, 
    	[req.query.systemId],
    	function (err, row) {
	      if(err !== null) {
	      	console.log(err);
	        next(err);
	      }
	      else {
	        res.json(row[0]);
	      }
    });

  }  

} //end GET

export function postApiEndpoint(req, res, next) {


  if (req.params.apiEndpoint === "saveDatasource") {
  	if (typeof req.body.DATASOURCE_ID === 'undefined') {
  		// new procedure 
  		// console.log("Insert:");
  		// console.log(req.body);
  		db.query(`insert into dfl_datasource (OPCO_ID, TYPE, NAME, DESCRIPTION, STATUS_CODE, RETENTION_POLICY, INTERFACE_ID) 
  							values (?,?,?,?,?,?,?)`,
  							[req.body.OPCO_ID, req.body.TYPE, req.body.NAME, req.body.DESCRIPTION, req.body.STATUS_CODE, req.body.RETENTION_POLICY, req.body.INTERFACE_ID],
  							function (err, row) {
  								if (!err) {
  									var datasourceId = row.insertId;
  									switch (req.body.TYPE) {
  										case 'D':
													  		db.query(`insert into dfl_dbobject (DATASOURCE_ID, OWNER, COMMENT) 
													  							values (?,?,?)`,
													  							[datasourceId, req.body.OWNER, req.body.COMMENT],
													  							function (err, row) {
													  								if (!err) {
													  									res.json({success: true})
													  								}
													  								else {
																	  					res.json({success: false, error: err});
																	  					console.log(err);
													  								}
													  							}
													  		);
													  		break;
  										case 'F':
													  		db.query(`insert into dfl_file (DATASOURCE_ID, HOST, DIRECTORY, FILEMASK, FORMAT, COMPRESSION) 
													  							values (?,?,?,?,?,?)`,
													  							[datasourceId, req.body.HOST, req.body.DIRECTORY, req.body.FILEMASK, req.body.FORMAT, req.body.COMPRESSION],
													  							function (err, row) {
													  								if (!err) {
													  									res.json({success: true})
													  								}
													  								else {
																	  					res.json({success: false, error: err});
																	  					console.log(err);
													  								}
													  							}
													  		);
													  		break;
  										case 'E':
													  		db.query(`insert into dfl_mail (DATASOURCE_ID, SUBJECT, RECIPIENTS) 
													  							values (?,?,?)`,
													  							[datasourceId, req.body.SUBJECT, req.body.RECIPIENTS],
													  							function (err, row) {
													  								if (!err) {
													  									res.json({success: true})
													  								}
													  								else {
																	  					res.json({success: false, error: err});
																	  					console.log(err);
													  								}
													  							}
													  		);
													  		break;
											default:
																res.json({success: false, error: 'No datasource type'});
																break;
  									}
  									
  								}
  								else {
				  					res.json({success: false, error: err});
				  					console.log(err);
  								}
  							}
  		);

  	}
  	else {
  		// update
  		// console.log("Update:");
  		// console.log(req.body);  		
  		db.query(`update dfl_datasource set OPCO_ID=?, TYPE=?, NAME=?, DESCRIPTION=?, STATUS_CODE=?, RETENTION_POLICY=?, INTERFACE_ID=?
  							where DATASOURCE_ID = ?`,
  							[req.body.OPCO_ID, req.body.TYPE, req.body.NAME, req.body.DESCRIPTION, req.body.STATUS_CODE, req.body.RETENTION_POLICY, req.body.INTERFACE_ID, req.body.DATASOURCE_ID],
  							function (err, row) {
  								if (!err) {
  									switch (req.body.TYPE) {
  										case 'D':
													  		db.query(`update dfl_dbobject set OWNER=?, COMMENT=?
													  							where DATASOURCE_ID = ?`,
													  							[req.body.OWNER, req.body.COMMENT, req.body.DATASOURCE_ID],
													  							function (err, row) {
													  								if (!err) {
													  									res.json({success: true})
													  								}
													  								else {
																	  					res.json({success: false, error: err});
																	  					console.log(err);
													  								}
													  							}
													  		);
													  		break;
  										case 'F':
													  		db.query(`update dfl_file set HOST=?, DIRECTORY=?, FILEMASK=?, FORMAT=?, COMPRESSION=?
													  							where DATASOURCE_ID = ?`,
													  							[req.body.HOST, req.body.DIRECTORY, req.body.FILEMASK, req.body.FORMAT, req.body.COMPRESSION, req.body.DATASOURCE_ID],
													  							function (err, row) {
													  								if (!err) {
													  									res.json({success: true})
													  								}
													  								else {
																	  					res.json({success: false, error: err});
																	  					console.log(err);
													  								}
													  							}
													  		);
													  		break;
  										case 'E':
													  		db.query(`update dfl_mail set SUBJECT=?, RECIPIENTS=? 
													  							where DATASOURCE_ID=?`,
													  							[req.body.SUBJECT, req.body.RECIPIENTS, req.body.DATASOURCE_ID],
													  							function (err, row) {
													  								if (!err) {
													  									res.json({success: true})
													  								}
													  								else {
																	  					res.json({success: false, error: err});
																	  					console.log(err);
													  								}
													  							}
													  		);
													  		break;
											default:
																res.json({success: false, error: 'No procedure type'});
																break;
  									}
  									
  								}
  								else {
				  					res.json({success: false, error: err});
				  					console.log(err);
  								}
  							}
  		);  		
  	}
  }
  else if (req.params.apiEndpoint === "saveInterface") {
  	if (typeof req.body.INTERFACE_ID === 'undefined') {
  		// new procedure 
  		// console.log("Insert:");
  		// console.log(req.body);
  		db.query(`insert into dfl_interface (OPCO_ID, INTERFACE_TYPE, INTERFACE_NAME, INTERFACE_DESCRIPTION, CONNECTION_INFO, DOCU_LINK, IFC_SYSTEM_ID, IFC_CONTACT_ID, EXPERT_NAME) 
  							values (?,?,?,?,?,?,?,?,?)`,
  							[req.body.OPCO_ID, req.body.INTERFACE_TYPE, req.body.INTERFACE_NAME, req.body.INTERFACE_DESCRIPTION, req.body.CONNECTION_INFO, req.body.DOCU_LINK, req.body.IFC_SYSTEM_ID, req.body.IFC_CONTACT_ID, req.body.EXPERT_NAME],
  							function (err, row) {
									if (!err) {
										res.json({success: true})
									}
									else {
										res.json({success: false, error: err});
										console.log(err);
									}
  							}
  		);

  	}
  	else {
  		// update
  		// console.log("Update:");
  		// console.log(req.body);  		
  		db.query(`update dfl_interface set OPCO_ID=?, INTERFACE_TYPE=?, INTERFACE_NAME=?, INTERFACE_DESCRIPTION=?, CONNECTION_INFO=?, DOCU_LINK=?, IFC_SYSTEM_ID=?, IFC_CONTACT_ID=?, EXPERT_NAME=?
  							where INTERFACE_ID = ?`,
  							[req.body.OPCO_ID, req.body.INTERFACE_TYPE, req.body.INTERFACE_NAME, req.body.INTERFACE_DESCRIPTION, req.body.CONNECTION_INFO, req.body.DOCU_LINK, req.body.IFC_SYSTEM_ID, req.body.IFC_CONTACT_ID, req.body.EXPERT_NAME, req.body.INTERFACE_ID],
  							function (err, row) {
									if (!err) {
										res.json({success: true})
									}
									else {
										res.json({success: false, error: err});
										console.log(err);
									}  								
  							}
  		);  		
  	}
  }
  else if (req.params.apiEndpoint === "saveSystem") {
  	if (typeof req.body.SYSTEM_ID === 'undefined') {
  		// new system
  		db.query(`insert into amx_system (OPCO_ID, NAME, DESCRIPTION, DOCU_LINK) 
  							values (?,?,?,?)`,
  							[req.body.OPCO_ID, req.body.NAME, req.body.DESCRIPTION, req.body.DOCU_LINK],
  							function (err, row) {
									if (!err) {
										res.json({success: true})
									}
									else {
										res.json({success: false, error: err});
										console.log(err);
									}
  							}
  		);

  	}
  	else {
  		// update  		
  		db.query(`update amx_system set OPCO_ID=?, NAME=?, DESCRIPTION=?, DOCU_LINK=?
  							where SYSTEM_ID = ?`,
  							[req.body.OPCO_ID, req.body.NAME, req.body.DESCRIPTION, req.body.DOCU_LINK, req.body.SYSTEM_ID],
  							function (err, row) {
									if (!err) {
										res.json({success: true})
									}
									else {
										res.json({success: false, error: err});
										console.log(err);
									}  								
  							}
  		);  		
  	}
  }
  else {
  	res.json({success: false, error: 'Method not found: ' + req.params.apiEndpoint});
  }

}

export function deleteApiEndpoint(req, res, next) {

  if (req.params.apiEndpoint === "deleteDatasource") {
    db.query('delete from dfl_datasource where DATASOURCE_ID = ?', 
    	[req.query.datasourceId], 
	    function (err, row) {
	      if(err !== null) {
	      	console.log(err);
	        res.json({success: false, error: err});
	      }
	      else {
	        res.json({success: true});
	      }
	    });	
  }

  else if (req.params.apiEndpoint === "deleteInterface") {
    db.query('delete from dfl_interface where INTERFACE_ID = ?', 
    	[req.query.interfaceId], 
	    function (err, row) {
	      if(err !== null) {
	      	console.log(err);
	        res.json({success: false, error: err});
	      }
	      else {
	        res.json({success: true});
	      }
	    });	
  }
  else if (req.params.apiEndpoint === "deleteSystem") {
    db.query('delete from amx_system where SYSTEM_ID = ?', 
    	[req.query.systemId], 
	    function (err, row) {
	      if(err !== null) {
	      	console.log(err);
	        res.json({success: false, error: err});
	      }
	      else {
	        res.json({success: true});
	      }
	    });	
  }

  else {
  	res.json({success: false, error: 'Method not found: ' + req.params.apiEndpoint});
  }
}