/*
================================================================================
檔案代號:inbslk_file
檔案名稱:库存异动母单身档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table inbslk_file
(
inbslk01    varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
inbslk03    number(5) DEFAULT '0' NOT NULL, /*项次*/
inbslk04    varchar2(40),            /*母料件编号                             */
inbslk05    varchar2(10),            /*仓库                                   */
inbslk06    varchar2(10),            /*库位                                   */
inbslk07    varchar2(24),            /*批号                                   */
inbslk08    varchar2(4),             /*单位                                   */
inbslk08_fac number(20,8) DEFAULT '0' NOT NULL, /*转换率*/
inbslk09    number(15,3) DEFAULT '0' NOT NULL, /*异动数量*/
inbslk15    varchar2(10),            /*理由码                                 */
inbslklegal varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
inbslkplant varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table inbslk_file add  constraint inbslk_pk primary key  (inbslk01,inbslk03) enable validate;
grant select on inbslk_file to tiptopgp;
grant update on inbslk_file to tiptopgp;
grant delete on inbslk_file to tiptopgp;
grant insert on inbslk_file to tiptopgp;
grant index on inbslk_file to public;
grant select on inbslk_file to ods;
