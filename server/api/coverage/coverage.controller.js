/**
 * Using Rails-like standard naming convention for endpoints.
 * GET     /api/alarms              ->  index
 */

'use strict';

var db = require("../../utils/db");
var _und = require("underscore");
var async = require("async");

export function getApiEndpoint(req, res, next) {
  if (req.params.apiEndpoint === "getProcesses") {
    db.query(`select
								bp.BUSINESS_PROCESS_ID, 
						    bp.BUSINESS_PROCESS, 
						    bp.DESCRIPTION, 
						    bp.SOURCE
						from CVG_BUSINESS_PROCESS bp
						`, 
    	[],
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
  else if (req.params.apiEndpoint === "getProductGroups") {
    db.query(`select 
								PRODUCT_GROUP_ID,
						    LOB,
						    PRODUCT_GROUP,
						    'N' SELECTED
						from cvg_product_group
						`, 
    	[],
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
  else if (req.params.apiEndpoint === "getSubProcesses") {
    db.query(`select
								bp.BUSINESS_PROCESS_ID, 
						    bp.BUSINESS_PROCESS, 
						    bp.DESCRIPTION, 
						    bsp.BUSINESS_SUB_PROCESS_ID, 
						    bsp.BUSINESS_SUB_PROCESS
						from CVG_BUSINESS_PROCESS bp
						left join CVG_BUSINESS_SUB_PROCESS bsp on bsp.BUSINESS_PROCESS_ID = bp.BUSINESS_PROCESS_ID
						`, 
    	[],
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
  else if (req.params.apiEndpoint === "getSystems") {
    db.query(`
							select 
								s.* 
							from amx_system s
							where s.OPCO_ID = ?
							and s.SYSTEM_ID not in (
								select distinct ifnull(SYSTEM_ID, 0) 
								from cvg_risk_node a
								where RISK_ID = ? and PRODUCT_SEGMENT_ID = ?
							);
						`, 
    	[req.query.opcoId, req.query.riskId, req.query.productSegmentId],
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
  else if (req.params.apiEndpoint === "getRisks") {
    db.query(`select
								bp.BUSINESS_PROCESS_ID, 
						    bp.BUSINESS_PROCESS, 
						    bp.DESCRIPTION, 
						    bsp.BUSINESS_SUB_PROCESS_ID, 
						    bsp.BUSINESS_SUB_PROCESS, 
						    r.RISK_ID, 
						    r.RISK, 
						    r.RISK_CATEGORY, 
						    r.RISK_DESCRIPTION, 
						    r.SOURCE,
						    'N' SELECTED,
						    (select count(*) from CVG_SUB_RISK where RISK_ID = r.RISK_ID) SUB_RISK_COUNT,
						    (select count(distinct srml.MEASURE_ID) from CVG_SUB_RISK sr join CVG_SUB_RISK_MEASURE_LINK srml on srml.SUB_RISK_ID = sr.SUB_RISK_ID where sr.RISK_ID = r.RISK_ID) MEASURES_COUNT
							from CVG_BUSINESS_PROCESS bp
							left join CVG_BUSINESS_SUB_PROCESS bsp on bsp.BUSINESS_PROCESS_ID = bp.BUSINESS_PROCESS_ID
							left join CVG_RISK r on r.BUSINESS_SUB_PROCESS_ID = bsp.BUSINESS_SUB_PROCESS_ID
							order by bp.BUSINESS_PROCESS_ID, r.RISK_ID
						`, 
    	[],
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
  else if (req.params.apiEndpoint === "getRiskInfo") {
    db.query(`select
								bp.BUSINESS_PROCESS_ID, 
						    bp.BUSINESS_PROCESS, 
						    bp.DESCRIPTION, 
						    bsp.BUSINESS_SUB_PROCESS_ID, 
						    bsp.BUSINESS_SUB_PROCESS, 
						    r.RISK_ID, 
						    r.RISK, 
						    r.RISK_CATEGORY, 
						    r.RISK_DESCRIPTION, 
						    r.SOURCE,
						    'N' SELECTED,
						    (select count(*) from CVG_SUB_RISK where RISK_ID = r.RISK_ID) SUB_RISK_COUNT
						from CVG_BUSINESS_PROCESS bp
						left join CVG_BUSINESS_SUB_PROCESS bsp on bsp.BUSINESS_PROCESS_ID = bp.BUSINESS_PROCESS_ID
						left join CVG_RISK r on r.BUSINESS_SUB_PROCESS_ID = bsp.BUSINESS_SUB_PROCESS_ID
						where r.RISK_ID = ?
						`, 
    	[req.query.riskId],
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
  else if (req.params.apiEndpoint === "getSubRisks") {
    db.query(`select
						    sr.SUB_RISK_ID, 
						    sr.SUB_RISK, 
						    sr.BASE_LIKELIHOOD, 
						    sr.BASE_IMPACT, 
						    sr.RELEVANT, 
						    sr.REQUIRED,
						    sr.SOURCE,
						    'N' SELECTED
						from CVG_SUB_RISK sr
						where sr.RISK_ID = ?
						order by sr.SUB_RISK_ID
						`, 
    	[req.query.riskId],
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
  else if (req.params.apiEndpoint === "getAllSubRisks") {
    db.query(`select
						    sr.SUB_RISK_ID,
						    sr.RISK_ID, 
						    sr.SUB_RISK, 
						    sr.BASE_LIKELIHOOD, 
						    sr.BASE_IMPACT, 
						    sr.RELEVANT, 
						    sr.REQUIRED, 
						    sr.SOURCE						
						  from CVG_SUB_RISK sr
						`, 
    	[],
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
  else if (req.params.apiEndpoint === "getKeyRiskAreas") {
    db.query(`select 
								KEY_RISK_AREA_ID, 
						    KEY_RISK_AREA, 
						    KEY_RISK_AREA_DESCRIPTION,
						    (select count(*) from CVG_RISK_KEY_RISK_AREA_LINK where KEY_RISK_AREA_ID = a.KEY_RISK_AREA_ID) RISK_COUNT,
						    (select count(*) from CVG_PRODUCT_GROUP_KEY_RISK_AREA_LINK where KEY_RISK_AREA_ID = a.KEY_RISK_AREA_ID) PRODUCT_GROUP_COUNT,
						    (select 
									count(distinct a.BUSINESS_PROCESS_ID) 
									from CVG_BUSINESS_SUB_PROCESS a
									where a.BUSINESS_SUB_PROCESS_ID in (
										select r.BUSINESS_SUB_PROCESS_ID
									    from cvg_risk r
									    join CVG_RISK_KEY_RISK_AREA_LINK rkr on rkr.RISK_ID = r.RISK_ID 
									    where rkr.KEY_RISK_AREA_ID = a.KEY_RISK_AREA_ID
								)) BP_COUNT
							from CVG_KEY_RISK_AREA a
								`,
    	[],
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
  else if (req.params.apiEndpoint === "getKeyRiskArea") {
    db.query(`select 
								KEY_RISK_AREA_ID, 
						    KEY_RISK_AREA, 
						    KEY_RISK_AREA_DESCRIPTION
							from CVG_KEY_RISK_AREA
							where KEY_RISK_AREA_ID = ?
							`,
    	[req.query.keyRiskAreaId],
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
  else if (req.params.apiEndpoint === "getKeyRiskAreaProductGroups") {
    db.query(`SELECT 
								pg.PRODUCT_GROUP_ID,
								pg.LOB, 
							  pg.PRODUCT_GROUP,
							  'N' SELECTED
							FROM cvg_product_group pg
							join cvg_product_group_key_risk_area_link pgrlnk on pgrlnk.PRODUCT_GROUP_ID = pg.PRODUCT_GROUP_ID
							where pgrlnk.KEY_RISK_AREA_ID = ?
							order by 1
							`,
    	[req.query.keyRiskAreaId],
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
  else if (req.params.apiEndpoint === "getKeyRiskAreaRisks") {
    db.query(`select
								bp.BUSINESS_PROCESS_ID, 
								bp.BUSINESS_PROCESS, 
								bp.DESCRIPTION, 
								bsp.BUSINESS_SUB_PROCESS_ID, 
								bsp.BUSINESS_SUB_PROCESS, 
								r.RISK_ID, 
								r.RISK, 
								r.RISK_CATEGORY, 
								r.RISK_DESCRIPTION, 
								r.SOURCE,
								'N' SELECTED,
								(select count(*) from CVG_SUB_RISK where RISK_ID = r.RISK_ID) SUB_RISK_COUNT,
								(select count(*) from CVG_RISK_MEASURE_LINK where RISK_ID = r.RISK_ID) MEASURES_COUNT
							from CVG_BUSINESS_PROCESS bp
							left join CVG_BUSINESS_SUB_PROCESS bsp on bsp.BUSINESS_PROCESS_ID = bp.BUSINESS_PROCESS_ID
							left join CVG_RISK r on r.BUSINESS_SUB_PROCESS_ID = bsp.BUSINESS_SUB_PROCESS_ID
							join cvg_risk_key_risk_area_link ralnk on ralnk.RISK_ID = r.RISK_ID
							where ralnk.KEY_RISK_AREA_ID = ?
							order by bp.BUSINESS_PROCESS_ID, r.RISK_ID
							`,
    	[req.query.keyRiskAreaId],
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
  else if (req.params.apiEndpoint === "getKeyRiskAreaLandscape") {
    db.query(`select 
								cra.KEY_RISK_AREA_ID, 
							  cra.KEY_RISK_AREA, 
							  cra.KEY_RISK_AREA_DESCRIPTION, 
							  bp.BUSINESS_PROCESS,
							  bp.BUSINESS_PROCESS_ID,
								count(*) RISK_NODES,
						    count(distinct rn.product_segment_id) DISTINCT_PRODUCT_SEGMENTS,    
						    count(distinct cral.risk_id) DISTINCT_RISKS, 
						    count(distinct rn.system_id) DISTINCT_SYSTEMS,
						    sum(case when coverage > 0 then 1 else 0 end) RISK_NODES_WITH_CONTROLS,
						    sum(coverage)/count(*) COVERAGE,
						    ceil((sum(coverage)/count(*) +1)  / 10) * 10 CSS_CLASS
							from CVG_KEY_RISK_AREA cra
							left join CVG_RISK_KEY_RISK_AREA_LINK cral on cra.key_risk_area_id = cral.key_risk_area_id 
							left join CVG_PRODUCT_GROUP_KEY_RISK_AREA_LINK pgl on cra.key_risk_area_id = pgl.key_risk_area_id 
							left join CVG_RISK_NODE rn on rn.risk_id = cral.risk_id and rn.product_segment_id in (select PRODUCT_SEGMENT_ID from cvg_product_segment where PRODUCT_GROUP_ID = pgl.PRODUCT_GROUP_ID)
							left join CVG_RISK r on r.risk_id = rn.risk_id
							left join CVG_BUSINESS_SUB_PROCESS bsp on bsp.business_sub_process_id = r.business_sub_process_id
							left join CVG_BUSINESS_PROCESS bp on bp.business_process_id = bsp.business_process_id
							where ifnull(rn.OPCO_ID, ?) = ?
							group by 								
								cra.KEY_RISK_AREA_ID, 
							  cra.KEY_RISK_AREA, 
							  cra.KEY_RISK_AREA_DESCRIPTION, 
							  bp.BUSINESS_PROCESS,
							  bp.BUSINESS_PROCESS_ID
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
  else if (req.params.apiEndpoint === "getKeyRiskAreaLandscapeSums") {
    db.query(`select 
								cra.KEY_RISK_AREA_ID, 
							  cra.KEY_RISK_AREA, 
							  cra.KEY_RISK_AREA_DESCRIPTION, 
								count(*) RISK_NODES,
						    count(distinct rn.product_segment_id) DISTINCT_PRODUCT_SEGMENTS,    
						    count(distinct cral.risk_id) DISTINCT_RISKS, 
						    count(distinct rn.system_id) DISTINCT_SYSTEMS,
						    sum(case when coverage > 0 then 1 else 0 end) RISK_NODES_WITH_CONTROLS,
						    sum(coverage)/count(*) COVERAGE,
						    ceil((sum(coverage)/count(*) +1)  / 10) * 10 CSS_CLASS
							from CVG_KEY_RISK_AREA cra
							left join CVG_RISK_KEY_RISK_AREA_LINK cral on cra.key_risk_area_id = cral.key_risk_area_id
							left join CVG_PRODUCT_GROUP_KEY_RISK_AREA_LINK pgl on cra.key_risk_area_id = pgl.key_risk_area_id 
							left join CVG_RISK_NODE rn on rn.risk_id = cral.risk_id and rn.product_segment_id in (select PRODUCT_SEGMENT_ID from cvg_product_segment where PRODUCT_GROUP_ID = pgl.PRODUCT_GROUP_ID)
							where ifnull(rn.OPCO_ID, ?) = ?
							group by
								cra.KEY_RISK_AREA_ID, 
							  cra.KEY_RISK_AREA, 
							  cra.KEY_RISK_AREA_DESCRIPTION
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
  else if (req.params.apiEndpoint === "getMeasuresForRiskId") {
    db.query(`SELECT 
    						r.RISK_ID,
    						srml.SUB_RISK_ID,
								m.MEASURE_ID, 
								m.BUSINESS_PROCESS_ID, 
								m.BUSINESS_SUB_PROCESS_ID, 
								m.MEASURE_TYPE, 
								m.MEASURE_NAME, 
								m.MEASURE_DESCRIPTION, 
								m.TMF_REFERENCE, 
								m.TMF_ID, 
								m.SOURCE,
								m.RELEVANT,
								m.REQUIRED,
								'N' SELECTED 
							FROM cvg_risk r
							join cvg_sub_risk sr on sr.RISK_ID = r.RISK_ID
							join cvg_sub_risk_measure_link srml on srml.SUB_RISK_ID = sr.SUB_RISK_ID
							join cvg_measure m on m.MEASURE_ID = srml.MEASURE_ID 
							where r.RISK_ID = ?
							order by m.RELEVANT desc, m.REQUIRED desc, srml.SUB_RISK_ID 
								`,
    	[req.query.riskId],
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
  else if (req.params.apiEndpoint === "getUnlinkedMeasuresForSubRiskId") {
    db.query(`SELECT 
    						sr.SUB_RISK_ID,
								m.MEASURE_ID, 
								m.BUSINESS_PROCESS_ID, 
								m.BUSINESS_SUB_PROCESS_ID, 
								m.MEASURE_TYPE, 
								m.MEASURE_NAME, 
								m.MEASURE_DESCRIPTION, 
								m.TMF_REFERENCE, 
								m.TMF_ID, 
								m.SOURCE,
								m.RELEVANT,
								m.REQUIRED,
								'N' SELECTED 
							FROM cvg_sub_risk sr
							join cvg_risk r on r.RISK_ID = sr.RISK_ID
							join cvg_business_sub_process bsp on bsp.BUSINESS_SUB_PROCESS_ID = r.BUSINESS_SUB_PROCESS_ID
							join cvg_measure m on m.BUSINESS_PROCESS_ID = bsp.BUSINESS_PROCESS_ID 
							where sr.SUB_RISK_ID = ? and m.MEASURE_ID not in (select MEASURE_ID from cvg_sub_risk_measure_link where SUB_RISK_ID = sr.SUB_RISK_ID)
							order by m.RELEVANT desc, m.REQUIRED desc, sr.SUB_RISK_ID
								`,
    	[req.query.subRiskId],
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
  else if (req.params.apiEndpoint === "getUnlinkedMeasuresForRiskId") {
    db.query(`SELECT 
    						r.RISK_ID,
								m.MEASURE_ID, 
								m.BUSINESS_PROCESS_ID, 
								m.BUSINESS_SUB_PROCESS_ID, 
								m.MEASURE_TYPE, 
								m.MEASURE_NAME, 
								m.MEASURE_DESCRIPTION, 
								m.TMF_REFERENCE, 
								m.TMF_ID, 
								m.SOURCE,
								m.RELEVANT,
								m.REQUIRED,
								'N' SELECTED 
							FROM cvg_risk r
							join cvg_measure m on m.BUSINESS_SUB_PROCESS_ID = r.BUSINESS_SUB_PROCESS_ID 
							where r.RISK_ID = ? and m.MEASURE_ID not in (select MEASURE_ID from cvg_risk_measure_link where RISK_ID = r.RISK_ID)
							order by m.RELEVANT desc, m.REQUIRED desc, r.RISK_ID 							
								`,
    	[req.query.riskId],
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
  else if (req.params.apiEndpoint === "getProductSegments") {
    db.query(`SELECT 
								pg.PRODUCT_GROUP_ID, 
								ps.OPCO_ID, 
								pg.LOB, 
								pg.PRODUCT_GROUP, 
								ps.PRODUCT_SEGMENT_ID, 
								ps.PRODUCT_SEGMENT, 
								ps.VALUE PS_VALUE, 
								abs(ps.VALUE) / cvgGetTotalOpcoValue(ps.OPCO_ID) * 100 PS_TOTAL_VALUE_RATIO, 
								abs(ps.VALUE) / cvgGetOpcoLobValue(ps.OPCO_ID, pg.LOB) * 100 PS_LOB_VALUE_RATIO,
								abs(ps.VALUE) / cvgGetProductGroupValue(ps.OPCO_ID, pg.PRODUCT_GROUP_ID) * 100 PS_GROUP_VALUE_RATIO,
								cvgGetProductSegmentRiskCount(ps.PRODUCT_SEGMENT_ID) RISK_COUNT,
								cvgGetProductSegmentRPN(ps.PRODUCT_SEGMENT_ID) RPN_COUNT,
								cvgGetProductSegmentControlCount(ps.PRODUCT_SEGMENT_ID) CONTROL_COUNT,								
								cvgGetProductSegmentCoverage(ps.PRODUCT_SEGMENT_ID) COVERAGE,
								-- cvgGetProductSegmentMeasureCoverage(ps.PRODUCT_SEGMENT_ID) MEASURE_COVERAGE,
								'N' SELECTED
							from cvg_product_group pg 
							left join cvg_product_segment ps on ps.PRODUCT_GROUP_ID = pg.PRODUCT_GROUP_ID and ps.OPCO_ID = ?
							order by pg.LOB, pg.PRODUCT_GROUP, ps.PRODUCT_SEGMENT 
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
  else if (req.params.apiEndpoint === "getProductSegment") {
    db.query(`SELECT 
								pg.PRODUCT_GROUP_ID, 
								ps.OPCO_ID, 
								pg.LOB, 
								pg.PRODUCT_GROUP, 
								ps.PRODUCT_SEGMENT_ID, 
								ps.PRODUCT_SEGMENT, 
								ps.VALUE PS_VALUE,
								ps.VALUE_REFFERENCE,
								abs(ps.VALUE) / cvgGetTotalOpcoValue(ps.OPCO_ID) * 100 PS_TOTAL_VALUE_RATIO, 
								abs(ps.VALUE) / cvgGetOpcoLobValue(ps.OPCO_ID, pg.LOB) * 100 PS_LOB_VALUE_RATIO,
								abs(ps.VALUE) / cvgGetProductGroupValue(ps.OPCO_ID, pg.PRODUCT_GROUP_ID) * 100 PS_GROUP_VALUE_RATIO,
								cvgGetProductSegmentRiskCount(ps.PRODUCT_SEGMENT_ID) RISK_COUNT,
								cvgGetProductSegmentRPN(ps.PRODUCT_SEGMENT_ID) RPN_COUNT,
								cvgGetProductSegmentControlCount(ps.PRODUCT_SEGMENT_ID) CONTROL_COUNT,
								cvgGetProductSegmentCoverage(ps.PRODUCT_SEGMENT_ID) COVERAGE,
								cvgGetProductSegmentMeasureCoverage(ps.PRODUCT_SEGMENT_ID) MEASURE_COVERAGE,
								'N' SELECTED
							from cvg_product_group pg
							left join cvg_product_segment ps on ps.PRODUCT_GROUP_ID = pg.PRODUCT_GROUP_ID
							where ps.PRODUCT_SEGMENT_ID = ?
								`,
    	[req.query.productSegmentId],
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
  else if (req.params.apiEndpoint === "getProductSegmentSubRisks") {
    db.query(`							
    					select 
								rn.RISK_NODE_ID,
								sr.SUB_RISK_ID,
							    sr.SUB_RISK,
							    rnsr.LIKELIHOOD,
							    rnsr.IMPACT,
							    sr.BASE_LIKELIHOOD,
							    sr.BASE_IMPACT,
							    sr.SOURCE,
							    sr.RELEVANT,
							    sr.REQUIRED
							from cvg_risk_node rn
							join cvg_sub_risk sr on sr.RISK_ID = rn.RISK_ID 
							join cvg_risk_node_sub_risk rnsr on rnsr.RISK_NODE_ID = rn.RISK_NODE_ID and rnsr.SUB_RISK_ID = sr.SUB_RISK_ID							
							where rn.PRODUCT_SEGMENT_ID = ?
								`,
    	[req.query.productSegmentId],
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
	else if (req.params.apiEndpoint === "getSankeyProductSegment") {
    db.query(`
							select
								bsp.BUSINESS_SUB_PROCESS source,
								bp.BUSINESS_PROCESS target, 
								ifnull(sum(cvgGetRiskNodeRPN(rn.RISK_NODE_ID)),0) value
							from CVG_RISK_NODE rn
							join cvg_product_segment ps on ps.PRODUCT_SEGMENT_ID = rn.PRODUCT_SEGMENT_ID
							join CVG_RISK r on r.RISK_ID = rn.RISK_ID
							join CVG_BUSINESS_SUB_PROCESS bsp on bsp.BUSINESS_SUB_PROCESS_ID = r.BUSINESS_SUB_PROCESS_ID 
							join CVG_BUSINESS_PROCESS bp on bp.BUSINESS_PROCESS_ID = bsp.BUSINESS_PROCESS_ID 
							left join amx_system s on s.SYSTEM_ID = rn.SYSTEM_ID
							where 1=1
								and ifnull(rn.PRODUCT_SEGMENT_ID, '%') = ?
							group by 	
								bsp.BUSINESS_SUB_PROCESS,
								bp.BUSINESS_PROCESS

							union all 

							select
								bp.BUSINESS_PROCESS source,
								ifnull(s.NAME, 'No system assigned') target,
								ifnull(sum(cvgGetRiskNodeRPN(rn.RISK_NODE_ID)), 0) value
							from CVG_RISK_NODE rn
							join cvg_product_segment ps on ps.PRODUCT_SEGMENT_ID = rn.PRODUCT_SEGMENT_ID
							join CVG_RISK r on r.RISK_ID = rn.RISK_ID
							join CVG_BUSINESS_SUB_PROCESS bsp on bsp.BUSINESS_SUB_PROCESS_ID = r.BUSINESS_SUB_PROCESS_ID 
							join CVG_BUSINESS_PROCESS bp on bp.BUSINESS_PROCESS_ID = bsp.BUSINESS_PROCESS_ID 
							left join amx_system s on s.SYSTEM_ID = rn.SYSTEM_ID
							where 1=1
								and ifnull(rn.PRODUCT_SEGMENT_ID, '%') like ?
							group by
								bp.BUSINESS_PROCESS,
								ifnull(s.NAME, 'No system assigned')

							union all

							select
								ifnull(s.NAME, 'No system assigned') source,
							    'Covered' target,
								ifnull(sum(cvgGetRiskNodeRPN(rn.RISK_NODE_ID) * rn.COVERAGE/100),0) value
							from CVG_RISK_NODE rn
							join cvg_product_segment ps on ps.PRODUCT_SEGMENT_ID = rn.PRODUCT_SEGMENT_ID
							join CVG_RISK r on r.RISK_ID = rn.RISK_ID
							join CVG_BUSINESS_SUB_PROCESS bsp on bsp.BUSINESS_SUB_PROCESS_ID = r.BUSINESS_SUB_PROCESS_ID 
							join CVG_BUSINESS_PROCESS bp on bp.BUSINESS_PROCESS_ID = bsp.BUSINESS_PROCESS_ID 
							left join amx_system s on s.SYSTEM_ID = rn.SYSTEM_ID
							where 1=1
								and ifnull(rn.PRODUCT_SEGMENT_ID, '%') like ?
							group by
								ifnull(s.NAME, 'No system assigned')

							union all

							select
								ifnull(s.NAME, 'No system assigned') source,
							    'Not covered' target,
								ifnull(sum(cvgGetRiskNodeRPN(rn.RISK_NODE_ID) * (1-rn.COVERAGE/100)),0) value
							from CVG_RISK_NODE rn
							join cvg_product_segment ps on ps.PRODUCT_SEGMENT_ID = rn.PRODUCT_SEGMENT_ID
							join CVG_RISK r on r.RISK_ID = rn.RISK_ID
							join CVG_BUSINESS_SUB_PROCESS bsp on bsp.BUSINESS_SUB_PROCESS_ID = r.BUSINESS_SUB_PROCESS_ID 
							join CVG_BUSINESS_PROCESS bp on bp.BUSINESS_PROCESS_ID = bsp.BUSINESS_PROCESS_ID 
							left join amx_system s on s.SYSTEM_ID = rn.SYSTEM_ID
							where 1=1
								and ifnull(rn.PRODUCT_SEGMENT_ID, '%') like ?
							group by
								ifnull(s.NAME, 'No system assigned')

						`, 
    	[req.query.productSegmentId, req.query.productSegmentId, req.query.productSegmentId, req.query.productSegmentId],
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
	else if (req.params.apiEndpoint === "getSankeyOverview") {
    db.query(`
							select
								concat(pg.LOB, ' / ',pg.PRODUCT_GROUP) source,
								pg.LOB target,
								ifnull(cvgGetProductGroupValue(?, pg.PRODUCT_GROUP_ID),0) value
							from cvg_product_group pg

							union all

							select
								pg.LOB source,
							  'Covered' target,
								ifnull(sum(cvgGetRiskNodeValue(rn.RISK_NODE_ID) * rn.COVERAGE/100),0) value
							from CVG_RISK_NODE rn
							join cvg_product_segment ps on ps.PRODUCT_SEGMENT_ID = rn.PRODUCT_SEGMENT_ID
							join cvg_product_group pg on pg.PRODUCT_GROUP_ID = ps.PRODUCT_GROUP_ID
							join CVG_RISK r on r.RISK_ID = rn.RISK_ID
							join CVG_BUSINESS_SUB_PROCESS bsp on bsp.BUSINESS_SUB_PROCESS_ID = r.BUSINESS_SUB_PROCESS_ID 
							join CVG_BUSINESS_PROCESS bp on bp.BUSINESS_PROCESS_ID = bsp.BUSINESS_PROCESS_ID 
							left join amx_system s on s.SYSTEM_ID = rn.SYSTEM_ID
							where rn.OPCO_ID = ? 
							group by
								pg.LOB

							union all

							select
								pg.LOB source,
							  'Not covered' target,
								ifnull(sum(cvgGetRiskNodeValue(rn.RISK_NODE_ID) * (1-rn.COVERAGE/100)),0) value
							from CVG_RISK_NODE rn
							join cvg_product_segment ps on ps.PRODUCT_SEGMENT_ID = rn.PRODUCT_SEGMENT_ID
							join cvg_product_group pg on pg.PRODUCT_GROUP_ID = ps.PRODUCT_GROUP_ID
							join CVG_RISK r on r.RISK_ID = rn.RISK_ID
							join CVG_BUSINESS_SUB_PROCESS bsp on bsp.BUSINESS_SUB_PROCESS_ID = r.BUSINESS_SUB_PROCESS_ID 
							join CVG_BUSINESS_PROCESS bp on bp.BUSINESS_PROCESS_ID = bsp.BUSINESS_PROCESS_ID 
							left join amx_system s on s.SYSTEM_ID = rn.SYSTEM_ID
							where rn.OPCO_ID = ? 
							group by
								pg.LOB

							union all

							select
								'Covered' target,
								bp.BUSINESS_PROCESS target, 
								ifnull(sum(cvgGetRiskNodeValue(rn.RISK_NODE_ID) * rn.COVERAGE/100),0) value
							from CVG_RISK_NODE rn
							join cvg_product_segment ps on ps.PRODUCT_SEGMENT_ID = rn.PRODUCT_SEGMENT_ID
							join cvg_product_group pg on pg.PRODUCT_GROUP_ID = ps.PRODUCT_GROUP_ID
							join CVG_RISK r on r.RISK_ID = rn.RISK_ID
							join CVG_BUSINESS_SUB_PROCESS bsp on bsp.BUSINESS_SUB_PROCESS_ID = r.BUSINESS_SUB_PROCESS_ID 
							join CVG_BUSINESS_PROCESS bp on bp.BUSINESS_PROCESS_ID = bsp.BUSINESS_PROCESS_ID 
							left join amx_system s on s.SYSTEM_ID = rn.SYSTEM_ID
							where rn.OPCO_ID = ?
							group by 	
								bp.BUSINESS_PROCESS 

							union all

							select
								'Not covered' target,
								bp.BUSINESS_PROCESS target, 
								ifnull(sum(cvgGetRiskNodeValue(rn.RISK_NODE_ID) * (1-rn.COVERAGE/100)),0) value
							from CVG_RISK_NODE rn
							join cvg_product_segment ps on ps.PRODUCT_SEGMENT_ID = rn.PRODUCT_SEGMENT_ID
							join cvg_product_group pg on pg.PRODUCT_GROUP_ID = ps.PRODUCT_GROUP_ID
							join CVG_RISK r on r.RISK_ID = rn.RISK_ID
							join CVG_BUSINESS_SUB_PROCESS bsp on bsp.BUSINESS_SUB_PROCESS_ID = r.BUSINESS_SUB_PROCESS_ID 
							join CVG_BUSINESS_PROCESS bp on bp.BUSINESS_PROCESS_ID = bsp.BUSINESS_PROCESS_ID 
							left join amx_system s on s.SYSTEM_ID = rn.SYSTEM_ID
							where rn.OPCO_ID = ?
							group by 	
								bp.BUSINESS_PROCESS 								

						`,
    	[req.query.opcoId, req.query.opcoId, req.query.opcoId, req.query.opcoId, req.query.opcoId],
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
  else if (req.params.apiEndpoint === "getControls") {
    db.query(`
							select c.*, 
							case 
								when s.SYSTEM_ID is not null then 1 
								else 0 
							end SAME_SYSTEM  
							from v_cvg_control c
							left join cvg_control_system_mix s on s.CVG_CONTROL_ID = c.CONTROL_ID and s.SYSTEM_ID = ?
							where c.opco_id = ?
							order by 							
							case 
								when s.SYSTEM_ID is not null then 1 
								else 0 
							end desc, c.CONTROL_TYPE
						`,
    	[req.query.systemId, req.query.opcoId],
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
  else if (req.params.apiEndpoint === "getRiskNodeControls") {
    db.query(`
						select c.* from cvg_risk_node_control rnc
						join v_cvg_control c on c.CONTROL_ID = rnc.CONTROL_ID
						where RISK_NODE_ID = ?
						`,
    	[req.query.riskNodeId],
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
  else if (req.params.apiEndpoint === "getControlDetails") {
    db.query(`
						SELECT 
							rnc.EFFECTIVENESS,
							rn.RISK_NODE_ID,
						    pg.LOB,
						    pg.PRODUCT_GROUP,
						    ps.PRODUCT_SEGMENT,    
						    ps.PRODUCT_SEGMENT_ID,    
						    ps.VALUE PRODUCT_SEGMENT_VALUE,
								r.RISK,
						    r.RISK_CATEGORY,
						    r.RISK_DESCRIPTION,
						    r.RISK_ID,
						    bp.BUSINESS_PROCESS_ID,
						    bp.BUSINESS_PROCESS,
						    bsp.BUSINESS_SUB_PROCESS,
						    s.NAME SYSTEM_NAME
						FROM cvg_risk_node_control rnc 
						join cvg_risk_node rn on rn.RISK_NODE_ID = rnc.RISK_NODE_ID
						join cvg_product_segment ps on ps.PRODUCT_SEGMENT_ID = rn.PRODUCT_SEGMENT_ID
						join cvg_product_group pg on pg.PRODUCT_GROUP_ID = ps.PRODUCT_GROUP_ID
						join cvg_risk r on r.RISK_ID = rn.RISK_ID
						join cvg_business_sub_process bsp on bsp.BUSINESS_SUB_PROCESS_ID = r.BUSINESS_SUB_PROCESS_ID 
						join cvg_business_process bp on bp.BUSINESS_PROCESS_ID = bsp.BUSINESS_PROCESS_ID 
						left join amx_system s on s.SYSTEM_ID = rn.SYSTEM_ID
						where rnc.CONTROL_ID = ?
						order by ps.PRODUCT_SEGMENT_ID, r.RISK_ID;
						`,
    	[req.query.controlId],
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
  else if (req.params.apiEndpoint === "getCloneOtherProductSegment") {
    db.query(`SELECT 
								pg.PRODUCT_GROUP_ID, 
								ps.OPCO_ID, 
								pg.LOB, 
								pg.PRODUCT_GROUP, 
								ps.PRODUCT_SEGMENT_ID, 
								ps.PRODUCT_SEGMENT, 
								ps.VALUE PS_VALUE, 
								abs(ps.VALUE) / cvgGetTotalOpcoValue(ps.OPCO_ID) * 100 PS_TOTAL_VALUE_RATIO, 
								abs(ps.VALUE) / cvgGetOpcoLobValue(ps.OPCO_ID, pg.LOB) * 100 PS_LOB_VALUE_RATIO,
								abs(ps.VALUE) / cvgGetProductGroupValue(ps.OPCO_ID, pg.PRODUCT_GROUP_ID) * 100 PS_GROUP_VALUE_RATIO,
								cvgGetProductSegmentRiskCount(ps.PRODUCT_SEGMENT_ID) RISK_COUNT,
								cvgGetProductSegmentRPN(ps.PRODUCT_SEGMENT_ID) RPN_COUNT,
								cvgGetProductSegmentControlCount(ps.PRODUCT_SEGMENT_ID) CONTROL_COUNT,								
								cvgGetProductSegmentCoverage(ps.PRODUCT_SEGMENT_ID) COVERAGE,
								-- cvgGetProductSegmentMeasureCoverage(ps.PRODUCT_SEGMENT_ID) MEASURE_COVERAGE,
								'N' SELECTED
							from cvg_product_group pg 
							left join cvg_product_segment ps on ps.PRODUCT_GROUP_ID = pg.PRODUCT_GROUP_ID
							where ps.OPCO_ID = ? and PRODUCT_SEGMENT_ID != ?
							order by pg.LOB, pg.PRODUCT_GROUP, ps.PRODUCT_SEGMENT 
								`,
    	[req.query.opcoId, req.query.productSegmentId],
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
  else if (req.params.apiEndpoint === "getExecuteCloneOtherProductSegment") {
    db.query(`call cvgCloneProductSegment(?, ?);`,
    	[req.query.cloneFromProductSegmentId, req.query.cloneToProductSegmentId],
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
  else if (req.params.apiEndpoint === "getExecuteCloneRiskNodeToProductSegment") {
    db.query(`call cvgCloneRiskNodeToProductSegment(?, ?);`,
    	[req.query.cloneFromRiskNodeId, req.query.cloneToProductSegmentId],
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
  else if (req.params.apiEndpoint === "getCloneControlsRiskNodes") {
    db.query(`
						select 
							rn2.RISK_NODE_ID,
							pg2.LOB,
							pg2.PRODUCT_GROUP,
							ps2.PRODUCT_SEGMENT,    
							ps2.PRODUCT_SEGMENT_ID,
							s.SYSTEM_ID,
							s.NAME SYSTEM_NAME,
						  rn2.CTRL_COUNT,
						  rn2.METRIC_COUNT,
							case when (rn2.product_segment_id - rn.product_segment_id) = 0 then 1 else 0 end SAME_PRODUCT_SEGMENT,
							case when (pg2.product_group_id - pg.product_group_id) = 0 then 1 else 0 end SAME_PRODUCT_GROUP,
							case when (ifnull(rn2.system_id, 0) - ifnull(rn.system_id,0)) = 0 then 1 else 0 end SAME_SYSTEM
						from cvg_risk_node rn
						join cvg_product_segment ps on ps.PRODUCT_SEGMENT_ID = rn.PRODUCT_SEGMENT_ID
						join cvg_product_group pg on pg.PRODUCT_GROUP_ID = ps.PRODUCT_GROUP_ID						
						join (
							select 
								srn.*,
								(select count(*) from cvg_risk_node_control a join cvg_control b on b.control_id = a.control_id where RISK_NODE_ID = srn.RISK_NODE_ID and CONTROL_TYPE='C') ctrl_count,
								(select count(*) from cvg_risk_node_control a join cvg_control b on b.control_id = a.control_id where RISK_NODE_ID = srn.RISK_NODE_ID and CONTROL_TYPE='M') metric_count,
						    (select count(*) from cvg_risk_node_control where RISK_NODE_ID = srn.RISK_NODE_ID) ctrl_count_tmp
							from cvg_risk_node srn
							where exists (select * from cvg_risk_node_control where RISK_NODE_ID = srn.RISK_NODE_ID)
						) rn2 on rn2.risk_id = rn.risk_id and rn2.OPCO_ID = rn.OPCO_ID
						join cvg_product_segment ps2 on ps2.PRODUCT_SEGMENT_ID = rn2.PRODUCT_SEGMENT_ID
						join cvg_product_group pg2 on pg2.PRODUCT_GROUP_ID = ps2.PRODUCT_GROUP_ID
						left join amx_system s on s.SYSTEM_ID = rn2.SYSTEM_ID 
						where rn.risk_node_id != rn2.risk_node_id and rn.risk_node_id = ?
						order by 
							case when (rn2.product_segment_id - rn.product_segment_id) = 0 then 1 else 0 end desc,
							case when (pg2.product_group_id - pg.product_group_id) = 0 then 1 else 0 end desc,
							case when rn2.system_id is null then 0 else 1 end desc,
							case when (ifnull(rn2.system_id, 0) - ifnull(rn.system_id,0)) = 0 then 1 else 0 end desc
						limit 10;
						`,
    	[req.query.riskNodeId],
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
  else if (req.params.apiEndpoint === "getExecuteCloneControlsRiskNodes") {
    db.query(`call cvgCloneControls(?, ?);`,
    	[req.query.riskNodeIdFrom, req.query.riskNodeIdTo],
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
  else if (req.params.apiEndpoint === "getHeatMapData") {
    db.query(`
				select 
					pg.LOB,
					pg.PRODUCT_GROUP,
					ps.PRODUCT_SEGMENT,
				  bp.BUSINESS_PROCESS,
				  bp.BUSINESS_PROCESS_ID,
				  bsp.BUSINESS_SUB_PROCESS,
				  r.RISK,
					ifnull(s.NAME, 'Undefined') SYSTEM_NAME,
				  cvgGetRiskNodeRPN(rn.RISK_NODE_ID) RPN_VALUE,
				  cvgGetRiskNodeValue(rn.RISK_NODE_ID) EUR_VALUE,
				  cvgGetRiskNodeCoverage(rn.RISK_NODE_ID) COVERAGE,
					(select count(*) from cvg_risk_node_control where risk_node_id = rn.risk_node_id) CONTROLS_COUNT
				from cvg_product_segment ps
				join cvg_product_group pg on pg.product_group_id = ps.product_group_id
				join cvg_risk_node rn on rn.product_segment_id = ps.product_segment_id
				join cvg_risk r on r.risk_id = rn.risk_id
				join cvg_business_sub_process bsp on bsp.business_sub_process_id = r.business_sub_process_id
				join cvg_business_process bp on bp.business_process_id = bsp.business_process_id
				left join amx_system s on s.SYSTEM_ID = rn.SYSTEM_ID
				where ps.OPCO_ID = ?
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
  else {
  	  	res.json({success: false, error: 'Method not found: ' + req.params.apiEndpoint});
  }

}








export function postApiEndpoint(req, res, next) {

	var refreshPage = false;

  if (req.params.apiEndpoint === "postRisk") {
  	// Insert Risk 
  	if (!req.body.risk.RISK_ID) {
			db.query(`INSERT INTO cvg_risk
									(	
										BUSINESS_SUB_PROCESS_ID,
										RISK,
										RISK_CATEGORY,
										RISK_DESCRIPTION,
										SOURCE
									)
									VALUES (?, ?, ?, ?, ?)`,
									[
										req.body.risk.BUSINESS_SUB_PROCESS_ID,
										req.body.risk.RISK,
										req.body.risk.RISK_CATEGORY,
										req.body.risk.RISK_DESCRIPTION,
										req.body.risk.SOURCE?req.body.risk.SOURCE:'TAG'
									],
								function(err, row) {
									if(err) {
									  console.log(err);
									  res.json({success: false, error: err});
									}
									else {
										var riskId = row.insertId;
										async.forEach(req.body.subRisks, 
											function(subRisk, callback) {
												if (!subRisk.SUB_RISK_ID) {
													db.query(`insert into cvg_sub_risk (RISK_ID, SUB_RISK, BASE_LIKELIHOOD, BASE_IMPACT, RELEVANT, REQUIRED, SOURCE) 
																	values (?,?,?,?,?,?,?)`,
																	[riskId, subRisk.SUB_RISK, subRisk.BASE_LIKELIHOOD, subRisk.BASE_IMPACT, subRisk.RELEVANT, subRisk.REQUIRED, subRisk.SOURCE],
																	function(err, row) {
																		if(err) {
																		  console.log(err);
																		}
																		callback();
																	});
												}
												else {
													db.query(`update cvg_sub_risk 
																		set RISK_ID=?, SUB_RISK=?, BASE_LIKELIHOOD=?, BASE_IMPACT=?, RELEVANT=?, REQUIRED=?, SOURCE=?
																		where SUB_RISK_ID = ?`,
																	[riskId, subRisk.RISK_ID, subRisk.SUB_RISK, subRisk.BASE_LIKELIHOOD, subRisk.BASE_IMPACT, subRisk.RELEVANT, subRisk.REQUIRED, subRisk.SOURCE, subRisk.SUB_RISK_ID],
																	function(err, row) {
																		if(err) {
																		  console.log(err);
																		}																		
																		callback();
																	});													
												}

											},
											function(){
									  		res.json({success: true, RISK_ID: riskId});
											});
									}
								}); 
  	}
  	else {
  		// Update risk

			db.query(`UPDATE cvg_risk
								set
										BUSINESS_SUB_PROCESS_ID=?,
										RISK=?,
										RISK_CATEGORY=?,
										RISK_DESCRIPTION=?,
										SOURCE=?
								where RISK_ID = ?`,
									[
										req.body.risk.BUSINESS_SUB_PROCESS_ID,
										req.body.risk.RISK,
										req.body.risk.RISK_CATEGORY,
										req.body.risk.RISK_DESCRIPTION,
										req.body.risk.SOURCE?req.body.risk.SOURCE:'TAG',
										req.body.risk.RISK_ID
									],
								function(err, row) {
									if(err) {
									  console.log(err);
									  res.json({success: false, error: err});
									}
									else {
										var riskId = req.body.risk.RISK_ID;
										async.forEach(req.body.subRisks, 
											function(subRisk, callback) {
												if (!subRisk.SUB_RISK_ID) {
													db.query(`insert into cvg_sub_risk (RISK_ID, SUB_RISK, BASE_LIKELIHOOD, BASE_IMPACT, RELEVANT, REQUIRED, SOURCE) 
																	values (?,?,?,?,?,?,?)`,
																	[riskId, subRisk.SUB_RISK, subRisk.BASE_LIKELIHOOD, subRisk.BASE_IMPACT, subRisk.RELEVANT, subRisk.REQUIRED, subRisk.SOURCE],
																	function(err, row) {
																		if(err) {
																		  console.log(err);
																		}
																		callback();
																	});
												}
												else {
													db.query(`update cvg_sub_risk 
																		set RISK_ID=?, SUB_RISK=?, BASE_LIKELIHOOD=?, BASE_IMPACT=?, RELEVANT=?, REQUIRED=?, SOURCE=?
																		where SUB_RISK_ID = ?`,
																	[riskId, subRisk.SUB_RISK, subRisk.BASE_LIKELIHOOD, subRisk.BASE_IMPACT, subRisk.RELEVANT, subRisk.REQUIRED, subRisk.SOURCE, subRisk.SUB_RISK_ID],
																	function(err, row) {
																		if(err) {
																		  console.log(err);
																		}																		
																		callback();
																	});													
												}

											},
											function(){
									  		res.json({success: true});
											});
									}
								}); 

  	}

  }
	else if (req.params.apiEndpoint === "getRiskNodes") {
    db.query(`
							select
								bp.BUSINESS_PROCESS_ID, 
								bp.BUSINESS_PROCESS, 
								bsp.BUSINESS_SUB_PROCESS_ID, 
								bsp.BUSINESS_SUB_PROCESS,
								rn.RISK_NODE_ID,
								rn.RISK_ID,
								rn.PRODUCT_SEGMENT_ID,
								rn.SYSTEM_ID,
								rn.COMMENT,
								ps.OPCO_ID,
								r.RISK, 
								r.RISK_DESCRIPTION,
								r.RISK_CATEGORY, 
								s.NAME SYSTEM_NAME,
								'N' SELECTED,
								(select count(*) from cvg_risk_node_sub_risk where RISK_NODE_ID = rn.RISK_NODE_ID) SUB_RISK_COUNT,
								cvgGetRiskNodeRPN(rn.RISK_NODE_ID) RPN_COUNT,                            
								(select count(*) from cvg_risk_node_control where RISK_NODE_ID = rn.RISK_NODE_ID) CONTROL_COUNT,
								cvgGetRiskNodeCoverage(rn.RISK_NODE_ID) COVERAGE,
								cvgGetRiskNodeMeasureCoverage(rn.RISK_NODE_ID) MEASURE_COVERAGE,
								(select 
										group_concat(
											case 
												when control_type = 'C' then concat('<i class="fa fa-area-chart"></i> ', CONTROL_NAME)
										        else concat('<i class="fa fa-line-chart"></i> ', CONTROL_NAME) 
											end SEPARATOR '<br>'
										)									
									from cvg_risk_node_control rnc
									join v_cvg_control c on c.CONTROL_ID = rnc.CONTROL_ID
									where RISK_NODE_ID = rn.RISK_NODE_ID
									group by RISK_NODE_ID) CONTROLS_LIST
							from CVG_RISK_NODE rn
							join cvg_product_segment ps on ps.PRODUCT_SEGMENT_ID = rn.PRODUCT_SEGMENT_ID
							join CVG_RISK r on r.RISK_ID = rn.RISK_ID
							join CVG_BUSINESS_SUB_PROCESS bsp on bsp.BUSINESS_SUB_PROCESS_ID = r.BUSINESS_SUB_PROCESS_ID 
							join CVG_BUSINESS_PROCESS bp on bp.BUSINESS_PROCESS_ID = bsp.BUSINESS_PROCESS_ID 
							left join amx_system s on s.SYSTEM_ID = rn.SYSTEM_ID
							where 1=1
								and ifnull(rn.PRODUCT_SEGMENT_ID, '%') like ?
								and ifnull(rn.RISK_ID, '%') like ?
								and ifnull(rn.SYSTEM_ID, '%') like ?
								and ifnull(ps.OPCO_ID, '%') like ?
						`, 
    	[
    		(req.body.PRODUCT_SEGMENT_ID?req.body.PRODUCT_SEGMENT_ID:'%'),
    		(req.body.RISK_ID?req.body.RISK_ID:'%'),
    		(req.body.SYSTEM_ID?req.body.SYSTEM_ID:'%'),
    		(req.body.OPCO_ID?req.body.OPCO_ID:'%')
    	],
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
	else if (req.params.apiEndpoint === "getRiskNodeDetails") {
		
		var returnNode = {};
		async.series([
				// get general info
		    function(callback) {
			    	db.query(
			    		`
							select
								bp.BUSINESS_PROCESS_ID, 
								bp.BUSINESS_PROCESS, 
								bsp.BUSINESS_SUB_PROCESS_ID, 
								bsp.BUSINESS_SUB_PROCESS,
								rn.RISK_NODE_ID,
								rn.RISK_ID,
								rn.PRODUCT_SEGMENT_ID,
								rn.SYSTEM_ID,
								rn.COMMENT,
								ps.OPCO_ID,
								r.RISK, 
								r.RISK_DESCRIPTION, 
								r.RISK_CATEGORY, 
								s.NAME SYSTEM_NAME,
								'N' SELECTED,
								(select count(*) from cvg_risk_node_sub_risk where RISK_NODE_ID = rn.RISK_NODE_ID) SUB_RISK_COUNT,
								cvgGetRiskNodeRPN(rn.RISK_NODE_ID) RPN_COUNT,                            
								(select count(*) from cvg_risk_node_control where RISK_NODE_ID = rn.RISK_NODE_ID) CONTROL_COUNT,
								cvgGetRiskNodeCoverage(rn.RISK_NODE_ID) COVERAGE,
								cvgGetRiskNodeMeasureCoverage(rn.RISK_NODE_ID) MEASURE_COVERAGE
							from CVG_RISK_NODE rn
							join cvg_product_segment ps on ps.PRODUCT_SEGMENT_ID = rn.PRODUCT_SEGMENT_ID
							join CVG_RISK r on r.RISK_ID = rn.RISK_ID
							join CVG_BUSINESS_SUB_PROCESS bsp on bsp.BUSINESS_SUB_PROCESS_ID = r.BUSINESS_SUB_PROCESS_ID 
							join CVG_BUSINESS_PROCESS bp on bp.BUSINESS_PROCESS_ID = bsp.BUSINESS_PROCESS_ID 
							left join amx_system s on s.SYSTEM_ID = rn.SYSTEM_ID
							where 1=1
								and rn.RISK_NODE_ID=?								
							`,
			    	[
			    		req.body.RISK_NODE_ID
			    	],
			    	function (err, row) {
				      if(err !== null) {
				      	console.log(err);
				        callback();
				      }
				      else {
				        returnNode.RISK_NODE = row[0];
				        callback();
				      }
						});
		    },
				// get sub-risks
		    function(callback) {
			    	db.query(
			    		`
							select 
									sr.SUB_RISK_ID,
							    sr.SUB_RISK,
							    sr.BASE_LIKELIHOOD,
							    sr.BASE_IMPACT,
							    sr.SOURCE,
							    sr.RELEVANT,
							    sr.REQUIRED,
							    ifnull(rnsr.RN_SUB_RISK_ID, 'NA') RN_SUB_RISK_ID,
							    ifnull(rnsr.LIKELIHOOD, sr.BASE_LIKELIHOOD) LIKELIHOOD,
							    ifnull(rnsr.IMPACT, sr.BASE_IMPACT) IMPACT,
							    rnsr.COVERAGE,
							    rnsr.FIXED,
							    'N' SELECTED
							from cvg_risk_node rn
							join cvg_sub_risk sr on sr.RISK_ID = rn.RISK_ID
							left join cvg_risk_node_sub_risk rnsr on rnsr.RISK_NODE_ID = rn.RISK_NODE_ID and rnsr.SUB_RISK_ID = sr.SUB_RISK_ID
							where rn.RISK_NODE_ID = ? 
							order by -rnsr.RN_SUB_RISK_ID desc, sr.SUB_RISK_ID										
							`,
			    	[
			    		req.body.RISK_NODE_ID
			    	],
			    	function (err, row) {
				      if(err !== null) {
				      	console.log(err);
				        callback();
				      }
				      else {
				        returnNode.SUB_RISKS = row;
				        callback();
				      }
						});
		    },
				// get measures
		    function(callback) {
			    	db.query(
			    		`
							select 
								sr.SUB_RISK_ID,
								m.MEASURE_ID, 
								m.BUSINESS_PROCESS_ID, 
								m.BUSINESS_SUB_PROCESS_ID, 
								m.MEASURE_TYPE, 
								m.MEASURE_NAME, 
								m.MEASURE_DESCRIPTION, 
								m.TMF_REFERENCE, 
								m.TMF_ID, 
								m.SOURCE,
								m.RELEVANT,
								m.REQUIRED,
								'N' SELECTED 
							from cvg_risk_node rn
							join cvg_sub_risk sr on sr.RISK_ID = rn.RISK_ID
							left join cvg_risk_node_sub_risk rnsr on rnsr.RISK_NODE_ID = rn.RISK_NODE_ID and rnsr.SUB_RISK_ID = sr.SUB_RISK_ID
              join cvg_sub_risk_measure_link srml on srml.SUB_RISK_ID = rnsr.SUB_RISK_ID
              join cvg_measure m on m.MEASURE_ID = srml.MEASURE_ID
							where rn.RISK_NODE_ID = ?
							order by -rnsr.RN_SUB_RISK_ID desc, sr.SUB_RISK_ID											
							`,
			    	[
			    		req.body.RISK_NODE_ID
			    	],
			    	function (err, row) {
				      if(err !== null) {
				      	console.log(err);
				        callback();
				      }
				      else {
				        returnNode.MEASURES = row;
				        callback();
				      }
						});
		    },
				// get controls
		    function(callback) {
			    	db.query(
			    		`
							select 
								vc.*,
								rnc.EFFECTIVENESS,
								ifnull(rnc.RN_CONTROL_ID, 'NA') RN_CONTROL_ID,
								'N' SELECTED
							from cvg_risk_node rn
							join cvg_risk_node_control rnc on rnc.RISK_NODE_ID = rn.RISK_NODE_ID
							join v_cvg_control vc on vc.CONTROL_ID = rnc.CONTROL_ID
							where rn.RISK_NODE_ID = ?					
							`,
			    	[
			    		req.body.RISK_NODE_ID
			    	],
			    	function (err, row) {
				      if(err !== null) {
				      	console.log(err);
				        callback();
				      }
				      else {
				        returnNode.CONTROLS = row;
				      	_und.forEach(row, function(control) {
				      		db.query(`call cvgRefreshControlCoverage(?);`, [control.CONTROL_ID]);
				      	});
				        callback();
				      }
						});
		    },
				// get control -> sub-risk links
		    function(callback) {
			    	db.query(
			    		`
							select *
							from cvg_risk_node_control_sub_risk_link rn
							where RN_CONTROL_ID in (select RN_CONTROL_ID from cvg_risk_node_control where RISK_NODE_ID = ?)
							`,
			    	[
			    		req.body.RISK_NODE_ID
			    	],
			    	function (err, row) {
				      if(err !== null) {
				      	console.log(err);
				        callback();
				      }
				      else {
				        returnNode.CTRL_SUB_RISKS = _und.groupBy(row, 'RN_CONTROL_ID');
				        callback();
				      }
						});
		    },
				// get control -> measure links
		    function(callback) {
			    	db.query(
			    		`
							select *
							from cvg_risk_node_control_measure_link rn
							where RN_CONTROL_ID in (select RN_CONTROL_ID from cvg_risk_node_control where RISK_NODE_ID = ?)
							`,
			    	[
			    		req.body.RISK_NODE_ID
			    	],
			    	function (err, row) {
				      if(err !== null) {
				      	console.log(err);
				        callback();
				      }
				      else {
				        returnNode.CTRL_MEASURES = _und.groupBy(row, 'RN_CONTROL_ID');
				        callback();
				      }
						});		    }, 
		    function(err, results) {
					res.json(returnNode);
				}
		]);

  }    
  else if (req.params.apiEndpoint === "postRiskNodes") {
		refreshPage = false;
		
		async.forEach(req.body, 
			function(riskNode, callback) {

				if (riskNode.RISK_NODE_ID) {
					// Update
					db.query(`update cvg_risk_node 
										set OPCO_ID=?, PRODUCT_SEGMENT_ID=?, RISK_ID=?, SYSTEM_ID=?, COVERAGE=cvgGetRiskNodeCoverage(?), MEASURE_COVERAGE=cvgGetRiskNodeMeasureCoverage(?)
										where RISK_NODE_ID=?`,
										[riskNode.OPCO_ID, riskNode.PRODUCT_SEGMENT_ID, riskNode.RISK_ID, riskNode.SYSTEM_ID, riskNode.RISK_NODE_ID, riskNode.RISK_NODE_ID, riskNode.RISK_NODE_ID],
										function(err, row) {
											if(err) {
											  console.log(err);
											  refreshPage = true;
											}
											callback();
										});
				}
				else {
					// Insert
					db.query(`replace into cvg_risk_node (OPCO_ID, PRODUCT_SEGMENT_ID, RISK_ID, SYSTEM_ID, COVERAGE, MEASURE_COVERAGE) 
										values (?,?,?,?,?,?)`,
										[riskNode.OPCO_ID, riskNode.PRODUCT_SEGMENT_ID, riskNode.RISK_ID, riskNode.SYSTEM_ID, riskNode.COVERAGE, riskNode.MEASURE_COVERAGE],
										function(err, row) {
											if(err) {
											  console.log(err);
											}
											else {
												if (row && row.insertId) {
													riskNode.RISK_NODE_ID = row.insertId;
													// Copy sub risks
													db.query(`replace into cvg_risk_node_sub_risk (RISK_NODE_ID, SUB_RISK_ID, LIKELIHOOD, IMPACT)
																		select ? RISK_NODE_ID, SUB_RISK_ID, BASE_LIKELIHOOD, BASE_IMPACT from cvg_sub_risk
																		where RISK_ID=?`,
																		[row.insertId, riskNode.RISK_ID],
																		function(err, row) {
																			if(err) {
																			  console.log(err);
																			  refreshPage = true;
																			}
																		});
												}
											}

											callback();
										});
				}
			},
			function(){
	  		res.json({success: true, refreshPage: refreshPage, RISK_NODES: req.body});
			});
  }  
  else if (req.params.apiEndpoint === "postRiskNode") {
		refreshPage = false;
		var riskNode = req.body;

		async.series([
			// Insert or update node 
			function(callback) {
				if (riskNode.RISK_NODE_ID) {
					db.query(`update cvg_risk_node 
										set OPCO_ID=?, PRODUCT_SEGMENT_ID=?, RISK_ID=?, SYSTEM_ID=?, COVERAGE=?, MEASURE_COVERAGE=?
										where RISK_NODE_ID=?`,
										[riskNode.OPCO_ID, riskNode.PRODUCT_SEGMENT_ID, riskNode.RISK_ID, riskNode.SYSTEM_ID, riskNode.COVERAGE, riskNode.MEASURE_COVERAGE, riskNode.RISK_NODE_ID],
										function(err, row) {
											if(err) {
											  console.log(err);
											  refreshPage = true;
											}
											callback();
										});
				}
				else {
					db.query(`insert into cvg_risk_node (OPCO_ID, PRODUCT_SEGMENT_ID, RISK_ID, SYSTEM_ID, COVERAGE, MEASURE_COVERAGE) 
										values (?,?,?,?,?,?)`,
										[riskNode.OPCO_ID, riskNode.PRODUCT_SEGMENT_ID, riskNode.RISK_ID, riskNode.SYSTEM_ID, riskNode.COVERAGE, riskNode.MEASURE_COVERAGE],
										function(err, row) {
											if(err) {
											  console.log(err);
											}
											else {
												if (row && row.insertId) {
													riskNode.RISK_NODE_ID = row.insertId;
												}
											}
											callback();
										});
				}
			},
			// Insert or update Sub-risks
		  function(callback){

					async.forEach(riskNode.SUB_RISKS, 
						function(subRisk, forEachcallback) {

							if (subRisk.RN_SUB_RISK_ID) {
								db.query(`update cvg_risk_node_sub_risk 
													set LIKELIHOOD=?, IMPACT=?, COVERAGE=?, FIXED=?
													where RN_SUB_RISK_ID=?`,
													[(subRisk.LIKELIHOOD?subRisk.LIKELIHOOD:0), (subRisk.IMPACT?subRisk.IMPACT:0), (subRisk.COVERAGE?subRisk.COVERAGE:0), (subRisk.FIXED?subRisk.FIXED:'N'), subRisk.RN_SUB_RISK_ID],
													function(err, row) {
														if(err) {
														  console.log(err);
														}														
														forEachcallback();
													});
							} 
							else {
								db.query(`insert into cvg_risk_node_sub_risk (RISK_NODE_ID, SUB_RISK_ID, LIKELIHOOD, IMPACT, COVERAGE, FIXED)
													values(?,?,?,?,?,?)`,
													[riskNode.RISK_NODE_ID, subRisk.SUB_RISK_ID, (subRisk.LIKELIHOOD?subRisk.LIKELIHOOD:0), (subRisk.IMPACT?subRisk.IMPACT:0), (subRisk.COVERAGE?subRisk.COVERAGE:0), (subRisk.FIXED?subRisk.FIXED:'N')],
													function(err, row) {
														if(err) {
														  console.log(err);
														}														
														forEachcallback();
													});
							}
						},
						function() {callback();}
					);

		  },
			// Insert or update controls
		  function(callback){

					async.forEach(riskNode.CONTROLS, 
						function(control, forEachcallback) {

							if (control.RN_CONTROL_ID) {
								db.query(`update cvg_risk_node_control 
													set RISK_NODE_ID=?, CONTROL_ID=?, EFFECTIVENESS=?
													where RN_CONTROL_ID=?`,
													[riskNode.RISK_NODE_ID, control.CONTROL_ID, control.EFFECTIVENESS, control.RN_CONTROL_ID],
													function(err, row) {
														if(err) {
														  console.log(err);
														}														
														forEachcallback();
													});
							} 
							else {
								db.query(`insert into cvg_risk_node_control (RISK_NODE_ID, CONTROL_ID, EFFECTIVENESS)
													values(?,?,?)`,
													[riskNode.RISK_NODE_ID, control.CONTROL_ID, control.EFFECTIVENESS],
													function(err, row) {
														if(err) {
														  console.log(err);
														}														
														forEachcallback();
													});
							}
						},
						function() {callback();}
					);

		  },
			// Insert or update control -> sub-risk links
		  function(callback){
		  	_und.each(riskNode.CTRL_SUB_RISKS, function(subRiskElements, rnControlId) {
						db.query(`delete from cvg_risk_node_control_sub_risk_link where RN_CONTROL_ID=?`,
											[rnControlId],
											function(err, row) {
												if(err) {
												  console.log(err);
												}

												async.forEach(subRiskElements, 
													function(subRiskElement, forEachcallback) {
														db.query(`replace into cvg_risk_node_control_sub_risk_link (RN_CONTROL_ID, RN_SUB_RISK_ID)
																			values(?,?)`,
																			[rnControlId, subRiskElement.RN_SUB_RISK_ID],
																			function(err, row) {
																				if(err) {
																				  console.log(err);
																				}														
																				forEachcallback();
																			});
												});
																	
						});
		  	});
		  	callback();
		  },
			// Insert or update control -> measure links
	  	function(callback){
		  	_und.each(riskNode.CTRL_MEASURES, function(measures, rnControlId) {
						db.query(`delete from cvg_risk_node_control_measure_link where RN_CONTROL_ID=?`,
											[rnControlId],
											function(err, row) {
												if(err) {
												  console.log(err);
												}

												async.forEach(measures, 
													function(measure, forEachcallback) {
														db.query(`replace into cvg_risk_node_control_measure_link (RN_CONTROL_ID, MEASURE_ID)
																			values(?,?)`,
																			[rnControlId, measure.MEASURE_ID],
																			function(err, row) {
																				if(err) {
																				  console.log(err);
																				}														
																				forEachcallback();
																			});
												});											
						});
		  	});
		  	callback();
		  },
		  // Done
		  function(){
	  		res.json({success: true, refreshPage: refreshPage, RISK_NODE: riskNode});
		  }
		]);

  }
	else if (req.params.apiEndpoint === "saveRiskNodeComment") {
    db.query(`update CVG_RISK_NODE set COMMENT = ? where RISK_NODE_ID = ?`, 
    	[req.body.COMMENT,req.body.RISK_NODE_ID],
    	function (err, row) {
	      if(err !== null) {
	      	console.log(err);
	        next(err);
	      }
	      else {
	  			res.json({success: true});
	      }
    });
  }    
  else if (req.params.apiEndpoint === "deleteRiskNodes") {
		async.forEach(req.body, 
			function(riskNode, callback) {
				db.query(`delete from cvg_risk_node 
									where RISK_NODE_ID = ?`,
									[riskNode.RISK_NODE_ID],
									function(err, row) {
										if(err) {
										  console.log(err);
										}
										callback();
									});
			},
			function(){
	  		res.json({success: true});
			});
  }    
  else if (req.params.apiEndpoint === "deleteProductSegments") {
		async.forEach(req.body, 
			function(riskNode, callback) {
				db.query(`delete from cvg_product_segment
									where PRODUCT_SEGMENT_ID = ?`,
									[riskNode.PRODUCT_SEGMENT_ID],
									function(err, row) {
										if(err) {
										  console.log(err);
										}
										callback();
									});
			},
			function(){
	  		res.json({success: true});
			});
  }
  else if (req.params.apiEndpoint === "postSubRiskMeasureLink") {
		async.forEach(req.body, 
			function(measure, callback) {
				db.query(`insert ignore into cvg_sub_risk_measure_link (SUB_RISK_ID, MEASURE_ID) values (?,?)`,
									[req.query.subRiskId, measure.MEASURE_ID],
									function(err, row) {
										if(err) {
										  console.log(err);
										}
										callback();
									});
			},
			function(){
	  		res.json({success: true});
			});
  }
  else if (req.params.apiEndpoint === "postRiskMeasureLink") {
		async.forEach(req.body, 
			function(measure, callback) {
				db.query(`insert ignore into cvg_risk_measure_link (RISK_ID, MEASURE_ID) values (?,?)`,
									[req.query.riskId, measure.MEASURE_ID],
									function(err, row) {
										if(err) {
										  console.log(err);
										}
										callback();
									});
			},
			function(){
	  		res.json({success: true});
			});
  }
  else if (req.params.apiEndpoint === "newProductSegment") {
		db.query(`insert into cvg_product_segment (PRODUCT_GROUP_ID, OPCO_ID, PRODUCT_SEGMENT, VALUE, VALUE_REFFERENCE) 
							values (?,?,?,?,?)`,
							[req.body.PRODUCT_GROUP_ID, req.body.OPCO_ID, req.body.PRODUCT_SEGMENT, req.body.VALUE, req.body.VALUE_REFFERENCE],
							function(err, row) {
								if(err) {
								  console.log(err);
								  next(err);
								}
								else {
									var productSegmentId = row.insertId;

									// Fill risks based on provided OPTIONS
	  							if (req.body.OPTIONS === 'Auto') {
										db.query(`
															select min(PRODUCT_SEGMENT_ID) PRODUCT_SEGMENT_ID from cvg_product_segment 
															where OPCO_ID = 36 
															and PRODUCT_GROUP_ID = ?
														`,
											[req.body.PRODUCT_GROUP_ID],
											function(err, row) {
													
													if(err) {
													  console.log(err);
													  next(err);
													}

													var copyProductSegmentId = row[0].PRODUCT_SEGMENT_ID;

													// Insert risk nodes
													db.query(`insert into cvg_risk_node (OPCO_ID, PRODUCT_SEGMENT_ID, RISK_ID) 
																		SELECT distinct
																			? OPCO_ID, 
																			? PRODUCT_SEGMENT_ID, 
																			RISK_ID 
																		FROM cvg_risk_node
																		where PRODUCT_SEGMENT_ID = ?
																	`,
														[req.body.OPCO_ID, productSegmentId, copyProductSegmentId],
														function(err, row) {
																if(err) {
																  console.log(err);
																  next(err);
																}

																// Insert sub-risks links 
																db.query(`insert into cvg_risk_node_sub_risk 
																						(RISK_NODE_ID, SUB_RISK_ID, LIKELIHOOD, IMPACT) 
																					SELECT 
																						c.RISK_NODE_ID, a.SUB_RISK_ID, b.BASE_LIKELIHOOD, b.BASE_IMPACT 
																					FROM cvg_risk_node_sub_risk a
																					join cvg_sub_risk b on b.sub_risk_id = a.sub_risk_id
																					join cvg_risk_node c on 1=1
																						and c.PRODUCT_SEGMENT_ID = ?
																					  and c.RISK_ID = b.RISK_ID
																					where a.RISK_NODE_ID in (SELECT min(RISK_NODE_ID) FROM cvg_risk_node where PRODUCT_SEGMENT_ID = ? group by RISK_ID);
																				`,
																	[productSegmentId, copyProductSegmentId],
																	function(err, row) {
																		if(err) {
																		  console.log(err);
																		  next(err);
																		} else {
																			res.json({success: true, productSegmentId: productSegmentId});
																		}																		
																	});
														});
	  								});
									}
									else if (req.body.OPTIONS === 'Full') {
													// Insert risk nodes
													db.query(`insert into cvg_risk_node (OPCO_ID, PRODUCT_SEGMENT_ID, RISK_ID) 
																		SELECT 
																			? OPCO_ID, 
																			? PRODUCT_SEGMENT_ID, 
																			RISK_ID 
																		FROM cvg_risk
																	`,
														[req.body.OPCO_ID, productSegmentId],
														function(err, row) {
																if(err) {
																  console.log(err);
																  next(err);
																}															
																// Insert sub-risks links 
																db.query(`insert into cvg_risk_node_sub_risk (RISK_NODE_ID, SUB_RISK_ID, LIKELIHOOD, IMPACT) 
																					SELECT c.RISK_NODE_ID, b.SUB_RISK_ID, b.BASE_LIKELIHOOD, b.BASE_IMPACT 
																					FROM cvg_sub_risk b
																					join cvg_risk_node c on 1=1
																						and c.PRODUCT_SEGMENT_ID = ?
																						and c.RISK_ID = b.RISK_ID
																					where b.RELEVANT = 'Y'
																				`,
																	[productSegmentId],
																	function(err, row) {
																		if(err) {
																		  console.log(err);
																		  next(err);
																		} 
																		else {
																			res.json({success: true, productSegmentId: productSegmentId});
																		}																		
																	});
														});

									}
									else {
										res.json({success: true, productSegmentId: productSegmentId});
									}
								}
							});
  }
  else if (req.params.apiEndpoint === "editProductSegment") {
		db.query(`update cvg_product_segment 
							set PRODUCT_GROUP_ID=?, PRODUCT_SEGMENT=?, VALUE=?, VALUE_REFFERENCE=? 
							where PRODUCT_SEGMENT_ID=?`,
							[req.body.PRODUCT_GROUP_ID, req.body.PRODUCT_SEGMENT, req.body.PS_VALUE, req.body.VALUE_REFFERENCE, req.body.PRODUCT_SEGMENT_ID],
							function(err, row) {
								if(err) {
								  console.log(err);
								  next(err);
								}
								else {
									res.json({success: true, productSegmentId: req.body.PRODUCT_SEGMENT_ID});
								}
							});
  }  
  else if (req.params.apiEndpoint === "postKeyRiskArea") {
  	//New Key Risk Area
  	if (typeof req.body.keyRiskArea.KEY_RISK_AREA_ID === 'undefined') {
  		// console.log('New');
  		// Insert
			db.query(`INSERT INTO cvg_key_risk_area 
								(KEY_RISK_AREA, KEY_RISK_AREA_DESCRIPTION)
								VALUES (?, ?)`,
				[req.body.keyRiskArea.KEY_RISK_AREA, req.body.keyRiskArea.KEY_RISK_AREA_DESCRIPTION],
				function(err, row) {
					if(err) {
					  console.log(err);
					  next(err);
					} 
					else {
						res.json({success: true, keyRiskAreaId: row.insertId});
					}																		
				});
  	}
  	else {
  		// console.log('Edit');
			db.query(`update cvg_key_risk_area 
								set KEY_RISK_AREA=?, KEY_RISK_AREA_DESCRIPTION=?
								where KEY_RISK_AREA_ID=?`,
								[req.body.keyRiskArea.KEY_RISK_AREA, req.body.keyRiskArea.KEY_RISK_AREA_DESCRIPTION, req.body.keyRiskArea.KEY_RISK_AREA_ID],
								function(err, row) {
									if(err) {
									  console.log(err);
									  next(err);
									}
									else {
										res.json({success: true});
									}
								});  		
  	}
  }
  else if (req.params.apiEndpoint === "linkKeyRiskAreaProductGroup") {
		async.forEach(req.body.keyRiskAreaProductGroups, 
			function(productGroup, callback) {
				db.query(`insert ignore into cvg_product_group_key_risk_area_link (PRODUCT_GROUP_ID, KEY_RISK_AREA_ID) values (?,?)`,
									[productGroup.PRODUCT_GROUP_ID, req.body.keyRiskAreaId],
									function(err, row) {
										if(err) {
										  console.log(err);
										}
										callback();
									});
			},
			function(){
	  		res.json({success: true});
			});
  } 
  else if (req.params.apiEndpoint === "unlinkKeyRiskAreaProductGroup") {
			db.query(`delete from cvg_product_group_key_risk_area_link 
								where KEY_RISK_AREA_ID=? and PRODUCT_GROUP_ID in (?)`,
								[req.body.keyRiskAreaId, req.body.keyRiskAreaProductGroups],
								function(err, row) {
									if(err) {
									  console.log(err);
									  next(err);
									}
									else {
									  console.log(row);
										res.json({success: true});
									}
								});  		
  }   
  else if (req.params.apiEndpoint === "linkKeyRiskAreaRisks") {
		async.forEach(req.body.keyRiskAreaRisks, 
			function(riskId, callback) {
				db.query(`insert ignore into cvg_risk_key_risk_area_link (RISK_ID, KEY_RISK_AREA_ID) values (?,?)`,
									[riskId, req.body.keyRiskAreaId],
									function(err, row) {
										if(err) {
										  console.log(err);
										}
										callback();
									});
			},
			function(){
	  		res.json({success: true});
			});
  } 
  else if (req.params.apiEndpoint === "unlinkKeyRiskAreaRisks") {
			db.query(`delete from cvg_risk_key_risk_area_link 
								where KEY_RISK_AREA_ID=? and RISK_ID in (?)`,
								[req.body.keyRiskAreaId, req.body.keyRiskAreaRisks],
								function(err, row) {
									if(err) {
									  console.log(err);
									  next(err);
									}
									else {
									  console.log(row);
										res.json({success: true});
									}
								});  		
  }  
  else {
  	  	res.json({success: false, error: 'Method not found: ' + req.params.apiEndpoint});
  }  

}

export function deleteApiEndpoint(req, res, next) {

  if (req.params.apiEndpoint === "deleteRisk") {
    db.query("delete from cvg_risk where RISK_ID=?", 
    	[req.query.riskId],
    	function (err, row) {
	      if(err !== null) {
	      	console.log(err);
	        next(err);
	      }
	      else {
					res.json({success: true});
	      }
    });
  }
  else if (req.params.apiEndpoint === "deleteSubRisk") {
    db.query("delete from cvg_sub_risk where SUB_RISK_ID=?", 
    	[req.query.subRiskId],
    	function (err, row) {
	      if(err !== null) {
	      	console.log(err);
	        next(err);
	      }
	      else {
					res.json({success: true});
	      }
    });
  }
  else if (req.params.apiEndpoint === "deleteSubRiskMeasureLink") {
    db.query("delete from cvg_sub_risk_measure_link where SUB_RISK_ID=? and MEASURE_ID=?", 
    	[req.query.subRiskId, req.query.measureId],
    	function (err, row) {
	      if(err !== null) {
	      	console.log(err);
	        next(err);
	      }
	      else {
					res.json({success: true});
	      }
    });
  }
  else if (req.params.apiEndpoint === "deleteRiskMeasureLink") {
    db.query("delete from cvg_risk_measure_link where RISK_ID=? and MEASURE_ID=?", 
    	[req.query.riskId, req.query.measureId],
    	function (err, row) {
	      if(err !== null) {
	      	console.log(err);
	        next(err);
	      }
	      else {
					res.json({success: true});
	      }
    });
  }
  else if (req.params.apiEndpoint === "unlinkSubRisk") {
    db.query("delete from cvg_risk_node_sub_risk where RN_SUB_RISK_ID=?", 
    	[req.query.rnSubRiskId],
    	function (err, row) {
	      if(err !== null) {
	      	console.log(err);
	        next(err);
	      }
	      else {
					res.json({success: true});
	      }
    });
  }
  else if (req.params.apiEndpoint === "unlinkControl") {
    db.query("delete from cvg_risk_node_control where RN_CONTROL_ID=?", 
    	[req.query.rnControlId],
    	function (err, row) {
	      if(err !== null) {
	      	console.log(err);
	        next(err);
	      }
	      else {
					res.json({success: true});
	      }
    });
  }
  else if (req.params.apiEndpoint === "deleteKeyRiskArea") {
    db.query("delete from cvg_key_risk_area where KEY_RISK_AREA_ID=?", 
    	[req.query.keyRiskAreaId],
    	function (err, row) {
	      if(err !== null) {
	      	console.log(err);
	        next(err);
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