/*
================================================================================
檔案代號:qcv_file
檔案名稱:质量检验单身备注档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qcv_file
(
qcv01       varchar2(20),            /*收货单号                               */
                                     /*收貨單號                               */
qcv02       number(5),               /*收货项次                               */
                                     /*收貨項次                               */
qcv021      number(5),               /*分批检验顺序                           */
                                     /*分批檢驗順序                           */
qcv03       number(5),               /*行序                                   */
qcv04       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
qcvplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
qcvlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index qcv_01 on qcv_file (qcv01,qcv02,qcv021,qcv03);
grant select on qcv_file to tiptopgp;
grant update on qcv_file to tiptopgp;
grant delete on qcv_file to tiptopgp;
grant insert on qcv_file to tiptopgp;
grant index on qcv_file to public;
grant select on qcv_file to ods;
