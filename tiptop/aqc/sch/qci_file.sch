/*
================================================================================
檔案代號:qci_file
檔案名稱:FQC 序号档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qci_file
(
qci01       varchar2(20) NOT NULL,   /*FQC 单号                               */
                                     /*FQC 單號                               */
qci02       varchar2(15) NOT NULL,   /*序号                                   */
                                     /*序號                                   */
qciplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
qcilegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table qci_file add  constraint qci_pk primary key  (qci01,qci02) enable validate;
grant select on qci_file to tiptopgp;
grant update on qci_file to tiptopgp;
grant delete on qci_file to tiptopgp;
grant insert on qci_file to tiptopgp;
grant index on qci_file to public;
grant select on qci_file to ods;
