/*
================================================================================
檔案代號:ltf_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ltf_file
(
ltf01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据号*/
ltf02       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
ltf03       number(5) DEFAULT '0' NOT NULL, /*项次*/
ltf04       varchar2(10),            /*生效門店                               */
ltf05       varchar2(20),            /*摊位编号                               */
ltf06       varchar2(1),             /*变更类型                               */
ltf07       varchar2(1) DEFAULT ' ' NOT NULL, /*有效否*/
ltflegal    varchar2(10) NOT NULL,   /*所属法人                               */
ltfplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table ltf_file add  constraint ltf_pk primary key  (ltf01,ltf02,ltf03) enable validate;
grant select on ltf_file to tiptopgp;
grant update on ltf_file to tiptopgp;
grant delete on ltf_file to tiptopgp;
grant insert on ltf_file to tiptopgp;
grant index on ltf_file to public;
grant select on ltf_file to ods;
