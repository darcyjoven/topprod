/*
================================================================================
檔案代號:asc_file
檔案名稱:关联企业异动维护作业（单头）
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table asc_file
(
asc01       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
asc02       varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司代号*/
asc03       varchar2(5) DEFAULT ' ' NOT NULL, /*上层公司帐套*/
asc031      varchar2(1),             /*NO USE                                 */
asc04       varchar2(1),             /*NO USE                                 */
asc05       varchar2(1),             /*NO USE                                 */
asc06       date DEFAULT sysdate NOT NULL, /*异动日期*/
asc07       number(5),               /*NO USE                                 */
asc08       varchar2(1),             /*NO USE                                 */
asc09       varchar2(1),             /*NO USE                                 */
asc10       varchar2(1),             /*no use                                 */
ascconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
ascdate     date,                    /*最近更改日                             */
ascgrup     varchar2(10),            /*资料所有群                             */
ascmodu     varchar2(10),            /*资料更改者                             */
ascorig     varchar2(10),            /*资料建立部门                           */
ascoriu     varchar2(10),            /*资料建立者                             */
ascuser     varchar2(10)             /*资料所有者                             */
);

alter table asc_file add  constraint asc_pk primary key  (asc01,asc02,asc03,asc06) enable validate;
grant select on asc_file to tiptopgp;
grant update on asc_file to tiptopgp;
grant delete on asc_file to tiptopgp;
grant insert on asc_file to tiptopgp;
grant index on asc_file to public;
grant select on asc_file to ods;
