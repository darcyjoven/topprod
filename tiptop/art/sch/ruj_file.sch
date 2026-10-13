/*
================================================================================
檔案代號:ruj_file
檔案名稱:库存调整申请单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ruj_file
(
ruj00       varchar2(10) DEFAULT ' ',/*no use                                 */
ruj01       varchar2(20) DEFAULT ' ' NOT NULL, /*调整单号*/
ruj02       number(5) DEFAULT '0' NOT NULL, /*项次*/
ruj03       varchar2(40),            /*商品编号                               */
ruj04       varchar2(10),            /*单位                                   */
ruj05       varchar2(10),            /*仓库                                   */
ruj06       number(5),               /*收货项次                               */
ruj07       varchar2(10),            /*供应商仓库                             */
ruj08       number(15,3),            /*申请数量                               */
ruj09       number(15,3),            /*核准数量                               */
ruj10       varchar2(10),            /*调整原因                               */
ruj11       varchar2(255),           /*備注                                   */
ruj12       varchar2(1) DEFAULT ' ' NOT NULL, /*調整類型1.調增2.調減*/
                                     /*1. Increase 2. Decrease                */
rujlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rujplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table ruj_file add  constraint ruj_pk primary key  (ruj01,ruj02) enable validate;
grant select on ruj_file to tiptopgp;
grant update on ruj_file to tiptopgp;
grant delete on ruj_file to tiptopgp;
grant insert on ruj_file to tiptopgp;
grant index on ruj_file to public;
grant select on ruj_file to ods;
