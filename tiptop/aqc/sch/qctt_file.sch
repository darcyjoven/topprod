/*
================================================================================
檔案代號:qctt_file
檔案名稱:质量检验单身测量值档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qctt_file
(
qctt01      varchar2(20),            /*收货单号                               */
                                     /*收貨單號      (qcs01)                  */
qctt02      number(5),               /*收货项次                               */
                                     /*收貨項次      (qcs02)                  */
qctt021     number(5),               /*分批检验顺序                           */
                                     /*分批檢驗順序  (qcs05)                  */
qctt03      number(5),               /*单身行序                               */
                                     /*單身行序                               */
qctt04      number(15,3),            /*测量值                                 */
                                     /*測量值                                 */
qcttplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
qcttlegal   varchar2(10) NOT NULL    /*所属法人                               */
);

create        index qctt_01 on qctt_file (qctt01,qctt02,qctt021,qctt03);
grant select on qctt_file to tiptopgp;
grant update on qctt_file to tiptopgp;
grant delete on qctt_file to tiptopgp;
grant insert on qctt_file to tiptopgp;
grant index on qctt_file to public;
grant select on qctt_file to ods;
