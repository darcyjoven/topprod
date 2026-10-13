/*
================================================================================
檔案代號:bgb_file
檔案名稱:材料预计涨幅档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bgb_file
(
bgb01       varchar2(10) NOT NULL,   /*版本                                   */
bgb02       number(5) NOT NULL,      /*年度                                   */
bgb03       number(5) NOT NULL,      /*月份                                   */
bgb04       varchar2(10) NOT NULL,   /*材料类型                               */
                                     /*材料類別                               */
bgb05       number(9,4),             /*涨幅                                   */
                                     /*漲幅                                   */
bgbacti     varchar2(1),             /*资料有效码                             */
bgbuser     varchar2(10),            /*资料所有者                             */
bgbgrup     varchar2(10),            /*资料所有部门                           */
bgbmodu     varchar2(10),            /*资料更改者                             */
bgbdate     date,                    /*最近更改日                             */
bgboriu     varchar2(10),            /*资料建立者                             */
bgborig     varchar2(10)             /*资料建立部门                           */
);

alter table bgb_file add  constraint bgb_pk primary key  (bgb01,bgb02,bgb03,bgb04) enable validate;
grant select on bgb_file to tiptopgp;
grant update on bgb_file to tiptopgp;
grant delete on bgb_file to tiptopgp;
grant insert on bgb_file to tiptopgp;
grant index on bgb_file to public;
grant select on bgb_file to ods;
