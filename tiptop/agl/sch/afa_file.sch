/*
================================================================================
檔案代號:afa_file
檔案名稱:预算名称档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table afa_file
(
afa00       varchar2(5) NOT NULL,    /*帐套编号                               */
afa01       varchar2(10) NOT NULL,   /*预算编号                               */
afa02       varchar2(80),            /*预算名称                               */
afaacti     varchar2(1),             /*资料有效码                             */
afauser     varchar2(10),            /*资料所有者                             */
afagrup     varchar2(10),            /*资料所有群                             */
afamodu     varchar2(10),            /*资料更改者                             */
afadate     date,                    /*最近更改日                             */
afaorig     varchar2(10),            /*资料建立部门                           */
afaoriu     varchar2(10)             /*资料建立者                             */
);

alter table afa_file add  constraint afa_pk primary key  (afa00,afa01) enable validate;
grant select on afa_file to tiptopgp;
grant update on afa_file to tiptopgp;
grant delete on afa_file to tiptopgp;
grant insert on afa_file to tiptopgp;
grant index on afa_file to public;
grant select on afa_file to ods;
