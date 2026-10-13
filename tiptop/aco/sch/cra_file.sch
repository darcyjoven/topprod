/*
================================================================================
檔案代號:cra_file
檔案名稱:成品/材料冲账单头暂存档
檔案目的:记录成品/材料之异动/报关冲帐之单头资料
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cra_file
(
cra00       varchar2(1) NOT NULL,    /*类型                                   */
cra01       varchar2(40) NOT NULL,   /*商品编号                               */
cra02       varchar2(10) NOT NULL,   /*海关编号                               */
cra03       varchar2(10) NOT NULL,   /*客户编号                               */
cra04       varchar2(1) NOT NULL,    /*异动方式                               */
cra05       varchar2(20),            /*HS code                                */
craconf     varchar2(1),             /*审核否                                 */
craplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cralegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cra_file add  constraint cra_pk primary key  (cra00,cra01,cra02,cra03,cra04) enable validate;
grant select on cra_file to tiptopgp;
grant update on cra_file to tiptopgp;
grant delete on cra_file to tiptopgp;
grant insert on cra_file to tiptopgp;
grant index on cra_file to public;
grant select on cra_file to ods;
