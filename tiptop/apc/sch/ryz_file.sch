/*
================================================================================
檔案代號:ryz_file
檔案名稱:POS接口参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table ryz_file
(
ryz01       varchar2(1) DEFAULT '0' NOT NULL, /*KEY VALUE(0)*/
ryz02       varchar2(1) DEFAULT ' ' NOT NULL, /*POS销售上传方式:1-汇总,2-明细*/
ryzcrat     date,                    /*资料创建日                             */
ryzdate     date,                    /*资料更改日                             */
ryzgrup     varchar2(10),            /*资料所有部门                           */
ryzmodu     varchar2(10),            /*资料更改者                             */
ryzorig     varchar2(10),            /*资料建立部门                           */
ryzoriu     varchar2(10),            /*资料建立者                             */
ryzuser     varchar2(10),            /*资料所有者                             */
ryz03       number(5),               /*码长                                   */
ryz04       varchar2(1) DEFAULT ' ' NOT NULL, /*单别位数*/
ryz05       varchar2(1) DEFAULT ' ' NOT NULL, /*单号位数*/
ryz06       varchar2(1) DEFAULT ' ' NOT NULL, /*自动编号方式*/
ryz07       varchar2(1) DEFAULT ' ' NOT NULL, /*系统单号编入Plant Code*/
ryz08       varchar2(1) DEFAULT 'N' NOT NULL,
ryz09       varchar2(1) DEFAULT ' ' NOT NULL,
ryz10       varchar2(1) DEFAULT ' ' NOT NULL,
ryz11       number(10)               /*上传批量提交笔数                       */
);

alter table ryz_file add  constraint ryz_pk primary key  (ryz01) enable validate;
grant select on ryz_file to tiptopgp;
grant update on ryz_file to tiptopgp;
grant delete on ryz_file to tiptopgp;
grant insert on ryz_file to tiptopgp;
grant index on ryz_file to public;
grant select on ryz_file to ods;
