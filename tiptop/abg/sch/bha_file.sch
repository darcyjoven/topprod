/*
================================================================================
檔案代號:bha_file
檔案名稱:费用项目提拨单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bha_file
(
bha01       varchar2(10) NOT NULL,   /*版本                                   */
bha02       number(5) NOT NULL,      /*年度                                   */
bha03       varchar2(6) NOT NULL,    /*费用项目                               */
                                     /*費用項目                               */
bha04       number(5),               /*转换月基数                             */
                                     /*轉換月基數                             */
bha05       number(20,6),            /*提拨后金额                             */
                                     /*提撥後金額                             */
bhaacti     varchar2(1),             /*资料有效码                             */
bhauser     varchar2(10),            /*资料所有者                             */
bhagrup     varchar2(10),            /*资料所有部门                           */
bhamodu     varchar2(10),            /*资料更改者                             */
bhadate     date,                    /*最近更改日                             */
bhaoriu     varchar2(10),            /*资料建立者                             */
bhaorig     varchar2(10)             /*资料建立部门                           */
);

alter table bha_file add  constraint bha_pk primary key  (bha01,bha02,bha03) enable validate;
grant select on bha_file to tiptopgp;
grant update on bha_file to tiptopgp;
grant delete on bha_file to tiptopgp;
grant insert on bha_file to tiptopgp;
grant index on bha_file to public;
grant select on bha_file to ods;
