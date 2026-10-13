/*
================================================================================
檔案代號:gis_file
檔案名稱:现金流量活动科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gis_file
(
gis01       varchar2(6) NOT NULL,    /*群组代码                               */
                                     /*群組代碼                               */
gis02       varchar2(24) NOT NULL,   /*科目编号                               */
                                     /*科目編號                               */
gis03       varchar2(1),             /*加减项 +.加项 / -.减项                 */
                                     /*加減項 +.加項 / -.減項                 */
gis04       varchar2(1),             /*1.异动 2.期初 3.期末 4.人工录          */
                                     /*1.異動 2.期初 3.期末 4.人工輸入        */
                                     /*5.借方異動    6.貸方異動               */
gis00       varchar2(5) NOT NULL,    /*帐套                                   */
gis05       varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
gis06       varchar2(10) DEFAULT ' ' NOT NULL /*母公司代号*/
);

alter table gis_file add  constraint gis_pk primary key  (gis00,gis01,gis02,gis05,gis06) enable validate;
grant select on gis_file to tiptopgp;
grant update on gis_file to tiptopgp;
grant delete on gis_file to tiptopgp;
grant insert on gis_file to tiptopgp;
grant index on gis_file to public;
grant select on gis_file to ods;
