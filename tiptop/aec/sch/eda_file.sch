/*
================================================================================
檔案代號:eda_file
檔案名稱:合拼版资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table eda_file
(
eda01       varchar2(20) DEFAULT ' ' NOT NULL, /*合拼版号*/
eda02       varchar2(80),            /*合拼说明                               */
eda03       varchar2(1),             /*永久合拼否                             */
edaacti     varchar2(1),             /*资料有效码                             */
edaconf     varchar2(1),             /*确认码                                 */
edadate     date,                    /*最近更改日                             */
edagrup     varchar2(10),            /*资料所有群                             */
edamodu     varchar2(10),            /*资料更改者                             */
edaorig     varchar2(10),            /*资料建立部门                           */
edaoriu     varchar2(10),            /*资料建立者                             */
edauser     varchar2(10)             /*资料所有者                             */
);

alter table eda_file add  constraint eda_pk primary key  (eda01) enable validate;
grant select on eda_file to tiptopgp;
grant update on eda_file to tiptopgp;
grant delete on eda_file to tiptopgp;
grant insert on eda_file to tiptopgp;
grant index on eda_file to public;
grant select on eda_file to ods;
