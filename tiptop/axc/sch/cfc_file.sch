/*
================================================================================
檔案代號:cfc_file
檔案名稱:发出商品月统计档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cfc_file
(
cfc00       varchar2(1) DEFAULT ' ' NOT NULL, /*来源*/
cfc01       number(5) DEFAULT '0' NOT NULL, /*方向*/
cfc02       varchar2(10) DEFAULT ' ' NOT NULL, /*来源营运中心*/
cfc03       varchar2(20) DEFAULT ' ' NOT NULL, /*出货单号*/
cfc04       number(5) DEFAULT '0' NOT NULL, /*项次*/
cfc05       number(5) DEFAULT '0' NOT NULL, /*年度*/
cfc06       varchar2(2) DEFAULT ' ' NOT NULL, /*月份*/
cfc07       varchar2(10) NOT NULL,   /*客户编号                               */
cfc08       varchar2(40),            /*客户简称                               */
cfc09       varchar2(10),            /*人员编号                               */
cfc10       varchar2(10),            /*部门编号                               */
cfc11       varchar2(40) NOT NULL,   /*料号                                   */
cfc12       varchar2(4) NOT NULL,    /*单位                                   */
cfc13       varchar2(120),           /*品名                                   */
cfc14       varchar2(10),            /*仓库                                   */
cfc141      varchar2(10),            /*库位                                   */
cfc142      varchar2(24),            /*批号                                   */
cfc15       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
cfc19       varchar2(24) NOT NULL,   /*科目编号                               */
cfc21       number(5) NOT NULL,      /*开票年度                               */
cfc22       number(5) NOT NULL,      /*开票月份                               */
cfc17       varchar2(4) NOT NULL,    /*库存单位                               */
cfc18       number(20,8),            /*转换率                                 */
cfc20       varchar2(1) NOT NULL     /*多角贸易否                             */
);

alter table cfc_file add  constraint cfc_pk primary key  (cfc00,cfc01,cfc02,cfc05,cfc06,cfc07,cfc11,cfc12,cfc17,cfc19,cfc21,cfc22) enable validate;
grant select on cfc_file to tiptopgp;
grant update on cfc_file to tiptopgp;
grant delete on cfc_file to tiptopgp;
grant insert on cfc_file to tiptopgp;
grant index on cfc_file to public;
grant select on cfc_file to ods;
