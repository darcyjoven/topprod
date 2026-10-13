/*
================================================================================
檔案代號:ope_file
檔案名稱:销售预测单身分摊档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ope_file
(
ope01       varchar2(40) DEFAULT ' ' NOT NULL, /*权数编号*/
                                     /*權數代號                               */
ope02       varchar2(10) DEFAULT ' ' NOT NULL, /*说明*/
                                     /*說明                                   */
ope03       date DEFAULT sysdate NOT NULL, /*No Use*/
ope04       varchar2(10) DEFAULT ' ' NOT NULL, /*No Use*/
ope05       number(5) DEFAULT '0' NOT NULL, /*序号*/
ope06       date NOT NULL,           /*分摊日期                               */
ope07       date,                    /*no user                                */
ope08       number(15,3),            /*计划数量                               */
ope09       number(15,3),            /*审核数量                               */
ope10       number(20,6),            /*单价                                   */
ope11       number(20,6),            /*金额                                   */
opeplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
opelegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ope_file add  constraint ope_pk primary key  (ope01,ope02,ope03,ope04,ope05,ope06) enable validate;
grant select on ope_file to tiptopgp;
grant update on ope_file to tiptopgp;
grant delete on ope_file to tiptopgp;
grant insert on ope_file to tiptopgp;
grant index on ope_file to public;
grant select on ope_file to ods;
