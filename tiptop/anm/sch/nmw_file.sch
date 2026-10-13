/*
================================================================================
檔案代號:nmw_file
檔案名稱:支票簿号码档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nmw_file
(
nmw01       varchar2(20) DEFAULT ' ' NOT NULL, /*银行编号*/
                                     /*銀行編號                               */
nmw03       date NOT NULL,           /*取票日期                               */
nmw04       varchar2(20),            /*起始票号                               */
                                     /*起始票號                               */
nmw05       varchar2(20),            /*截止票号                               */
                                     /*截止票號                               */
nmw06       number(5) NOT NULL,      /*簿号                                   */
                                     /*簿號  modi in 99/12/29                 */
nmw07       varchar2(1),             /*No Use                                 */
nmwacti     varchar2(1),             /*有效码                                 */
                                     /*有效碼                                 */
nmwuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
nmwgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
nmwmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
nmwdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
nmworig     varchar2(10),            /*资料建立部门                           */
nmworiu     varchar2(10)             /*资料建立者                             */
);

alter table nmw_file add  constraint nmw_pk primary key  (nmw01,nmw03,nmw06) enable validate;
grant select on nmw_file to tiptopgp;
grant update on nmw_file to tiptopgp;
grant delete on nmw_file to tiptopgp;
grant insert on nmw_file to tiptopgp;
grant index on nmw_file to public;
grant select on nmw_file to ods;
