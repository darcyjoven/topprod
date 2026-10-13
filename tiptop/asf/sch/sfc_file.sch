/*
================================================================================
檔案代號:sfc_file
檔案名稱:料表批号主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sfc_file
(
sfc01       varchar2(20) NOT NULL,   /*料表批号(PBI number)                   */
                                     /*料表批號  (PBI number)                 */
                                     /*儲存合併料表的批次編號                 */
                                     /*此號碼可作為工單領/發料及料帳扣除時的  */
                                     /*處理依據                               */
sfc02       varchar2(80),            /*描述                                   */
                                     /*儲存批號需特別加以說明的記錄           */
sfc91       varchar2(1),             /*用户自订                               */
                                     /*使用者自訂                             */
sfc92       varchar2(1),             /*用户自订                               */
                                     /*使用者自訂                             */
sfc93       varchar2(1),             /*用户自订                               */
                                     /*使用者自訂                             */
sfc94       varchar2(1),             /*用户自订                               */
                                     /*使用者自訂                             */
sfc95       varchar2(1),             /*用户自订                               */
                                     /*使用者自訂                             */
sfcuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護                               */
sfcgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護                               */
sfcmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護                               */
sfcdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護                               */
sfcacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護                               */
sfcoriu     varchar2(10),            /*资料建立者                             */
sfcorig     varchar2(10),            /*资料建立部门                           */
sfc03       varchar2(20),            /*no use                                 */
sfcconf     varchar2(1) DEFAULT 'N', /*no use                                 */
sfc04       varchar2(50)             /*计画批号                               */
);

alter table sfc_file add  constraint sfc_pk primary key  (sfc01) enable validate;
grant select on sfc_file to tiptopgp;
grant update on sfc_file to tiptopgp;
grant delete on sfc_file to tiptopgp;
grant insert on sfc_file to tiptopgp;
grant index on sfc_file to public;
grant select on sfc_file to ods;
