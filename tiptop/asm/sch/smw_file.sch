/*
================================================================================
檔案代號:smw_file
檔案名稱:异动记录报表内容单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table smw_file
(
smw01       varchar2(8) NOT NULL,    /*报表编号                               */
                                     /*報表代號                               */
smw02       varchar2(80),            /*报表名称                               */
                                     /*報表名稱                               */
smw03       varchar2(136),           /*表头内容(一)                           */
                                     /*表頭內容(一)                           */
smw04       varchar2(136),           /*表头内容(二)                           */
                                     /*表頭內容(二)                           */
smw05       varchar2(136),           /*表头内容(三)                           */
                                     /*表頭內容(三)                           */
smw06       number(5),               /*报表长度                               */
                                     /*報表長度                               */
                                     /*系統維護                               */
smwdmy1     varchar2(1),             /*No Use                                 */
smwdmy2     varchar2(1),             /*No Use                                 */
smwacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
smwuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
smwgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
smwmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
smwdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
smworiu     varchar2(10),            /*资料建立者                             */
smworig     varchar2(10)             /*资料建立部门                           */
);

alter table smw_file add  constraint smw_pk primary key  (smw01) enable validate;
grant select on smw_file to tiptopgp;
grant update on smw_file to tiptopgp;
grant delete on smw_file to tiptopgp;
grant insert on smw_file to tiptopgp;
grant index on smw_file to public;
grant select on smw_file to ods;
