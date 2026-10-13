/*
================================================================================
檔案代號:fif_file
檔案名稱:仪表基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fif_file
(
fif01       varchar2(10) NOT NULL,   /*仪表编号                               */
fif02       varchar2(80),            /*名称                                   */
fif03       varchar2(10),            /*信号标记                               */
fif04       varchar2(4),             /*度量单位                               */
fif05       number(15,3),            /*平均仪表单位/天                        */
fif06       varchar2(1),             /*运行时间/周期                          */
fif07       varchar2(1),             /*更换/累加                              */
fif08       number(5),               /*循环次数                               */
fif09       number(15,3),            /*循环点                                 */
fif10       varchar2(1),             /*No Use                                 */
fif11       varchar2(1),             /*No Use                                 */
fif12       varchar2(1),             /*No Use                                 */
fif13       varchar2(1),             /*No Use                                 */
fif14       varchar2(1),             /*No Use                                 */
fif15       varchar2(1)              /*No Use                                 */
);

alter table fif_file add  constraint fif_pk primary key  (fif01) enable validate;
grant select on fif_file to tiptopgp;
grant update on fif_file to tiptopgp;
grant delete on fif_file to tiptopgp;
grant insert on fif_file to tiptopgp;
grant index on fif_file to public;
grant select on fif_file to ods;
