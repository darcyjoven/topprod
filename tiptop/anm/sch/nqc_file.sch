/*
================================================================================
檔案代號:nqc_file
檔案名稱:资金模拟汇率设置
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nqc_file
(
nqc01       varchar2(4) NOT NULL,    /*集团币种                               */
nqc02       varchar2(4) NOT NULL,    /*营运币种                               */
nqc03       number(5) NOT NULL,      /*年度                                   */
nqc04       number(5) NOT NULL,      /*期别                                   */
nqc05       number(20,10),           /*预计汇率                               */
nqcacti     varchar2(1),             /*资料有效码                             */
nqcuser     varchar2(10),            /*资料所有者                             */
nqcgrup     varchar2(10),            /*资料所有群                             */
nqcmodu     varchar2(10),            /*资料更改者                             */
nqcdate     date,                    /*最近更改日                             */
nqcorig     varchar2(10),            /*资料建立部门                           */
nqcoriu     varchar2(10)             /*资料建立者                             */
);

alter table nqc_file add  constraint nqc_pk primary key  (nqc01,nqc02,nqc03,nqc04) enable validate;
grant select on nqc_file to tiptopgp;
grant update on nqc_file to tiptopgp;
grant delete on nqc_file to tiptopgp;
grant insert on nqc_file to tiptopgp;
grant index on nqc_file to public;
grant select on nqc_file to ods;
