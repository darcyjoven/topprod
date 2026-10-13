/*
================================================================================
檔案代號:oqv_file
檔案名稱:报价单-分量计价资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oqv_file
(
oqv01       varchar2(20) NOT NULL,   /*报价单号                               */
                                     /*報價單號                               */
oqv02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
oqv03       number(15,3) NOT NULL,   /*启始数量                               */
                                     /*啟始數量                               */
oqv04       number(15,3) NOT NULL,   /*截止数量                               */
                                     /*截止數量                               */
oqv05       number(20,6),            /*单价                                   */
                                     /*單價                                   */
oqvplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oqvlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table oqv_file add  constraint oqv_pk primary key  (oqv01,oqv02,oqv03,oqv04) enable validate;
grant select on oqv_file to tiptopgp;
grant update on oqv_file to tiptopgp;
grant delete on oqv_file to tiptopgp;
grant insert on oqv_file to tiptopgp;
grant index on oqv_file to public;
grant select on oqv_file to ods;
