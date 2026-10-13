/*
================================================================================
檔案代號:vih_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vih_file
(
vih01       varchar2(10) NOT NULL,   /*积分规则编码                           */
vih02       varchar2(80),            /*积分规则名称                           */
vih03       date,                    /*生效日期                               */
vih04       date,                    /*失效日期                               */
vih05       number(10),              /*积分数                                 */
vih06       number(20,6),            /*消费金额                               */
vih07       varchar2(4),             /*币种                                   */
vihacti     varchar2(1),             /*资料有效码                             */
vihdate     date,                    /*最近更改日                             */
vihgrup     varchar2(10),            /*资料所有部门                           */
vihmodu     varchar2(10),            /*资料更改者                             */
vihuser     varchar2(10),            /*资料所有者                             */
vihorig     varchar2(10),            /*资料建立部门                           */
vihoriu     varchar2(10)             /*资料建立者                             */
);

alter table vih_file add  constraint vih_pk primary key  (vih01) enable validate;
grant select on vih_file to tiptopgp;
grant update on vih_file to tiptopgp;
grant delete on vih_file to tiptopgp;
grant insert on vih_file to tiptopgp;
grant index on vih_file to public;
grant select on vih_file to ods;
