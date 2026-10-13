/*
================================================================================
檔案代號:ede_file
檔案名稱:报工时单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ede_file
(
ede01       varchar2(20) DEFAULT ' ' NOT NULL, /*报工时单号*/
ede02       date,                    /*单据日期                               */
edeacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
edeconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
ededate     date,                    /*最近更改日                             */
edegrup     varchar2(10),            /*资料所有群                             */
edelegal    varchar2(10),            /*所属法人                               */
edemodu     varchar2(10),            /*资料更改者                             */
edeorig     varchar2(10),            /*资料建立部门                           */
edeoriu     varchar2(10),            /*资料建立者                             */
edeplant    varchar2(10),            /*所属工厂                               */
edeuser     varchar2(10)             /*资料所有者                             */
);

alter table ede_file add  constraint ede_pk primary key  (ede01) enable validate;
grant select on ede_file to tiptopgp;
grant update on ede_file to tiptopgp;
grant delete on ede_file to tiptopgp;
grant insert on ede_file to tiptopgp;
grant index on ede_file to public;
grant select on ede_file to ods;
