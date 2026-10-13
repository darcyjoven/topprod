/*
================================================================================
檔案代號:rxb_file
檔案名稱:预收款退回已冲单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rxb_file
(
rxb01       varchar2(20) DEFAULT ' ' NOT NULL, /*退回单号*/
rxb02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rxb03       varchar2(20),            /*销售单号                               */
rxb04       date,                    /*冲账日期                               */
rxb05       varchar2(10),            /*冲账人员                               */
rxb06       number(20,6),            /*冲账金额                               */
rxblegal    varchar2(10) NOT NULL,   /*所属法人                               */
rxbplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table rxb_file add  constraint rxb_pk primary key  (rxb01,rxb02) enable validate;
grant select on rxb_file to tiptopgp;
grant update on rxb_file to tiptopgp;
grant delete on rxb_file to tiptopgp;
grant insert on rxb_file to tiptopgp;
grant index on rxb_file to public;
grant select on rxb_file to ods;
