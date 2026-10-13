/*
================================================================================
檔案代號:crb_file
檔案名稱:成品/材料冲账异动暂存档
檔案目的:记录成品/材料之异动/报关冲帐之异动资料
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table crb_file
(
crb00       varchar2(1) NOT NULL,    /*类型                                   */
crb01       varchar2(40) NOT NULL,   /*商品编号                               */
crb02       varchar2(10) NOT NULL,   /*海关编号                               */
crb03       varchar2(10) NOT NULL,   /*客户编号                               */
crb04       varchar2(1) NOT NULL,    /*异动方式                               */
crb05       varchar2(20) NOT NULL,   /*单据编号                               */
crb06       number(5) NOT NULL,      /*项次                                   */
crb07       date,                    /*单据日期                               */
crb08       varchar2(40),            /*料件编号                               */
crb09       number(20,8),            /*转换率                                 */
crb10       number(15,3),            /*异动数量                               */
crb11       varchar2(4),             /*异动单位                               */
crb12       number(15,3),            /*合同数量                               */
crb13       varchar2(4),             /*合同单位                               */
crbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
crblegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table crb_file add  constraint crb_pk primary key  (crb00,crb01,crb02,crb03,crb04,crb05,crb06) enable validate;
grant select on crb_file to tiptopgp;
grant update on crb_file to tiptopgp;
grant delete on crb_file to tiptopgp;
grant insert on crb_file to tiptopgp;
grant index on crb_file to public;
grant select on crb_file to ods;
