/*
================================================================================
檔案代號:pmo_file
檔案名稱:请购/采购单特殊说明档(打印用)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pmo_file
(
pmo01       varchar2(20) NOT NULL,   /*请购/采购单编号                        */
                                     /*請購/採購單編號                        */
pmo02       varchar2(1) NOT NULL,    /*资料性质                               */
                                     /*資料性質 (0.PR 1.PO 2.Blank PO)        */
pmo03       number(5) NOT NULL,      /*请购/采购项次                          */
                                     /*請購/採購項次                          */
                                     /*單頭的編號為:0                         */
                                     /*Line Item                              */
pmo04       varchar2(1) NOT NULL,    /*打印位置                               */
                                     /*列印位置 (0/1)                         */
                                     /*0: 在前, 1:在後(Default)               */
                                     /*Print Flag                             */
pmo05       number(5) NOT NULL,      /*行序                                   */
                                     /*Line Sequence                          */
pmo06       varchar2(255),           /*说明                                   */
                                     /*說明                                   */
                                     /*Special Note                           */
pmoplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pmolegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table pmo_file add  constraint pmo_pk primary key  (pmo01,pmo02,pmo03,pmo05,pmo04) enable validate;
grant select on pmo_file to tiptopgp;
grant update on pmo_file to tiptopgp;
grant delete on pmo_file to tiptopgp;
grant insert on pmo_file to tiptopgp;
grant index on pmo_file to public;
grant select on pmo_file to ods;
