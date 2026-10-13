/*						
================================================================================						
档案代号:hrca_file						
档案名称:人员排班						
档案目的:						
上游档案:						
下游档案:						
档案类型:B						
多语系档案:N						
============.========================.==========================================						
*/						
create table hrca_file(				
	hrca01	number(10) NOT NULL,		/* 排班序号                                    */
	hrca02	varchar2(1),		        /* 排班人群类型                                  */
	hrca03	varchar2(1),	         	/*  排班类型                                 */
	hrca04	varchar2(20),	        	/*  固定班次                               */
	hrca05	varchar2(20),	         	/* 轮班                                  */
	hrca06	varchar2(20),		        /* 轮班开始班次                                         */
	hrca07	varchar2(1),		        /* 跳过方式                                      */
	hrca08	varchar2(1),	        	/* 假日跳过                                      */
	hrca09	varchar2(1),	        	/* 节日跳过                                      */
	hrca10	varchar2(20),	        	/* 休息班次                                    */
	hrca11	date,		                /* 开始日期                                      */
	hrca12	date,		                /* 结束日期                                    */
	hrca13	number(5) ,		          /* 项次                                      */
	hrca14	varchar2(50),		        /* 排班人群编号                                  */
	hrca15	varchar2(50),		        /* 排班人群名称                                  */
	hrca16	varchar2(255),		  /* 备注                                      */
	hrcaud01	varchar2(255),		/*自订栏位-Textedit                      */
	hrcaud02	varchar2(40),		/*自订栏位-文字                          */
	hrcaud03	varchar2(40),		/*自订栏位-文字                          */
	hrcaud04	varchar2(40),		/*自订栏位-文字                          */
	hrcaud05	varchar2(40),		/*自订栏位-文字                          */
	hrcaud06	varchar2(40),		/*自订栏位-文字                          */
	hrcaud07	number(15,3),		/*自订栏位-数值                          */
	hrcaud08	number(15,3),		/*自订栏位-数值                          */
	hrcaud09	number(15,3),		/*自订栏位-数值                          */
	hrcaud10	number(10),  		/*自订栏位-整数                          */
	hrcaud11	number(10),  		/*自订栏位-整数                          */
	hrcaud12	number(10),  		/*自订栏位-整数                          */
	hrcaud13	date,        		/*自订栏位-日期                          */
	hrcaud14	date,        		/*自订栏位-日期                          */
	hrcaud15	date,        		/*自订栏位-日期                          */
	hrcauser 	varchar2(10),		/*  资料所有者                             */ 
	hrcagrup 	varchar2(10),		/*  资料所有群                             */ 
	hrcamodu 	varchar2(10),		/*  资料更改者                             */ 
	hrcadate 	date,        		/*  最近修改日                             */ 
	hrcaorig 	varchar2(10),		/*  资料建立部门                           */ 
	hrcaoriu 	varchar2(10) 		/*  资料建立者                             */ 
);				
alter table hrca_file add  constraint tpc_hrca_pk primary key  (hrca01,hrca13) enable validate;				
grant select on hrca_file to tiptopgp;				
grant update on hrca_file to tiptopgp;				
grant delete on hrca_file to tiptopgp;				
grant insert on hrca_file to tiptopgp;				
grant index on hrca_file to public;				
grant select on hrca_file to ods;				
