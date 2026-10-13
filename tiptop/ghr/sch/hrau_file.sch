create table hrau_file(   
hrau01 varchar2(15) NOT NULL,/*表名*/ 
hrau02 varchar2(30) NOT NULL,/*字段代码*/ 
hrau03 varchar2(255),/*字段说明*/ 
hrau04 varchar2(1),/*类型*/ 
hrau05 varchar2(20),/*开窗代码 */ 
hrau06 varchar2(1),/*传参否*/ 
hrau07 varchar2(255),/*参数*/ 
hrau08 varchar2(255),/*备注*/ 
hrauuser varchar2(10),/*资料所有者*/ 
hraugrup varchar2(10),/*资料所有群*/ 
hraumodu varchar2(10),/*资料更改者*/ 
hraudate date,/*最近修改日*/ 
hrauorig varchar2(10),/*资料建立部门*/ 
hrauoriu varchar2(10)/*资料建立者*/
);
alter table hrau_file add constraint tpc_hrau_pk primary key (hrau01,hrau02) enable validate;   
grant select on hrau_file to tiptopgp;   
grant update on hrau_file to tiptopgp;   
grant delete on hrau_file to tiptopgp;   
grant insert on hrau_file to tiptopgp;   
grant index on hrau_file to public;   
grant select on hrau_file to ods;   
