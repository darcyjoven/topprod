/*
================================================================================
檔案代號:vlp_file
檔案名稱:　
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vlp_file
(
vlp01       varchar2(1) DEFAULT '1' NOT NULL, /*资料类型*/
vlp02       number(10) DEFAULT '0' NOT NULL, /*优先顺序*/
vlp03       varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
vlpacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
vlpdate     date,                    /*最近更改日                             */
vlpgrup     varchar2(10),            /*资料所有群                             */
vlpmodu     varchar2(10),            /*资料更改者                             */
vlpuser     varchar2(10)             /*资料所有者                             */
);

alter table vlp_file add  constraint vlp_pk primary key  (vlp01,vlp03) enable validate;
grant select on vlp_file to tiptopgp;
grant update on vlp_file to tiptopgp;
grant delete on vlp_file to tiptopgp;
grant insert on vlp_file to tiptopgp;
grant index on vlp_file to public;
grant select on vlp_file to ods;
