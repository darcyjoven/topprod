/*
================================================================================
檔案代號:csc_file
檔案名稱:成本模拟编号主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table csc_file
(
csc01       varchar2(1) NOT NULL,    /*成本模拟版本编号                       */
csc02       varchar2(1),             /*模拟成本方式                           */
csc03       date,                    /*模拟日期                               */
csc04       varchar2(5),             /*模拟起始时间                           */
csc05       varchar2(5),             /*模拟截止时间                           */
csc06       varchar2(10),            /*模拟者                                 */
csc07       varchar2(40),            /*模拟料件编号                           */
csc08       date,                    /*有效日期                               */
csc09       number(5),               /*模拟工艺编号                           */
csc10       varchar2(1),             /*大宗料件及杂项料件是否包含             */
csc11       varchar2(1),             /*自制料件是否使用采购料件方             */
csc12       varchar2(1),             /*采购料件是否使用自制料件方             */
csc13       varchar2(1),             /*采购料件及杂项料件其人工/制            */
csc14       varchar2(1),             /*当前版本是否正使用中                   */
csc15       varchar2(1),             /*成本卷算运行环境                       */
csc16       varchar2(80)             /*模拟版本描述说明                       */
);

alter table csc_file add  constraint csc_pk primary key  (csc01) enable validate;
grant select on csc_file to tiptopgp;
grant update on csc_file to tiptopgp;
grant delete on csc_file to tiptopgp;
grant insert on csc_file to tiptopgp;
grant index on csc_file to public;
grant select on csc_file to ods;
