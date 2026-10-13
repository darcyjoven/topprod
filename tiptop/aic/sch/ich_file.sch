/*
================================================================================
檔案代號:ich_file
檔案名稱:ICD单价公式计算资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ich_file
(
ich01       varchar2(10) NOT NULL,   /*公式代码                               */
ich02       varchar2(80),            /*公式                                   */
ichacti     varchar2(1),             /*资料有效码                             */
ichdate     date,                    /*资料更改日                             */
ichgrup     varchar2(10),            /*资料所有群                             */
ichmodu     varchar2(10),            /*资料更改者                             */
ichuser     varchar2(10),            /*资料所有者                             */
ichorig     varchar2(10),            /*资料建立部门                           */
ichoriu     varchar2(10)             /*资料建立者                             */
);

alter table ich_file add  constraint ich_pk primary key  (ich01) enable validate;
grant select on ich_file to tiptopgp;
grant update on ich_file to tiptopgp;
grant delete on ich_file to tiptopgp;
grant insert on ich_file to tiptopgp;
grant index on ich_file to public;
grant select on ich_file to ods;
