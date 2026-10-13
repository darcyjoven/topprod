/*
================================================================================
檔案代號:tc_ool_file
檔案名稱:出货单/出通单额外备注维护
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_ool_file
(
tc_ool01    varchar2(40) NOT NULL,   /*出货单/出通单                          */
tc_ool02    varchar2(255),           /*出货地址                               */
tc_ool03    varchar2(1),             /*出货反馈否                             */
tc_ool04    varchar2(40),            /*NO USE                                 */
tc_ool05    varchar2(40),            /*NO USE                                 */
tc_ool06    varchar2(40),            /*NO USE                                 */
tc_ool07    varchar2(40),            /*NO USE                                 */
tc_ool08    number(15,3),            /*NO USE                                 */
tc_ool09    number(15,3),            /*NO USE                                 */
tc_ool10    number(15,3),            /*NO USE                                 */
tc_ool11    date,                    /* NO USE                                */
tc_ool12    date,                    /* NO USE                                */
tc_ool13    date                     /*NO USE                                 */
);

alter table tc_ool_file add  constraint tpc_ool_pk primary key  (tc_ool01) enable validate;
grant select on tc_ool_file to tiptopgp;
grant update on tc_ool_file to tiptopgp;
grant delete on tc_ool_file to tiptopgp;
grant insert on tc_ool_file to tiptopgp;
grant index on tc_ool_file to public;
grant select on tc_ool_file to ods;
