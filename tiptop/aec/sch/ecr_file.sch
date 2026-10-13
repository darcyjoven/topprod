/*
================================================================================
檔案代號:ecr_file
檔案名稱:制程段号资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ecr_file
(
ecr01       varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
ecr02       varchar2(80),            /*工艺段号说明                           */
ecracti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
ecrdate     date,                    /*最近更改日                             */
ecrgrup     varchar2(10),            /*资料所有群                             */
ecrmodu     varchar2(10),            /*资料更改者                             */
ecrorig     varchar2(10),            /*资料建立部门                           */
ecroriu     varchar2(10),            /*资料建立者                             */
ecruser     varchar2(10)             /*资料所有者                             */
);

alter table ecr_file add  constraint ecr_pk primary key  (ecr01) enable validate;
grant select on ecr_file to tiptopgp;
grant update on ecr_file to tiptopgp;
grant delete on ecr_file to tiptopgp;
grant insert on ecr_file to tiptopgp;
grant index on ecr_file to public;
grant select on ecr_file to ods;
