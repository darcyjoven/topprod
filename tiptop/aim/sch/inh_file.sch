/*
================================================================================
檔案代號:inh_file
檔案名稱:料件批序号开账单身
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table inh_file
(
inh01       varchar2(20) DEFAULT ' ' NOT NULL, /*开账单号*/
inh02       number(5) DEFAULT '0' NOT NULL, /*项次*/
inh03       varchar2(30),            /*序号                                   */
inh04       varchar2(30),            /*制造批号                               */
inh05       date,                    /*制造日期                               */
inh06       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
inh07       varchar2(1) DEFAULT ' ', /*归属类型                               */
inh08       varchar2(20),            /*归属单号                               */
inhlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
inhplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table inh_file add  constraint inh_pk primary key  (inh01,inh02) enable validate;
grant select on inh_file to tiptopgp;
grant update on inh_file to tiptopgp;
grant delete on inh_file to tiptopgp;
grant insert on inh_file to tiptopgp;
grant index on inh_file to public;
grant select on inh_file to ods;
