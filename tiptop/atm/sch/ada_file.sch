/*
================================================================================
檔案代號:ada_file
檔案名稱:集团组织单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ada_file
(
ada01       varchar2(10) NOT NULL,   /*上层公司编号                           */
ada02       varchar2(10),            /*在途仓                                 */
adaacti     varchar2(1),             /*资料有效码                             */
adauser     varchar2(10),            /*资料所有者                             */
adagrup     varchar2(10),            /*资料所有部门                           */
adamodu     varchar2(10),            /*资料更改者                             */
adadate     date,                    /*最近更改日                             */
adaorig     varchar2(10),            /*资料建立部门                           */
adaoriu     varchar2(10)             /*资料建立者                             */
);

alter table ada_file add  constraint ada_pk primary key  (ada01) enable validate;
grant select on ada_file to tiptopgp;
grant update on ada_file to tiptopgp;
grant delete on ada_file to tiptopgp;
grant insert on ada_file to tiptopgp;
grant index on ada_file to public;
grant select on ada_file to ods;
