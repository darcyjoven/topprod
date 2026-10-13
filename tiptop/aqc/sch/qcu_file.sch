/*
================================================================================
檔案代號:qcu_file
檔案名稱:质量检验单身不良原因档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qcu_file
(
qcu01       varchar2(20),            /*收货单号                               */
                                     /*收貨單號                               */
qcu02       number(5),               /*收货项次                               */
                                     /*收貨項次                               */
qcu021      number(5),               /*分批检验顺序                           */
                                     /*分批檢驗順序                           */
qcu03       number(5),               /*行序                                   */
qcu04       varchar2(10),            /*不良原因                               */
                                     /*不良原因 (ref. qce_file for qce02)     */
qcu05       number(15,3),            /*不良数量                               */
                                     /*不良數量                               */
qcuicd01    varchar2(3),             /*Wafer刻号                              */
qcuicd02    varchar2(10),            /*检验区域                               */
qcuplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
qculegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index qcu_01 on qcu_file (qcu01,qcu02,qcu021,qcu03);
grant select on qcu_file to tiptopgp;
grant update on qcu_file to tiptopgp;
grant delete on qcu_file to tiptopgp;
grant insert on qcu_file to tiptopgp;
grant index on qcu_file to public;
grant select on qcu_file to ods;
