/*
================================================================================
檔案代號:nmk_file
檔案名稱:银行调节码资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nmk_file
(
nmk01       varchar2(2) NOT NULL,    /*调节码                                 */
                                     /*調節碼                                 */
nmk02       varchar2(80),            /*调节说明                               */
                                     /*調節說明                               */
nmk03       varchar2(1),             /*银行存款加减方式 ( + / - )             */
                                     /*銀行存款加減方式 ( + / - )             */
nmkacti     varchar2(1),             /*有效码                                 */
                                     /*有效碼                                 */
nmkuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
nmkgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
nmkmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
nmkdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
nmkorig     varchar2(10),            /*资料建立部门                           */
nmkoriu     varchar2(10)             /*资料建立者                             */
);

alter table nmk_file add  constraint nmk_pk primary key  (nmk01) enable validate;
grant select on nmk_file to tiptopgp;
grant update on nmk_file to tiptopgp;
grant delete on nmk_file to tiptopgp;
grant insert on nmk_file to tiptopgp;
grant index on nmk_file to public;
grant select on nmk_file to ods;
