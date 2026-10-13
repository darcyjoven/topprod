/*
================================================================================
檔案代號:lus_file
檔案名稱:终止结算退款明细单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lus_file
(
lus01       varchar2(20) DEFAULT ' ' NOT NULL, /*结算单号*/
lus02       number(5) DEFAULT '0' NOT NULL, /*项次*/
lus03       varchar2(10),            /*费用编号                               */
lus04       varchar2(2),             /*费用类型                               */
lus05       number(20,6),            /*应退金额                               */
lus06       number(20,6),            /*已退金额                               */
luslegal    varchar2(10) NOT NULL,   /*所属法人                               */
lusplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table lus_file add  constraint lus_pk primary key  (lus01,lus02) enable validate;
grant select on lus_file to tiptopgp;
grant update on lus_file to tiptopgp;
grant delete on lus_file to tiptopgp;
grant insert on lus_file to tiptopgp;
grant index on lus_file to public;
grant select on lus_file to ods;
