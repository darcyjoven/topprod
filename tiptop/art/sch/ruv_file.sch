/*
================================================================================
檔案代號:ruv_file
檔案名稱:盘点清单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ruv_file
(
ruv01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
ruv02       number(5) DEFAULT '0' NOT NULL, /*项次*/
ruv03       varchar2(40),            /*货架编号                               */
ruv04       varchar2(40),            /*产品编号                               */
ruv05       varchar2(4),             /*库存单位                               */
ruv06       number(15,3),            /*实盘数量                               */
ruv07       number(15,3),            /*初盘数量                               */
ruv08       number(15,3),            /*复盘数量                               */
ruv09       number(15,3),            /*抽盘数量                               */
ruv10       varchar2(255),           /*備注                                   */
ruvlegal    varchar2(10) NOT NULL,   /*所属法人                               */
ruvplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

create        index ruv_02 on ruv_file (ruv01,ruv03,ruv04);
alter table ruv_file add  constraint ruv_pk primary key  (ruv01,ruv02) enable validate;
grant select on ruv_file to tiptopgp;
grant update on ruv_file to tiptopgp;
grant delete on ruv_file to tiptopgp;
grant insert on ruv_file to tiptopgp;
grant index on ruv_file to public;
grant select on ruv_file to ods;
