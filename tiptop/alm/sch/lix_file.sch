/*
================================================================================
檔案代號:lix_file
檔案名稱:摊位状态明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lix_file
(
lix01       varchar2(20) DEFAULT ' ' NOT NULL, /*摊位编号*/
lix02       date DEFAULT sysdate NOT NULL, /*开始日期*/
lix03       date,                    /*结束日期                               */
lix04       varchar2(10),            /*楼栋编号                               */
lix05       varchar2(10),            /*楼层编号                               */
lix06       varchar2(10),            /*区域编号                               */
lix07       varchar2(10),            /*经营小类                               */
lix08       varchar2(10),            /*攤位用途                               */
lix09       varchar2(1) DEFAULT ' ' NOT NULL, /*攤位狀態*/
lix10       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lix11       varchar2(1) DEFAULT ' ' NOT NULL, /*来源类型*/
lix12       varchar2(20),            /*参考单号                               */
lix13       number(5),               /*版本号                                 */
lix14       varchar2(10),            /*商户编号                               */
lix15       number(20,6),            /*建筑面积                               */
lix16       number(20,6),            /*測量面積                               */
lix17       number(20,6),            /*经营面积                               */
lix18       number(20,6),            /*金额                                   */
lixlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
lixplant    varchar2(10) DEFAULT ' ' NOT NULL, /*门店编号*/
lix19       number(20,6)             /*销售金额                               */
);

alter table lix_file add  constraint lix_pk primary key  (lix01,lix02) enable validate;
grant select on lix_file to tiptopgp;
grant update on lix_file to tiptopgp;
grant delete on lix_file to tiptopgp;
grant insert on lix_file to tiptopgp;
grant index on lix_file to public;
grant select on lix_file to ods;
