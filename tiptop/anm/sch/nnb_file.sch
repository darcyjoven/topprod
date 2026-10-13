/*
================================================================================
檔案代號:nnb_file
檔案名稱:融资贷款备注
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nnb_file
(
nnb01       varchar2(20) NOT NULL,   /*相关单号                               */
                                     /*相關單號                               */
nnb02       varchar2(1) NOT NULL,    /*资料性质                               */
                                     /*資料性質                               */
                                     /*1:短期融資                             */
                                     /*2:中長期貸款                           */
nnb03       number(5) NOT NULL,      /*行序                                   */
nnb04       varchar2(255),           /*说明                                   */
                                     /*說明                                   */
nnblegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table nnb_file add  constraint nnb_pk primary key  (nnb01,nnb02,nnb03) enable validate;
grant select on nnb_file to tiptopgp;
grant update on nnb_file to tiptopgp;
grant delete on nnb_file to tiptopgp;
grant insert on nnb_file to tiptopgp;
grant index on nnb_file to public;
grant select on nnb_file to ods;
