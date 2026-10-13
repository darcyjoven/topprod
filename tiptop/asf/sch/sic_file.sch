/*
================================================================================
檔案代號:sic_file
檔案名稱:工单备置单身档二
檔案目的:
上游檔案:sib_file
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sic_file
(
sic01       varchar2(20) DEFAULT ' ' NOT NULL, /*備置單號*/
sic02       number(5) DEFAULT '0' NOT NULL, /*项次*/
sic03       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
sic04       varchar2(40),            /*BOM 料号                               */
sic05       varchar2(40),            /*发料料号                               */
sic06       number(15,3) DEFAULT '0' NOT NULL, /*备置量*/
sic07       varchar2(4),             /*单位                                   */
sic08       varchar2(10),            /*仓库                                   */
sic09       varchar2(10),            /*库位                                   */
sic10       varchar2(24),            /*批号                                   */
sic11       varchar2(10),            /*作业序号                               */
sic12       varchar2(255),           /*备注                                   */
siclegal    varchar2(10) NOT NULL,   /*所属法人                               */
sicplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sic012      varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
sic013      number(5) DEFAULT '0' NOT NULL, /*工艺序*/
sic15       number(5),               /*单据项次                               */
sic07_fac   number(20,8),            /*单位数量换算率-对料件库存单            */
sic16       varchar2(80)             /*备注                                   */
);

alter table sic_file add  constraint sic_pk primary key  (sic01,sic02) enable validate;
grant select on sic_file to tiptopgp;
grant update on sic_file to tiptopgp;
grant delete on sic_file to tiptopgp;
grant insert on sic_file to tiptopgp;
grant index on sic_file to public;
grant select on sic_file to ods;
