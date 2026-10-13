/*
================================================================================
檔案代號:bwe_file
檔案名稱:保税盘点折合资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table bwe_file
(
bwe00       varchar2(1) NOT NULL,    /*类型                                   */
                                     /* S:庫存盤點: bwa_file                  */
                                     /*W:工單盤點: bwb_file, bwc_file         */
bwe01       varchar2(20) NOT NULL,   /*标签编号                               */
bwe02       number(5) NOT NULL,      /*序号                                   */
bwe03       varchar2(40) NOT NULL,   /*料件编号                               */
bwe031      number(20,8),            /*单位用量                               */
bwe04       number(15,4),            /*折合数量                               */
                                     /*庫存單位                               */
bwe05       varchar2(1),             /*区分                                   */
                                     /*區分:本欄位僅在類別為W時使用           */
                                     /*         若下階用料為原料時='1'        */
                                     /*         若是由半成品往下展時='2'      */
                                     /*         本欄位供彙總bwf_file時使用    */
bwe011      number(5) NOT NULL,      /*年度                                   */
bweplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bwelegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table bwe_file add  constraint bwe_pk primary key  (bwe00,bwe01,bwe02,bwe011,bwe03) enable validate;
grant select on bwe_file to tiptopgp;
grant update on bwe_file to tiptopgp;
grant delete on bwe_file to tiptopgp;
grant insert on bwe_file to tiptopgp;
grant index on bwe_file to public;
grant select on bwe_file to ods;
