/*
================================================================================
檔案代號:qcnn_file
檔案名稱:PQC 质量检验单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qcnn_file
(
qcnn01      varchar2(20),            /*收货单号                               */
                                     /*收貨單號                               */
qcnn03      number(5),               /*行序                                   */
qcnn04      number(15,3),            /*测量值                                 */
                                     /*測量值                                 */
qcnnplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
qcnnlegal   varchar2(10) NOT NULL    /*所属法人                               */
);

create        index qcnn_01 on qcnn_file (qcnn01,qcnn03);
grant select on qcnn_file to tiptopgp;
grant update on qcnn_file to tiptopgp;
grant delete on qcnn_file to tiptopgp;
grant insert on qcnn_file to tiptopgp;
grant index on qcnn_file to public;
grant select on qcnn_file to ods;
