/*
================================================================================
檔案代號:azx_file
檔案名稱:利率档资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table azx_file
(
azx01       varchar2(4) NOT NULL,    /*币种                                   */
                                     /*幣別                                   */
azx02       number(5) NOT NULL,      /*年度                                   */
azx03       number(5) NOT NULL,      /*月份                                   */
azx04       number(9,4),             /*利率                                   */
                                     /*利率            #No:7354               */
azxacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
azxuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
azxgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
azxmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
azxdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
azxorig     varchar2(10),            /*资料建立部门                           */
azxoriu     varchar2(10)             /*资料建立者                             */
);

alter table azx_file add  constraint azx_pk primary key  (azx01,azx02,azx03) enable validate;
grant select on azx_file to tiptopgp;
grant update on azx_file to tiptopgp;
grant delete on azx_file to tiptopgp;
grant insert on azx_file to tiptopgp;
grant index on azx_file to public;
grant select on azx_file to ods;
