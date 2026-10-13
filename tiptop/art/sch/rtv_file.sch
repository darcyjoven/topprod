/*
================================================================================
檔案代號:rtv_file
檔案名稱:促銷協議單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rtv_file
(
rtv01       varchar2(20) DEFAULT ' ' NOT NULL, /*促销协议编号*/
rtv02       varchar2(10) DEFAULT ' ' NOT NULL, /*签订机构*/
rtv03       number(5) DEFAULT '0' NOT NULL, /*项次*/
rtv04       varchar2(40),            /*产品编号                               */
rtv05       varchar2(4),             /*库存单位                               */
rtv06       number(5,2),             /*促销折扣比例%                          */
rtv07       number(20,6),            /*促销税前单价                           */
rtv07t      number(20,6),            /*促销含税单价                           */
rtv08       number(5),               /*采购量满                               */
rtv09       number(5),               /*采购额满                               */
rtv10       number(5),               /*可搭赠量                               */
rtv11       number(5,2),             /*可折扣率%                              */
rtv12       number(5,2),             /*结算扣率%                              */
rtv13       number(5,2),             /*促销分摊比例%                          */
rtv14       varchar2(4),             /*默认采购单位                           */
rtvlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rtvplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table rtv_file add  constraint rtv_pk primary key  (rtv01,rtv02,rtv03,rtvplant) enable validate;
grant select on rtv_file to tiptopgp;
grant update on rtv_file to tiptopgp;
grant delete on rtv_file to tiptopgp;
grant insert on rtv_file to tiptopgp;
grant index on rtv_file to public;
grant select on rtv_file to ods;
