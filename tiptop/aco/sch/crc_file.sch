/*
================================================================================
檔案代號:crc_file
檔案名稱:成品/材料冲账报关暂存档
檔案目的:记录成品/材料之异动/报关冲帐之报关资料
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table crc_file
(
crc00       varchar2(1) NOT NULL,    /*类型                                   */
crc01       varchar2(40) NOT NULL,   /*商品编号                               */
crc02       varchar2(10) NOT NULL,   /*海关编号                               */
crc03       varchar2(10) NOT NULL,   /*客户编号/厂商编号                      */
crc04       varchar2(1) NOT NULL,    /*异动方式                               */
crc05       varchar2(20) NOT NULL,   /*手册编号                               */
crc06       varchar2(30),            /*报关单号                               */
crc07       date,                    /*报关日期                               */
crc08       number(15,3),            /*申请数量                               */
crc09       number(15,3),            /*可用数量                               */
crc10       varchar2(4),             /*合同单位                               */
crc11       number(15,3),            /*已扣未报关                             */
crc12       number(15,3),            /*扣销数量                               */
crcplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
crclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table crc_file add  constraint crc_pk primary key  (crc00,crc01,crc02,crc03,crc04,crc05) enable validate;
grant select on crc_file to tiptopgp;
grant update on crc_file to tiptopgp;
grant delete on crc_file to tiptopgp;
grant insert on crc_file to tiptopgp;
grant index on crc_file to public;
grant select on crc_file to ods;
