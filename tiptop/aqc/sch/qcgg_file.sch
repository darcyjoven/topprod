/*
================================================================================
檔案代號:qcgg_file
檔案名稱:FQC 质量检验单身测量值档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qcgg_file
(
qcgg01      varchar2(20),            /*收货单号                               */
                                     /*收貨單號                               */
qcgg03      number(5),               /*单身行序                               */
                                     /*單身行序                               */
qcgg04      number(15,3),            /*测量值                                 */
                                     /*測量值                                 */
qcggplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
qcgglegal   varchar2(10) NOT NULL    /*所属法人                               */
);

create        index qcgg_01 on qcgg_file (qcgg01,qcgg03);
grant select on qcgg_file to tiptopgp;
grant update on qcgg_file to tiptopgp;
grant delete on qcgg_file to tiptopgp;
grant insert on qcgg_file to tiptopgp;
grant index on qcgg_file to public;
grant select on qcgg_file to ods;
