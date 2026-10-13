/*
================================================================================
檔案代號:nnq_file
檔案名稱:合约借款额度摘要档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nnq_file
(
nnq01       varchar2(10) NOT NULL,   /*合约号码                               */
                                     /*合約號碼                               */
nnq02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
nnq03       number(5) NOT NULL,      /*行序                                   */
nnq04       varchar2(255),           /*限制条款                               */
                                     /*限制條款                               */
nnq05       varchar2(255)            /*摘要性质                               */
                                     /*摘要性質                               */
);

alter table nnq_file add  constraint nnq_pk primary key  (nnq01,nnq02,nnq03) enable validate;
grant select on nnq_file to tiptopgp;
grant update on nnq_file to tiptopgp;
grant delete on nnq_file to tiptopgp;
grant insert on nnq_file to tiptopgp;
grant index on nnq_file to public;
grant select on nnq_file to ods;
