/*
================================================================================
檔案代號:aca_file
檔案名稱:常用及分摊凭证类型单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aca_file
(
aca01       varchar2(6) NOT NULL,    /*类型编号                               */
aca02       varchar2(80),            /*类型名称                               */
aca03       number(5),               /*生成顺序                               */
acaacti     varchar2(1),             /*资料有效码                             */
acauser     varchar2(10),            /*资料所有者                             */
acagrup     varchar2(10),            /*资料所有群                             */
acamodu     varchar2(10),            /*资料更改者                             */
acadate     date,                    /*最近更改日                             */
acaoriu     varchar2(10),            /*资料建立者                             */
acaorig     varchar2(10)             /*资料建立部门                           */
);

alter table aca_file add  constraint aca_pk primary key  (aca01) enable validate;
grant select on aca_file to tiptopgp;
grant update on aca_file to tiptopgp;
grant delete on aca_file to tiptopgp;
grant insert on aca_file to tiptopgp;
grant index on aca_file to public;
grant select on aca_file to ods;
