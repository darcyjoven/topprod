/*
================================================================================
檔案代號:pmp_file
檔案名稱:请购/采购单重要备忘档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pmp_file
(
pmp01       varchar2(20) NOT NULL,   /*请购/采购单编号                        */
                                     /*請購/採購單編號                        */
                                     /*Special Note Code                      */
pmp02       varchar2(1) NOT NULL,    /*资料性质                               */
                                     /*資料性質                               */
                                     /*Data Type                              */
                                     /*0:請購單                               */
                                     /*1:採購單                               */
pmp03       date NOT NULL,           /*记录日期                               */
                                     /*記錄日期                               */
                                     /*Date                                   */
pmp04       number(5) NOT NULL,      /*行序                                   */
                                     /*Line Sequence                          */
pmp05       varchar2(255),           /*说明                                   */
                                     /*說明                                   */
                                     /*Description                            */
pmpplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pmplegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table pmp_file add  constraint pmp_pk primary key  (pmp01,pmp03,pmp02,pmp04) enable validate;
grant select on pmp_file to tiptopgp;
grant update on pmp_file to tiptopgp;
grant delete on pmp_file to tiptopgp;
grant insert on pmp_file to tiptopgp;
grant index on pmp_file to public;
grant select on pmp_file to ods;
