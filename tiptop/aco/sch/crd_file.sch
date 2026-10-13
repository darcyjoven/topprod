/*
================================================================================
檔案代號:crd_file
檔案名稱:成品/材料异动冲账差异记录档
檔案目的:记录成品/材料之异动/报关冲帐之异动差异资料
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table crd_file
(
crd00       varchar2(1) NOT NULL,    /*类型                                   */
crd01       varchar2(20) NOT NULL,   /*单据编号                               */
crd02       number(5) NOT NULL,      /*项次                                   */
crd03       date,                    /*单据日期                               */
crd04       varchar2(40),            /*料件编号                               */
crd05       varchar2(10),            /*客户编号/厂商编号                      */
crd06       varchar2(40),            /*商品编号                               */
crd07       varchar2(10),            /*海关编号                               */
crd08       varchar2(1),             /*异动方式                               */
crd09       number(20,8),            /*转换率                                 */
crd10       number(15,3),            /*异动数量                               */
crd11       varchar2(4),             /*异动单位                               */
crd12       number(15,3),            /*合同数量                               */
crd13       varchar2(4),             /*合同单位                               */
crdplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
crdlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table crd_file add  constraint crd_pk primary key  (crd00,crd01,crd02) enable validate;
grant select on crd_file to tiptopgp;
grant update on crd_file to tiptopgp;
grant delete on crd_file to tiptopgp;
grant insert on crd_file to tiptopgp;
grant index on crd_file to public;
grant select on crd_file to ods;
