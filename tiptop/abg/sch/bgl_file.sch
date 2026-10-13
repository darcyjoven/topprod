/*
================================================================================
檔案代號:bgl_file
檔案名稱:预估人工/制费/加工费用档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bgl_file
(
bgl01       varchar2(10) NOT NULL,   /*版本                                   */
bgl02       number(5) NOT NULL,      /*年度                                   */
bgl03       number(5) NOT NULL,      /*月份                                   */
bgl04       varchar2(10) NOT NULL,   /*部门编号                               */
                                     /*部門編號                               */
bgl05       number(20,6),            /*总人工金额                             */
                                     /*總人工金額                             */
bgl06       number(20,6),            /*总制费金额                             */
                                     /*總製費金額                             */
bgl07       number(20,6),            /*总加工金额                             */
                                     /*總加工金額                             */
bgl08       varchar2(1)              /*No Use                                 */
);

alter table bgl_file add  constraint bgl_pk primary key  (bgl01,bgl02,bgl03,bgl04) enable validate;
grant select on bgl_file to tiptopgp;
grant update on bgl_file to tiptopgp;
grant delete on bgl_file to tiptopgp;
grant insert on bgl_file to tiptopgp;
grant index on bgl_file to public;
grant select on bgl_file to ods;
