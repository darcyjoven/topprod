/*
================================================================================
檔案代號:rtd_file
檔案名稱:商品策略单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rtd_file
(
rtd01       varchar2(10) DEFAULT ' ' NOT NULL, /*产品策略编号*/
rtd02       varchar2(40),            /*产品策略名称                           */
rtd03       varchar2(10),            /*制定營運中心                           */
rtd04       number(5),               /*变更序号                               */
rtd05       varchar2(255),           /*备注                                   */
rtdacti     varchar2(1),             /*资料有效码                             */
rtdcond     date,                    /*审核时间                               */
rtdconf     varchar2(1),             /*确认码                                 */
rtdconu     varchar2(10),            /*审核人员                               */
rtdcrat     date,                    /*资料创建日                             */
rtddate     date,                    /*最近更改日                             */
rtdgrup     varchar2(10),            /*资料所有部门                           */
rtdmodu     varchar2(10),            /*资料更改者                             */
rtduser     varchar2(10),            /*资料所有者                             */
rtdoriu     varchar2(10),            /*资料建立者                             */
rtdorig     varchar2(10)             /*资料建立部门                           */
);

alter table rtd_file add  constraint rtd_pk primary key  (rtd01) enable validate;
grant select on rtd_file to tiptopgp;
grant update on rtd_file to tiptopgp;
grant delete on rtd_file to tiptopgp;
grant insert on rtd_file to tiptopgp;
grant index on rtd_file to public;
grant select on rtd_file to ods;
