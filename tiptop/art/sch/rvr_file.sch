/*
================================================================================
檔案代號:rvr_file
檔案名稱:调拨申请单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvr_file
(
rvr01       varchar2(20) DEFAULT ' ' NOT NULL, /*申请单号*/
rvr02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rvr03       number(5) DEFAULT '0' NOT NULL, /*来源项次*/
rvr04       varchar2(40),            /*产品编号                               */
rvr05       varchar2(40),            /*商品条码                               */
rvr06       varchar2(4),             /*调拨单位                               */
rvr07       number(16,8),            /*换算率                                 */
rvr08       number(15,3),            /*申请量                                 */
rvr09       number(15,3),            /*核准量                                 */
rvrlegal    varchar2(10),            /*法人别                                 */
rvrplant    varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心别*/
rvr00       varchar2(10) DEFAULT ' ' NOT NULL, /*单据类型*/
rvr10       varchar2(10),            /*原因码                                 */
rvr11       varchar2(255)            /*备注                                   */
);

create unique index rvr_01 on rvr_file (rvr01,rvr02,rvrplant);
alter table rvr_file add  constraint rvr_pk primary key  (rvr01,rvr02,rvrplant) enable validate;
grant select on rvr_file to tiptopgp;
grant update on rvr_file to tiptopgp;
grant delete on rvr_file to tiptopgp;
grant insert on rvr_file to tiptopgp;
grant index on rvr_file to public;
grant select on rvr_file to ods;
