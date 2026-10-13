/*
================================================================================
檔案代號:qcy_file
檔案名稱:DATE CODE 维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qcy_file
(
qcy01       varchar2(20) NOT NULL,   /*收货单号                               */
                                     /*收貨單號                               */
qcy02       number(5) NOT NULL,      /*收货项次                               */
                                     /*收貨項次                               */
qcy03       number(5) NOT NULL,      /*行序                                   */
qcy04       varchar2(8),             /*No Use                                 */
qcy05       number(15,3),            /*数量                                   */
                                     /*數量                                   */
qcyplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
qcylegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table qcy_file add  constraint qcy_pk primary key  (qcy01,qcy02,qcy03) enable validate;
grant select on qcy_file to tiptopgp;
grant update on qcy_file to tiptopgp;
grant delete on qcy_file to tiptopgp;
grant insert on qcy_file to tiptopgp;
grant index on qcy_file to public;
grant select on qcy_file to ods;
