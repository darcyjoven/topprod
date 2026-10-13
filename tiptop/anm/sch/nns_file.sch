/*
================================================================================
檔案代號:nns_file
檔案名稱:融资贷款担保票据
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nns_file
(
nns01       varchar2(20) NOT NULL,   /*相关单号                               */
                                     /*相關單號                               */
nns02       number(5) NOT NULL,      /*行序                                   */
nns03       varchar2(20) NOT NULL,   /*票号                                   */
                                     /*票號                                   */
nns04       varchar2(20),            /*收票单号                               */
                                     /*收票單號                               */
nns05       varchar2(1),             /*No Use                                 */
nns06       varchar2(1),             /*No Use                                 */
nnslegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table nns_file add  constraint nns_pk primary key  (nns01,nns02,nns03) enable validate;
grant select on nns_file to tiptopgp;
grant update on nns_file to tiptopgp;
grant delete on nns_file to tiptopgp;
grant insert on nns_file to tiptopgp;
grant index on nns_file to public;
grant select on nns_file to ods;
