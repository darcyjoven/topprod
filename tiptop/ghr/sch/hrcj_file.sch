/*
================================================================================
檔案代號:hrcj_file
檔案名稱:考勤统计表
檔案目的:
上游檔案:
下游檔案:hrcja_file
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcj_file
(
hrcj01      number(15) NOT NULL,     /*考勤统计编号                           */
hrcj02      varchar2(20) NOT NULL,   /*公司编号                               */
hrcj03      varchar2(20) NOT NULL,   /*考勤区间编号                           */
hrcj04      number(5),               /*考勤区间项次                           */
hrcj05      varchar2(255),           /*备注                                   */
hrcjconf    varchar2(1),             /*审核否                                 */
hrcjacti    varchar2(1),             /*资料有效否                             */
hrcjud01    varchar2(255),
hrcjud02    varchar2(40),
hrcjud03    varchar2(40),
hrcjud04    varchar2(40),
hrcjud05    varchar2(40),
hrcjud06    varchar2(40),
hrcjud07    number(15,3),
hrcjud08    number(15,3),
hrcjud09    number(15,3),
hrcjud10    number(10),
hrcjud11    number(10),
hrcjud12    number(10),
hrcjud13    date,
hrcjud14    date,
hrcjud15    date,
hrcjuser    varchar2(10),
hrcjgrup    varchar2(10),
hrcjmodu    varchar2(10),
hrcjdate    date,
hrcjoriu    varchar2(10),
hrcjorig    varchar2(10)
);

create        index hrcj_02 on hrcj_file (hrcj02,hrcj03,hrcj04);
alter table hrcj_file add  constraint tpc_hrcj_pk primary key  (hrcj01) enable validate;
grant select on hrcj_file to tiptopgp;
grant update on hrcj_file to tiptopgp;
grant delete on hrcj_file to tiptopgp;
grant insert on hrcj_file to tiptopgp;
grant index on hrcj_file to public;
grant select on hrcj_file to ods;
