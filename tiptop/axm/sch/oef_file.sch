/*
================================================================================
檔案代號:oef_file
檔案名稱:订单费用档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oef_file
(
oef01       varchar2(20) NOT NULL,   /*订单号                                 */
                                     /*訂單號                                 */
oef03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次 (0 表示單頭備註)                  */
oef04       varchar2(10) NOT NULL,   /*费用编号                               */
                                     /*費用代號                               */
oef05       number(20,6),            /*费用金额                               */
                                     /*費用金額 (本幣)                        */
oef06       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
oefplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oeflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table oef_file add  constraint oef_pk primary key  (oef01,oef03,oef04) enable validate;
grant select on oef_file to tiptopgp;
grant update on oef_file to tiptopgp;
grant delete on oef_file to tiptopgp;
grant insert on oef_file to tiptopgp;
grant index on oef_file to public;
grant select on oef_file to ods;
