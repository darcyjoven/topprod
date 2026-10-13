/*
================================================================================
檔案代號:loc_file
檔案名稱:合同变更项目信息档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table loc_file
(
loc01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同编号*/
loc02       varchar2(16) DEFAULT ' ' NOT NULL, /*合同版本号*/
loc03       number(5) DEFAULT '0' NOT NULL, /*项次*/
loc04       varchar2(10),            /*费用明细编号                           */
loc05       varchar2(4),             /*年份                                   */
loc06       varchar2(2),             /*月份                                   */
loc07       number(20,2),            /*费用标准                               */
loc08       number(10),              /*人数                                   */
loc09       number(20,2),            /*费用合计                               */
loc10       number(20,2),            /*原调整金额                             */
loc11       number(20,2),            /*调整后金额                             */
loc12       number(20,2),            /*保底金额                               */
loc13       varchar2(1),             /*收取方式                               */
loc14       varchar2(50),            /*备注                                   */
loc15       varchar2(1),             /*费用归属                               */
loc16       date,                    /*生效日期                               */
loc17       date,                    /*失效日期                               */
loclegal    varchar2(10) NOT NULL,   /*所属法人                               */
locplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table loc_file add  constraint loc_pk primary key  (loc01,loc02,loc03) enable validate;
grant select on loc_file to tiptopgp;
grant update on loc_file to tiptopgp;
grant delete on loc_file to tiptopgp;
grant insert on loc_file to tiptopgp;
grant index on loc_file to public;
grant select on loc_file to ods;
