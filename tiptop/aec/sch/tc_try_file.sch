/*
================================================================================
檔案代號:ecu_file
檔案名稱:製程資料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ecu_file
(
ecu01       varchar2(40) NOT NULL,   /*料件編號                               */
ecu02       varchar2(10) NOT NULL,   /*製程編號                               */
ecu03       varchar2(255),           /*備註                                   */
ecu04       number(5),               /*起始製程序號                           */
ecu05       number(5),               /*截止製程序號                           */
ecu06       varchar2(1),             /*No Use                                 */
ecu07       varchar2(1),             /*No Use                                 */
ecu08       varchar2(1),             /*No Use                                 */
ecu09       varchar2(1),             /*No Use                                 */
ecuacti     varchar2(1),             /*資料有效碼                             */
ecuuser     varchar2(10),            /*資料所有者                             */
ecugrup     varchar2(10),            /*資料所有群                             */
ecumodu     varchar2(10),            /*資料更改者                             */
ecudate     date,                    /*最近修改日                             */
ecu10       varchar2(1) DEFAULT ' ' NOT NULL, /*審核碼*/
ecu11       number(5),               /*變更序號                               */
ecuud01     varchar2(255),           /*自訂欄位-Textedit                      */
ecuud02     varchar2(40),            /*自訂欄位-文字                          */
ecuud03     varchar2(40),            /*自訂欄位-文字                          */
ecuud04     varchar2(40),            /*自訂欄位-文字                          */
ecuud05     varchar2(40),            /*自訂欄位-文字                          */
ecuud06     varchar2(40),            /*自訂欄位-文字                          */
ecuud07     number(15,3),            /*自訂欄位-數值                          */
ecuud08     number(15,3),            /*自訂欄位-數值                          */
ecuud09     number(15,3),            /*自訂欄位-數值                          */
ecuud10     number(10),              /*自訂欄位-整數                          */
ecuud11     number(10),              /*自訂欄位-整數                          */
ecuud12     number(10),              /*自訂欄位-整數                          */
ecuud13     date,                    /*自訂欄位-日期                          */
ecuud14     date,                    /*自訂欄位-日期                          */
ecuud15     date,                    /*自訂欄位-日期                          */
ecuoriu     varchar2(10),            /*資料建立者                             */
ecuorig     varchar2(10),            /*資料建立部門                           */
ecu012      varchar2(10) DEFAULT ' ' NOT NULL, /*製程段號*/
ecu014      varchar2(80),            /*製程段說明                             */
ecu015      varchar2(10)             /*下製程段號                             */
);

alter table ecu_file add  constraint ecu_pk primary key  (ecu01,ecu02,ecu012) enable validate;
grant select on ecu_file to tiptopgp;
grant update on ecu_file to tiptopgp;
grant delete on ecu_file to tiptopgp;
grant insert on ecu_file to tiptopgp;
grant index on ecu_file to public;
grant select on ecu_file to ods;
