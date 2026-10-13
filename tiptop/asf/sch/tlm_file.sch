/*
================================================================================
檔案代號:tlm_file
檔案名稱:单号记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tlm_file
(
tlm01       varchar2(20) NOT NULL,   /*参考单号                               */
tlm02       varchar2(20) NOT NULL,   /*单据编号                               */
tlm03       varchar2(10) NOT NULL,   /*异动指令                               */
tlm04       date,                    /*生成日期                               */
tlm05       varchar2(8),             /*生成时间                               */
tlm06       varchar2(10),            /*生成者                                 */
tlmplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tlmlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tlm_file add  constraint tlm_pk primary key  (tlm01,tlm02,tlm03) enable validate;
grant select on tlm_file to tiptopgp;
grant update on tlm_file to tiptopgp;
grant delete on tlm_file to tiptopgp;
grant insert on tlm_file to tiptopgp;
grant index on tlm_file to public;
grant select on tlm_file to ods;
