/*
================================================================================
檔案代號:hrdna_file
檔案名稱:员工银行帐号档明细
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdna_file
(
hrdna01     varchar2(10) NOT NULL,   /*流水码                                 */
hrdna02     number(5) NOT NULL,      /*项次                                   */
hrdna03     varchar2(20),            /*员工ID                                 */
hrdna04     date,                    /*设置日期                               */
hrdna05     varchar2(50),            /*开始薪资月                             */
hrdna06     varchar2(50),            /*结束薪资月                             */
hrdna07     varchar2(1),             /*是否有效                               */
hrdna08     varchar2(4000)
);

alter table hrdna_file add  constraint tpc_hrdna_pk primary key  (hrdna01,hrdna02) enable validate;
grant select on hrdna_file to tiptopgp;
grant update on hrdna_file to tiptopgp;
grant delete on hrdna_file to tiptopgp;
grant insert on hrdna_file to tiptopgp;
grant index on hrdna_file to public;
grant select on hrdna_file to ods;
