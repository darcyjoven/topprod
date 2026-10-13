/*
================================================================================
檔案代號:rwg_file
檔案名稱:组合商品单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rwg_file
(
rwg01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rwg02       varchar2(20) DEFAULT ' ' NOT NULL, /*活动代码*/
rwg03       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
                                     /*Promotion Type 4.Assembly Promotion    */
rwg04       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rwg05       number(5) DEFAULT '0' NOT NULL, /*项次*/
rwg06       varchar2(40),            /*产品编号                               */
rwg07       varchar2(4),             /*库存单位                               */
rwg08       varchar2(40),            /*产品条码                               */
rwg09       varchar2(4),             /*促销单位                               */
rwg10       number(16,8),            /*换算率                                 */
                                     /*Conversion Rate - Promotion Unit: Stock Unit*/
rwg11       number(15,3),            /*数量                                   */
rwglegal    varchar2(10) NOT NULL,   /*所属法人                               */
rwgplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table rwg_file add  constraint rwg_pk primary key  (rwg01,rwg02,rwg03,rwg04,rwg05,rwgplant) enable validate;
grant select on rwg_file to tiptopgp;
grant update on rwg_file to tiptopgp;
grant delete on rwg_file to tiptopgp;
grant insert on rwg_file to tiptopgp;
grant index on rwg_file to public;
grant select on rwg_file to ods;
