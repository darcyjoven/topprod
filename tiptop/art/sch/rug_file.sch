/*
================================================================================
檔案代號:rug_file
檔案名稱:压货商品单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rug_file
(
rug01       varchar2(20) DEFAULT ' ' NOT NULL, /*补货单号*/
rug02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rug03       varchar2(40),            /*产品编号                               */
rug04       varchar2(4),             /*补货单位                               */
rug05       number(15,3),            /*补货数量                               */
rug06       date,                    /*需求日期                               */
rug07       varchar2(8),             /*需求时间                               */
rug08       varchar2(255),           /*备注                                   */
rug09       varchar2(10),            /*补货营运中心                           */
ruglegal    varchar2(10) NOT NULL,   /*法人别                                 */
rugplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table rug_file add  constraint rug_pk primary key  (rug01,rug02) enable validate;
grant select on rug_file to tiptopgp;
grant update on rug_file to tiptopgp;
grant delete on rug_file to tiptopgp;
grant insert on rug_file to tiptopgp;
grant index on rug_file to public;
grant select on rug_file to ods;
