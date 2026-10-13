/*
================================================================================
檔案代號:tc_shf_file
檔案名稱:报工时间
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table tc_shf_file
(
tc_shf01    varchar2(20) NOT NULL,   /*报工单号                               */
                                     /*                                       */
tc_shf02    date,                    /*开工时间（S）                          */
tc_shf03    date,                    /*完工时间（S）                          */
tc_shf04    date,                    /*上站完工时间（S）                      */
tc_shf05    varchar2(1) DEFAULT 'N', /*首站                                   */
tc_shf06    varchar2(1) DEFAULT 'N', /*末站                                   */
tc_shf07    varchar2(20),            /*LOT                                    */
tc_shf08    number(5)                /*工序                                   */
);

alter table tc_shf_file add  constraint tpc_shf_pk primary key  (tc_shf01) enable validate;
grant select on tc_shf_file to tiptopgp;
grant update on tc_shf_file to tiptopgp;
grant delete on tc_shf_file to tiptopgp;
grant insert on tc_shf_file to tiptopgp;
grant index on tc_shf_file to public;
grant select on tc_shf_file to ods;
