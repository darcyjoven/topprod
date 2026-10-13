/*
================================================================================
檔案代號:cmc_file
檔案名稱:LCM 料件数量入库异动档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cmc_file
(
cmc01       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
cmc02       date,                    /*计算基准日                             */
                                     /*計算基準日                             */
cmc03       date NOT NULL,           /*异动日期                               */
                                     /*異動日期                               */
cmc04       number(15,5),            /*数量                                   */
                                     /*數量   (不含除外倉之入庫量)            */
cmc021      number(5) DEFAULT '0' NOT NULL, /*年度*/
cmc022      number(5) DEFAULT '0' NOT NULL, /*期别*/
cmc07       varchar2(1) DEFAULT '1' NOT NULL, /*成本计算类型*/
cmc08       varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/专案号/利润 */
cmclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cmc_file add  constraint cmc_pk primary key  (cmc01,cmc03,cmc021,cmc022,cmc07,cmc08) enable validate;
grant select on cmc_file to tiptopgp;
grant update on cmc_file to tiptopgp;
grant delete on cmc_file to tiptopgp;
grant insert on cmc_file to tiptopgp;
grant index on cmc_file to public;
grant select on cmc_file to ods;
