/*
================================================================================
檔案代號:aga_file
檔案名稱:属性群组资料主档
檔案目的:记录多属性料件机制中定义的属性群组资料
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aga_file
(
aga01       varchar2(10) NOT NULL,   /*属性群组代码                           */
aga02       varchar2(80) NOT NULL,   /*描述说明                               */
agaacti     varchar2(1),             /*资料有效码                             */
agauser     varchar2(10),            /*资料所有者                             */
agagrup     varchar2(10),            /*资料所有群                             */
agamodu     varchar2(10),            /*资料更改者                             */
agadate     date,                    /*最近更改日                             */
agaorig     varchar2(10),            /*资料建立部门                           */
agaoriu     varchar2(10)             /*资料建立者                             */
);

alter table aga_file add  constraint aga_pk primary key  (aga01) enable validate;
grant select on aga_file to tiptopgp;
grant update on aga_file to tiptopgp;
grant delete on aga_file to tiptopgp;
grant insert on aga_file to tiptopgp;
grant index on aga_file to public;
grant select on aga_file to ods;
