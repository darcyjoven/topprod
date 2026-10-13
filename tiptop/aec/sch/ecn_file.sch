/*
================================================================================
檔案代號:ecn_file
檔案名稱:工作站工作历档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ecn_file
(
ecn01       varchar2(4) NOT NULL,    /*工作历编号                             */
ecn02       date NOT NULL,           /*日期                                   */
ecn03       varchar2(10) NOT NULL,   /*版本                                   */
ecn04       number(8,4),             /*工作小时                               */
ecn05       number(9,4),             /*产能效率调整(%)                        */
ecn06       varchar2(1)              /*No Use                                 */
);

alter table ecn_file add  constraint ecn_pk primary key  (ecn01,ecn02,ecn03) enable validate;
grant select on ecn_file to tiptopgp;
grant update on ecn_file to tiptopgp;
grant delete on ecn_file to tiptopgp;
grant insert on ecn_file to tiptopgp;
grant index on ecn_file to public;
grant select on ecn_file to ods;
