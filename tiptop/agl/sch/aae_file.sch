/*
================================================================================
檔案代號:aae_file
檔案名稱:科目分类名称档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aae_file
(
aae01       varchar2(10) NOT NULL,   /*科目分类编号                           */
aae02       varchar2(255),           /*科目分类名称                           */
aae03       varchar2(255),           /*备注                                   */
aaeacti     varchar2(1),             /*资料有效码                             */
aaeuser     varchar2(10),            /*资料所有者                             */
aaegrup     varchar2(10),            /*资料所有群                             */
aaemodu     varchar2(10),            /*资料更改者                             */
aaedate     date,                    /*最近更改日                             */
aaeorig     varchar2(10),            /*资料建立部门                           */
aaeoriu     varchar2(10)             /*资料建立者                             */
);

alter table aae_file add  constraint aae_pk primary key  (aae01) enable validate;
grant select on aae_file to tiptopgp;
grant update on aae_file to tiptopgp;
grant delete on aae_file to tiptopgp;
grant insert on aae_file to tiptopgp;
grant index on aae_file to public;
grant select on aae_file to ods;
