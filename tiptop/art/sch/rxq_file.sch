/*
================================================================================
檔案代號:rxq_file
檔案名稱:商品寄送/送货单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rxq_file
(
rxq00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据别*/
                                     /*Doc. Type 1-Storage 2-Delivery         */
rxq01       varchar2(20) DEFAULT ' ' NOT NULL, /*单号*/
rxq02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rxq03       number(5) DEFAULT '0' NOT NULL, /*来源项次*/
rxq04       varchar2(40),            /*产品编号                               */
rxq05       varchar2(120),           /*产品名称                               */
rxq06       varchar2(4),             /*单位                                   */
rxq07       number(15,3) DEFAULT '0' NOT NULL, /*寄存/送货量*/
rxq08       number(15,3) DEFAULT '0' NOT NULL, /*已提/送量*/
rxq09       varchar2(255),           /*备注                                   */
rxq10       varchar2(1) DEFAULT ' ' NOT NULL, /*结案码*/
rxqlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rxqplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table rxq_file add  constraint rxq_pk primary key  (rxq00,rxq01,rxq02) enable validate;
grant select on rxq_file to tiptopgp;
grant update on rxq_file to tiptopgp;
grant delete on rxq_file to tiptopgp;
grant insert on rxq_file to tiptopgp;
grant index on rxq_file to public;
grant select on rxq_file to ods;
