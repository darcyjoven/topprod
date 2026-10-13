/*
================================================================================
檔案代號:naa_file
檔案名稱:银行质押资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table naa_file
(
naa00       varchar2(1),             /*1.短期融资 2.中长期融资                */
                                     /*1.短期融資 2.中長期融資                */
naa01       varchar2(20) NOT NULL,   /*单号                                   */
                                     /*單號                                   */
naa02       varchar2(30),            /*保证人                                 */
                                     /*保證人                                 */
naa03       varchar2(30),            /*担保人一                               */
                                     /*擔保人一                               */
naa04       varchar2(30),            /*担保人二                               */
                                     /*擔保人二                               */
naalegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table naa_file add  constraint naa_pk primary key  (naa01) enable validate;
grant select on naa_file to tiptopgp;
grant update on naa_file to tiptopgp;
grant delete on naa_file to tiptopgp;
grant insert on naa_file to tiptopgp;
grant index on naa_file to public;
grant select on naa_file to ods;
