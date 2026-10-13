/*
================================================================================
檔案代號:rtr_file
檔案名稱:合同費用單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rtr_file
(
rtr01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同编号*/
rtr02       number(5) DEFAULT '0' NOT NULL, /*版本号*/
rtr03       varchar2(10) DEFAULT ' ' NOT NULL, /*签订机构*/
rtr04       varchar2(1) DEFAULT ' ' NOT NULL, /*费用类型*/
                                     /*Expense Type                           */
rtr05       number(5) DEFAULT '0' NOT NULL, /*项次*/
rtr06       varchar2(10),            /*费用代码                               */
rtr07       date,                    /*生成日期                               */
rtr08       varchar2(1),             /*费用周期                               */
                                     /*Expense Cycle 1:Year 2:Semi-Year 3:Quarter 4:Month*/
rtr09       varchar2(1),             /*周期方式                               */
                                     /*Cycle Type 1:Early Period 2:End Period */
rtr10       number(20,6),            /*费用金额                               */
rtr11       varchar2(1),             /*费用基准                               */
                                     /*Expense Base 1-Cost Amount 2-Sales Amount 3-Purchase Amount*/
rtr12       number(5,2),             /*费用比率？                             */
rtr13       number(20,6),            /*返利基准条件                           */
rtr14       number(20,6),            /*费用下限                               */
rtr15       number(20,6),            /*费用上限                               */
rtr16       number(5,2),             /*保底扣率%                              */
rtr17       varchar2(1),             /*按机构保底否                           */
rtr18       varchar2(20),            /*保底期别                               */
rtr19       varchar2(10),            /*保底机构                               */
rtrlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rtrplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table rtr_file add  constraint rtr_pk primary key  (rtr01,rtr02,rtr03,rtr04,rtr05,rtrplant) enable validate;
grant select on rtr_file to tiptopgp;
grant update on rtr_file to tiptopgp;
grant delete on rtr_file to tiptopgp;
grant insert on rtr_file to tiptopgp;
grant index on rtr_file to public;
grant select on rtr_file to ods;
