/*
================================================================================
檔案代號:rvt_file
檔案名稱:退厂申请单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:Y
============.========================.==========================================
*/
create table rvt_file
(
rvt01       varchar2(20) DEFAULT ' ' NOT NULL, /*申请单号*/
rvt02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rvt03       varchar2(20),            /*收货单号                               */
rvt04       number(5),               /*收货单项次                             */
rvt05       varchar2(40) DEFAULT ' ' NOT NULL, /*产品编号*/
rvt06       varchar2(4),             /*单位                                   */
rvt07       varchar2(10),            /*仓库                                   */
rvt08       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
rvt09       number(20,6) DEFAULT '0' NOT NULL, /*税前单价*/
rvt10       number(20,6) DEFAULT '0' NOT NULL, /*含税单价*/
rvt11       number(20,6) DEFAULT '0' NOT NULL, /*税前金额*/
rvt12       number(20,6) DEFAULT '0' NOT NULL, /*含税金额*/
rvt13       varchar2(10),            /*理由码                                 */
rvtlegal    varchar2(10),            /*所属法人                               */
rvtplant    varchar2(10)             /*所属工厂                               */
);

alter table rvt_file add  constraint rvt_pk primary key  (rvt01,rvt02) enable validate;
grant select on rvt_file to tiptopgp;
grant update on rvt_file to tiptopgp;
grant delete on rvt_file to tiptopgp;
grant insert on rvt_file to tiptopgp;
grant index on rvt_file to public;
grant select on rvt_file to ods;
