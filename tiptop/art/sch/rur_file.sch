/*
================================================================================
檔案代號:rur_file
檔案名稱:借出/还入单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rur_file
(
rur00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据别1-借出单,2-还入单*/
                                     /*Doc Type 1-Lending Note 2-Return Note  */
rur01       varchar2(20) DEFAULT ' ' NOT NULL, /*借出/还入单单号*/
rur02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rur03       varchar2(40),            /*产品编号                               */
rur04       varchar2(4),             /*库存单位                               */
rur05       varchar2(40),            /*产品条码                               */
rur06       varchar2(4),             /*借出单位                               */
rur07       number(20,8),            /*换算率-送货单位：库存单位              */
                                     /*Conversion Rate- Delivery Unit: Inventory Unit*/
rur08       number(20,6) DEFAULT '0' NOT NULL, /*单价*/
rur09       varchar2(10),            /*仓库                                   */
rur10       varchar2(10),            /*库位                                   */
rur11       varchar2(24),            /*批号                                   */
rur12       number(15,3) DEFAULT '0' NOT NULL, /*借出数量*/
rur13       number(15,3) DEFAULT '0' NOT NULL, /*已还数量*/
rur14       number(15,3) DEFAULT '0' NOT NULL, /*本次返还数量*/
rur15       number(20,6) DEFAULT '0' NOT NULL, /*金额*/
rur16       varchar2(10),            /*挂帐仓库                               */
rur17       varchar2(10),            /*挂账库位                               */
rur18       varchar2(24),            /*挂账批号                               */
rur19       varchar2(1) DEFAULT 'N' NOT NULL, /*结案否Y-是N-否*/
rur20       varchar2(10),            /*理由码                                 */
rur21       varchar2(255),           /*備注                                   */
rurlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rurplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table rur_file add  constraint rur_pk primary key  (rur00,rur01,rur02) enable validate;
grant select on rur_file to tiptopgp;
grant update on rur_file to tiptopgp;
grant delete on rur_file to tiptopgp;
grant insert on rur_file to tiptopgp;
grant index on rur_file to public;
grant select on rur_file to ods;
