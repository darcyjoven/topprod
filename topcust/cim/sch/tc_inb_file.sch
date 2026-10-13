/*
================================================================================
檔案代號:tc_inb_file
檔案名稱:先进先出表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_inb_file
(
tc_inb01    varchar2(20) NOT NULL,   /*单据编号                               */
tc_inb02    number(5) NOT NULL,      /*项次                                   */
tc_inb03    varchar2(40),            /*料号                                   */
tc_inb04    varchar2(10),            /*仓库                                   */
tc_inb05    varchar2(15),            /*理由码                                 */
tc_inb06    varchar2(1),             /*检验否                                 */
tc_inbuser  varchar2(10),            /*资料建立者                             */
tc_inb07    number(15,3)             /*异动数量                               */
);

alter table tc_inb_file add  constraint tpc_inb_pk primary key  (tc_inb01,tc_inb02) enable validate;
grant select on tc_inb_file to tiptopgp;
grant update on tc_inb_file to tiptopgp;
grant delete on tc_inb_file to tiptopgp;
grant insert on tc_inb_file to tiptopgp;
grant index on tc_inb_file to public;
grant select on tc_inb_file to ods;
