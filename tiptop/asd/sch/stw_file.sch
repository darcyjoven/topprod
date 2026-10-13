/*
================================================================================
檔案代號:stw_file
檔案名稱:差异分摊基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table stw_file
(
stw01       varchar2(1) NOT NULL,    /*类型                                   */
                                     /*類別:1:材料 2:成品 3:半成品            */
stw02       varchar2(10) NOT NULL,   /*产品别                                 */
                                     /*產品別                                 */
stw03       number(20,6)             /*差异金额                               */
                                     /*差異金額                               */
);

alter table stw_file add  constraint stw_pk primary key  (stw01,stw02) enable validate;
grant select on stw_file to tiptopgp;
grant update on stw_file to tiptopgp;
grant delete on stw_file to tiptopgp;
grant insert on stw_file to tiptopgp;
grant index on stw_file to public;
grant select on stw_file to ods;
