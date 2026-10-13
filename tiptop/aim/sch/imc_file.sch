/*
================================================================================
檔案代號:imc_file
檔案名稱:品名规格额外说明资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table imc_file
(
imc01       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號ima01                          */
imc02       varchar2(20) NOT NULL,   /*品名规格额外说明类型                   */
                                     /*Part Name Specification Extra Desc Category*/
                                     /*U.S. Report Fixed Type 'IMA'           */
                                     /*Classification Of Part Name Specification Extra Desc Category, Ex.Chinese Desc.,English Desc.,Purchase Desc.,And So On*/
                                     /*Classification Desc. May Recorded In Code/No. Description*/
imc03       number(5) NOT NULL,      /*行序                                   */
imc04       varchar2(255)            /*品名规格额外说明                       */
                                     /*品名規格額外說明                       */
);

alter table imc_file add  constraint imc_pk primary key  (imc01,imc02,imc03) enable validate;
grant select on imc_file to tiptopgp;
grant update on imc_file to tiptopgp;
grant delete on imc_file to tiptopgp;
grant insert on imc_file to tiptopgp;
grant index on imc_file to public;
grant select on imc_file to ods;
