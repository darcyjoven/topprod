/*
================================================================================
檔案代號:rmj_file
檔案名稱:RMA 报废单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rmj_file
(
rmj01       varchar2(20) NOT NULL,   /*RMA 报废单号                           */
                                     /*RMA 報廢單號                           */
rmj02       date,                    /*单据日期                               */
                                     /*單據日期                               */
rmj03       varchar2(20),            /*RMA单号                                */
                                     /*RMA單號                                */
rmjpost     varchar2(1),             /*扣帐码                                 */
                                     /*扣帳碼 (Y/N)                           */
rmjconf     varchar2(1),             /*审核否                                 */
                                     /*確認否 (Y/N)                           */
rmjvoid     varchar2(1),             /*有效否                                 */
                                     /*有效否 (Y/N) Y:有效 N:作廢             */
rmjuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
rmjgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
rmjmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
rmjdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
rmjud01     varchar2(255),           /*自订字段-Textedit                      */
rmjud02     varchar2(40),            /*自订字段-文字                          */
rmjud03     varchar2(40),            /*自订字段-文字                          */
rmjud04     varchar2(40),            /*自订字段-文字                          */
rmjud05     varchar2(40),            /*自订字段-文字                          */
rmjud06     varchar2(40),            /*自订字段-文字                          */
rmjud07     number(15,3),            /*自订字段-数值                          */
rmjud08     number(15,3),            /*自订字段-数值                          */
rmjud09     number(15,3),            /*自订字段-数值                          */
rmjud10     number(10),              /*自订字段-整数                          */
rmjud11     number(10),              /*自订字段-整数                          */
rmjud12     number(10),              /*自订字段-整数                          */
rmjud13     date,                    /*自订字段-日期                          */
rmjud14     date,                    /*自订字段-日期                          */
rmjud15     date,                    /*自订字段-日期                          */
rmjplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rmjlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rmjoriu     varchar2(10),            /*资料建立者                             */
rmjorig     varchar2(10)             /*资料建立部门                           */
);

alter table rmj_file add  constraint rmj_pk primary key  (rmj01) enable validate;
grant select on rmj_file to tiptopgp;
grant update on rmj_file to tiptopgp;
grant delete on rmj_file to tiptopgp;
grant insert on rmj_file to tiptopgp;
grant index on rmj_file to public;
grant select on rmj_file to ods;
