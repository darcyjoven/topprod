/*
================================================================================
檔案代號:crg_file
檔案名稱:成品/材料报关冲账记录档
檔案目的:记录成品/材料之异动/报关冲帐之报关资料
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table crg_file
(
crg01       number(10) NOT NULL,     /*冲帐序号                               */
crg02       date,                    /*冲帐日期                               */
crg03       varchar2(8),             /*冲帐时间                               */
crg04       varchar2(40),            /*商品编号                               */
crg05       varchar2(10),            /*海关编号                               */
crg06       varchar2(10),            /*商品编号/厂商编号                      */
crg07       varchar2(1),             /*异动方式                               */
crg08       varchar2(20) NOT NULL,   /*手册编号                               */
crg09       varchar2(30),            /*报关单号                               */
crg10       date,                    /*报单日期                               */
crg11       number(15,3),            /*申请数量                               */
crg12       number(15,3),            /*可用数量                               */
crg13       varchar2(4),             /*合同单位                               */
crg14       number(15,3),            /*已扣未报关                             */
crg15       number(15,3),            /*扣销数量                               */
crgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
crglegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table crg_file add  constraint crg_pk primary key  (crg01,crg08) enable validate;
grant select on crg_file to tiptopgp;
grant update on crg_file to tiptopgp;
grant delete on crg_file to tiptopgp;
grant insert on crg_file to tiptopgp;
grant index on crg_file to public;
grant select on crg_file to ods;
