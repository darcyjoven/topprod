/*
================================================================================
檔案代號:lij_file
檔案名稱:合同费用项设置单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lij_file
(
lij01       varchar2(20) DEFAULT ' ' NOT NULL, /*方案编号*/
lij02       varchar2(10) DEFAULT ' ' NOT NULL, /*费用编号*/
lij03       varchar2(10),            /*付款方式编号                           */
lij04       varchar2(1) DEFAULT ' ' NOT NULL, /*日核算算法*/
lij05       varchar2(1) DEFAULT ' ' NOT NULL, /*核算制度*/
lij06       varchar2(1) DEFAULT ' ' NOT NULL, /*标准否*/
lij07       number(5),               /*出账期                                 */
lij08       number(5),               /*出账日                                 */
lijlegal    varchar2(10),            /*法人                                   */
lijplant    varchar2(10)             /*门店编号                               */
);

alter table lij_file add  constraint lij_pk primary key  (lij01,lij02) enable validate;
grant select on lij_file to tiptopgp;
grant update on lij_file to tiptopgp;
grant delete on lij_file to tiptopgp;
grant insert on lij_file to tiptopgp;
grant index on lij_file to public;
grant select on lij_file to ods;
