/*
================================================================================
檔案代號:rvvi_file
檔案名稱:入库/退扣单异动档(行业别档)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvvi_file
(
rvvi01      varchar2(20) DEFAULT ' ' NOT NULL, /*入库单号/退货单号*/
rvvi02      number(5) DEFAULT '0' NOT NULL, /*项次*/
rvviicd01   varchar2(10),            /*ICD作业编号                            */
rvviicd02   varchar2(80),            /*Datecode                               */
rvviicd03   varchar2(40),            /*内编母体料号                           */
rvviicd04   varchar2(40),            /*产品型号                               */
rvviicd05   varchar2(24),            /*母批                                   */
rvviicd06   varchar2(20),            /*Tape Reel                              */
rvviicd07   varchar2(1),             /*委外TKY非最终站否(Y:委外TKY非          */
rvviplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
rvvilegal   varchar2(10) NOT NULL,   /*所属法人                               */
rvvislk01   varchar2(40),            /*款号编号                               */
rvvislk02   number(5)                /*款號項次                               */
);

alter table rvvi_file add  constraint rvvi_pk primary key  (rvvi01,rvvi02) enable validate;
grant select on rvvi_file to tiptopgp;
grant update on rvvi_file to tiptopgp;
grant delete on rvvi_file to tiptopgp;
grant insert on rvvi_file to tiptopgp;
grant index on rvvi_file to public;
grant select on rvvi_file to ods;
