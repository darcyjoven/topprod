/*
================================================================================
檔案代號:qcj_file
檔案名稱:C=0抽样计划样本代码资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table qcj_file
(
qcj01       number(10) NOT NULL,     /*起始批量                               */
qcj02       number(10) NOT NULL,     /*截止批量                               */
qcj03       number(7,3) NOT NULL,    /*AQL指标                                */
                                     /*AQL指標                                */
qcj04       varchar2(1) NOT NULL,    /*级数                                   */
                                     /*級數                                   */
qcj05       number(5)                /*检验样本                               */
                                     /*檢驗樣本                               */
);

alter table qcj_file add  constraint qcj_pk primary key  (qcj01,qcj02,qcj03,qcj04) enable validate;
grant select on qcj_file to tiptopgp;
grant update on qcj_file to tiptopgp;
grant delete on qcj_file to tiptopgp;
grant insert on qcj_file to tiptopgp;
grant index on qcj_file to public;
grant select on qcj_file to ods;
