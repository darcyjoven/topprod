/*
================================================================================
檔案代號:wsc_file
檔案名稱:EasyFlow 签核纪录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table wsc_file
(
wsc01       varchar2(80) NOT NULL,   /*送签单号                               */
wsc02       varchar2(20),            /*EasyFlow 单别                          */
wsc03       varchar2(32),            /*EasyFlow 单号                          */
wsc04       varchar2(100),           /*关号                                   */
wsc05       varchar2(4),             /*支号                                   */
wsc06       varchar2(40),            /*签核人员姓名                           */
wsc07       varchar2(80),            /*签核人员职级                           */
wsc08       varchar2(2),             /*签核结果                               */
wsc09       varchar2(255),           /*签核意见                               */
wsc10       date,                    /*签核日期                               */
wsc11       date,                    /*资料异动日期                           */
wsc12       varchar2(8),             /*资料异动时间                           */
wsc13       varchar2(80),            /*图档名称                               */
wsc14       varchar2(10),            /*No Use                                 */
wsc15       varchar2(20),            /*程序代码                               */
wsc16       varchar2(100)            /*EF签核人员工号                         */
);

create        index wsc_01 on wsc_file (wsc01);
grant select on wsc_file to tiptopgp;
grant update on wsc_file to tiptopgp;
grant delete on wsc_file to tiptopgp;
grant insert on wsc_file to tiptopgp;
grant index on wsc_file to public;
grant select on wsc_file to ods;
