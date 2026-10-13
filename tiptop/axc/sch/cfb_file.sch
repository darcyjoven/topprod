/*
================================================================================
檔案代號:cfb_file
檔案名稱:发出商品档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cfb_file
(
cfb00       varchar2(1) DEFAULT ' ' NOT NULL, /*来源*/
cfb01       varchar2(5) DEFAULT ' ' NOT NULL, /*方向*/
cfb02       varchar2(100) DEFAULT ' ' NOT NULL, /*发票号*/
cfb03       varchar2(10) DEFAULT ' ' NOT NULL, /*来源营运中心*/
cfb04       varchar2(20) DEFAULT ' ' NOT NULL, /*出货单号*/
cfb05       number(5) DEFAULT '0' NOT NULL, /*项次*/
cfb06       date,                    /*单据日期                               */
cfb07       varchar2(10),            /*客户编号                               */
cfb08       varchar2(40),            /*客户简称                               */
cfb09       varchar2(10),            /*人员编号                               */
cfb10       varchar2(10),            /*部门编号                               */
cfb11       varchar2(40),            /*产品编号                               */
cfb12       varchar2(4),             /*销售单位                               */
cfb13       varchar2(120),           /*品名                                   */
cfb14       varchar2(10),            /*仓库编号                               */
cfb15       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
cfb141      varchar2(10),            /*库位编号                               */
cfb142      varchar2(24),            /*批号                                   */
cfb16       varchar2(20) DEFAULT ' ' NOT NULL, /*发票代码*/
cfb17       varchar2(4),             /*库存单位                               */
cfb18       number(20,8),            /*转换率                                 */
cfb19       varchar2(24),            /*科目编号                               */
cfb20       varchar2(1) NOT NULL,    /*多角贸易否                             */
cfb061      date                     /*开票日期                               */
);

alter table cfb_file add  constraint cfb_pk primary key  (cfb00,cfb01,cfb02,cfb03,cfb04,cfb05,cfb16) enable validate;
grant select on cfb_file to tiptopgp;
grant update on cfb_file to tiptopgp;
grant delete on cfb_file to tiptopgp;
grant insert on cfb_file to tiptopgp;
grant index on cfb_file to public;
grant select on cfb_file to ods;
