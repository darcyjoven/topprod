/*
================================================================================
檔案代號:bgc_file
檔案名稱:材料单价档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bgc_file
(
bgc01       varchar2(10) NOT NULL,   /*版本                                   */
bgc02       number(5) NOT NULL,      /*年度                                   */
bgc03       number(5) NOT NULL,      /*月份                                   */
bgc04       varchar2(4) NOT NULL,    /*币种                                   */
                                     /*幣別                                   */
bgc05       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
bgc06       number(20,6),            /*采购单价                               */
                                     /*採購單價(原幣)                         */
bgc07       number(20,6),            /*采购单价                               */
                                     /*採購單價(本幣)                         */
bgc08       varchar2(4) NOT NULL,    /*采购单位                               */
                                     /*採購單位          No.8563 031031       */
bgcacti     varchar2(1),             /*资料有效码                             */
bgcuser     varchar2(10),            /*资料所有者                             */
bgcgrup     varchar2(10),            /*资料所有部门                           */
bgcmodu     varchar2(10),            /*资料更改者                             */
bgcdate     date,                    /*最近更改日                             */
bgcoriu     varchar2(10),            /*资料建立者                             */
bgcorig     varchar2(10)             /*资料建立部门                           */
);

alter table bgc_file add  constraint bgc_pk primary key  (bgc01,bgc02,bgc03,bgc04,bgc05,bgc08) enable validate;
grant select on bgc_file to tiptopgp;
grant update on bgc_file to tiptopgp;
grant delete on bgc_file to tiptopgp;
grant insert on bgc_file to tiptopgp;
grant index on bgc_file to public;
grant select on bgc_file to ods;
