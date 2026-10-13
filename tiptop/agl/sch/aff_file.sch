/*
================================================================================
檔案代號:aff_file
檔案名稱:核算项预算资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aff_file
(
aff00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
aff01       number(5) DEFAULT '0' NOT NULL, /*会计年度*/
aff02       varchar2(10) DEFAULT ' ' NOT NULL, /*预算项目*/
aff03       varchar2(24) DEFAULT ' ' NOT NULL, /*会计科目*/
aff04       varchar2(10) NOT NULL,   /*部门编号                               */
aff05       varchar2(1) DEFAULT ' ' NOT NULL, /*核算项别*/
aff06       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项值*/
aff07       varchar2(1),             /*以单位维护                             */
aff08       varchar2(1),             /*各期预算分配方式                       */
aff09       number(20,6),            /*年度预算                               */
aff10       number(20,6),            /*第一季预算                             */
aff11       number(20,6),            /*第二季预算                             */
aff12       number(20,6),            /*第三季预算                             */
aff13       number(20,6),            /*第四季预算                             */
affacti     varchar2(1),             /*资料有效码                             */
affdate     date,                    /*最近更改日                             */
affgrup     varchar2(10),            /*资料所有群                             */
affmodu     varchar2(10),            /*资料更改者                             */
affuser     varchar2(10),            /*资料所有者                             */
afforiu     varchar2(10),            /*资料建立者                             */
afforig     varchar2(10)             /*资料建立部门                           */
);

alter table aff_file add  constraint aff_pk primary key  (aff00,aff01,aff02,aff03,aff04,aff05,aff06) enable validate;
grant select on aff_file to tiptopgp;
grant update on aff_file to tiptopgp;
grant delete on aff_file to tiptopgp;
grant insert on aff_file to tiptopgp;
grant index on aff_file to public;
grant select on aff_file to ods;
