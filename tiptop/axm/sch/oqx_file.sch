/*
================================================================================
檔案代號:oqx_file
檔案名稱:报价单费用档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oqx_file
(
oqx01       varchar2(20) NOT NULL,   /*报价单号                               */
                                     /*報價單號                               */
oqx03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次 (0 表示單頭備註)                  */
oqx04       varchar2(10) NOT NULL,   /*费用编号                               */
                                     /*費用代號                               */
oqx041      varchar2(4),             /*币种编号                               */
                                     /*幣別代號                               */
oqx05       number(20,6),            /*费用金额                               */
                                     /*費用金額(原幣)                         */
oqx06       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
oqxplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oqxlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table oqx_file add  constraint oqx_pk primary key  (oqx01,oqx03,oqx04) enable validate;
grant select on oqx_file to tiptopgp;
grant update on oqx_file to tiptopgp;
grant delete on oqx_file to tiptopgp;
grant insert on oqx_file to tiptopgp;
grant index on oqx_file to public;
grant select on oqx_file to ods;
