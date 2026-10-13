/*
================================================================================
檔案代號:lsl_file
檔案名稱:兑换方案代码档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table lsl_file
(
lsl01       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
lsl02       varchar2(20) DEFAULT ' ' NOT NULL, /*兑换方案代码*/
lsl03       varchar2(50),            /*兑换方案说明                           */
lsl04       date DEFAULT sysdate NOT NULL, /*起始日期*/
lsl05       date DEFAULT sysdate NOT NULL, /*截止日期*/
lsl06       varchar2(50),            /*备注                                   */
lslacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lslcond     date,                    /*审核日期                               */
lslconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
lslconu     varchar2(10),            /*审核人员                               */
lslcrat     date,                    /*资料创建日                             */
lsldate     date,                    /*最近更改日                             */
lslgrup     varchar2(10),            /*资料所有群                             */
lslmodu     varchar2(10),            /*资料更改者                             */
lslorig     varchar2(10),            /*资料建立部门                           */
lsloriu     varchar2(10),            /*资料建立者                             */
lsluser     varchar2(10)             /*资料所有者                             */
);

alter table lsl_file add  constraint lsl_pk primary key  (lsl01,lsl02) enable validate;
grant select on lsl_file to tiptopgp;
grant update on lsl_file to tiptopgp;
grant delete on lsl_file to tiptopgp;
grant insert on lsl_file to tiptopgp;
grant index on lsl_file to public;
grant select on lsl_file to ods;
